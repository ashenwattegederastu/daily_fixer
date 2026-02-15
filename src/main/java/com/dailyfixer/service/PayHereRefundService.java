package com.dailyfixer.service;

import com.dailyfixer.config.PayHereConfig;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

/**
 * Service class for PayHere Refund API integration.
 *
 * Handles:
 * 1. OAuth token retrieval and caching
 * 2. Payment refund requests
 *
 * Uses Java's built-in HttpClient (no external dependencies).
 */
public class PayHereRefundService {

    private final HttpClient httpClient;

    // Cached access token and expiry
    private String cachedAccessToken;
    private long tokenExpiryTime; // epoch millis

    public PayHereRefundService() {
        this.httpClient = HttpClient.newHttpClient();
    }

    // ==================== Result Classes ====================

    /**
     * Represents the result of a refund operation.
     */
    public static class RefundResult {
        private final boolean success;
        private final String message;
        private final String refundNumber;
        private final int statusCode;

        public RefundResult(boolean success, String message, String refundNumber, int statusCode) {
            this.success = success;
            this.message = message;
            this.refundNumber = refundNumber;
            this.statusCode = statusCode;
        }

        public boolean isSuccess() {
            return success;
        }

        public String getMessage() {
            return message;
        }

        public String getRefundNumber() {
            return refundNumber;
        }

        public int getStatusCode() {
            return statusCode;
        }

        @Override
        public String toString() {
            return "RefundResult{success=" + success + ", message='" + message + "', refundNumber='" + refundNumber
                    + "', statusCode=" + statusCode + "}";
        }
    }

    // ==================== OAuth Token ====================

    /**
     * Get a valid access token, refreshing if expired or not yet obtained.
     *
     * @return Access token string
     * @throws IOException          if the request fails
     * @throws InterruptedException if the request is interrupted
     */
    public String getAccessToken() throws IOException, InterruptedException {
        // Return cached token if still valid (with 30-second buffer)
        if (cachedAccessToken != null && System.currentTimeMillis() < (tokenExpiryTime - 30000)) {
            System.out.println("PayHereRefundService: Using cached access token");
            return cachedAccessToken;
        }

        System.out.println("PayHereRefundService: Fetching new access token...");

        String appId = PayHereConfig.getAppId();
        String appSecret = PayHereConfig.getAppSecret();
        String oauthUrl = PayHereConfig.getOAuthUrl();

        if (appId.isEmpty() || appSecret.isEmpty()) {
            throw new IOException("PayHere App ID or App Secret not configured in config.properties");
        }

        // Create Base64 Authorization code: Base64(appId:appSecret)
        String credentials = appId + ":" + appSecret;
        String authCode = Base64.getEncoder().encodeToString(credentials.getBytes(StandardCharsets.UTF_8));

        // Build request
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(oauthUrl))
                .header("Authorization", "Basic " + authCode)
                .header("Content-Type", "application/x-www-form-urlencoded")
                .POST(HttpRequest.BodyPublishers.ofString("grant_type=client_credentials"))
                .build();

        // Send request
        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
        String responseBody = response.body();

        System.out.println("OAuth Response Status: " + response.statusCode());
        System.out.println("OAuth Response Body: " + responseBody);

        if (response.statusCode() != 200) {
            throw new IOException("Failed to get access token. HTTP " + response.statusCode() + ": " + responseBody);
        }

        // Parse access_token and expires_in from JSON response
        String accessToken = extractJsonString(responseBody, "access_token");
        String expiresInStr = extractJsonValue(responseBody, "expires_in");

        if (accessToken == null || accessToken.isEmpty()) {
            throw new IOException("No access_token in OAuth response: " + responseBody);
        }

        // Cache the token
        cachedAccessToken = accessToken;
        try {
            int expiresIn = Integer.parseInt(expiresInStr.trim());
            tokenExpiryTime = System.currentTimeMillis() + (expiresIn * 1000L);
        } catch (NumberFormatException e) {
            // Default to 9 minutes if parsing fails
            tokenExpiryTime = System.currentTimeMillis() + (540 * 1000L);
        }

        System.out.println("PayHereRefundService: Got access token, expires at: " + tokenExpiryTime);
        return cachedAccessToken;
    }

    // ==================== Refund Payment ====================

    /**
     * Refund a payment via PayHere Refund API.
     *
     * @param paymentId   The PayHere payment_id to refund
     * @param description Reason for the refund
     * @return RefundResult with status information
     */
    public RefundResult refundPayment(String paymentId, String description) {
        try {
            String accessToken = getAccessToken();
            String refundUrl = PayHereConfig.getRefundUrl();

            // Build JSON body
            String jsonBody = "{\"payment_id\":\"" + escapeJson(paymentId) + "\","
                    + "\"description\":\"" + escapeJson(description) + "\"}";

            System.out.println("PayHereRefundService: Sending refund request...");
            System.out.println("  URL: " + refundUrl);
            System.out.println("  Body: " + jsonBody);

            // Build request
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(refundUrl))
                    .header("Authorization", "Bearer " + accessToken)
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(jsonBody))
                    .build();

            // Send request
            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            String responseBody = response.body();

            System.out.println("Refund Response Status: " + response.statusCode());
            System.out.println("Refund Response Body: " + responseBody);

            // Check for token errors (HTTP 401)
            if (response.statusCode() == 401) {
                // Token might be expired, try refreshing
                System.out.println("Access token may be expired, refreshing...");
                cachedAccessToken = null;
                tokenExpiryTime = 0;

                accessToken = getAccessToken();
                request = HttpRequest.newBuilder()
                        .uri(URI.create(refundUrl))
                        .header("Authorization", "Bearer " + accessToken)
                        .header("Content-Type", "application/json")
                        .POST(HttpRequest.BodyPublishers.ofString(jsonBody))
                        .build();
                response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
                responseBody = response.body();

                System.out.println("Retry Refund Response Status: " + response.statusCode());
                System.out.println("Retry Refund Response Body: " + responseBody);
            }

            // Check for error field (invalid_token response)
            String error = extractJsonString(responseBody, "error");
            if (error != null && !error.isEmpty()) {
                String errorDesc = extractJsonString(responseBody, "error_description");
                return new RefundResult(false, "PayHere error: " + error + " - " + errorDesc, null, -1);
            }

            // Parse refund response
            String statusStr = extractJsonValue(responseBody, "status");
            String msg = extractJsonString(responseBody, "msg");
            String data = extractJsonValue(responseBody, "data");

            int status;
            try {
                status = Integer.parseInt(statusStr.trim());
            } catch (NumberFormatException e) {
                return new RefundResult(false, "Invalid status in response: " + responseBody, null, -1);
            }

            if (status == 1) {
                // Success
                String refundNumber = (data != null && !data.equals("null")) ? data.trim() : null;
                return new RefundResult(true, msg, refundNumber, status);
            } else {
                // Error (status 0 or -1)
                return new RefundResult(false, msg != null ? msg : "Refund failed", null, status);
            }

        } catch (IOException | InterruptedException e) {
            System.err.println("PayHereRefundService: Error processing refund: " + e.getMessage());
            e.printStackTrace();
            return new RefundResult(false, "Error communicating with PayHere: " + e.getMessage(), null, -1);
        }
    }

    // ==================== JSON Helpers ====================

    /**
     * Extract a string value from a JSON response (simple parser, no library
     * needed).
     * Handles: "key": "value"
     */
    private String extractJsonString(String json, String key) {
        String pattern = "\"" + key + "\"";
        int keyIndex = json.indexOf(pattern);
        if (keyIndex == -1)
            return null;

        // Find the colon after the key
        int colonIndex = json.indexOf(':', keyIndex + pattern.length());
        if (colonIndex == -1)
            return null;

        // Find the opening quote of the value
        int startQuote = json.indexOf('"', colonIndex + 1);
        if (startQuote == -1)
            return null;

        // Find the closing quote (handle escaped quotes)
        int endQuote = startQuote + 1;
        while (endQuote < json.length()) {
            if (json.charAt(endQuote) == '"' && json.charAt(endQuote - 1) != '\\') {
                break;
            }
            endQuote++;
        }

        if (endQuote >= json.length())
            return null;
        return json.substring(startQuote + 1, endQuote);
    }

    /**
     * Extract a raw value (number, null, etc.) from a JSON response.
     * Handles: "key": 123 or "key": null
     */
    private String extractJsonValue(String json, String key) {
        String pattern = "\"" + key + "\"";
        int keyIndex = json.indexOf(pattern);
        if (keyIndex == -1)
            return null;

        // Find the colon
        int colonIndex = json.indexOf(':', keyIndex + pattern.length());
        if (colonIndex == -1)
            return null;

        // Skip whitespace
        int valueStart = colonIndex + 1;
        while (valueStart < json.length() && json.charAt(valueStart) == ' ') {
            valueStart++;
        }

        // Check if it's a string value (starts with quote)
        if (valueStart < json.length() && json.charAt(valueStart) == '"') {
            return extractJsonString(json, key);
        }

        // Find the end of the value (comma, closing brace, or bracket)
        int valueEnd = valueStart;
        while (valueEnd < json.length() && json.charAt(valueEnd) != ',' && json.charAt(valueEnd) != '}'
                && json.charAt(valueEnd) != ']') {
            valueEnd++;
        }

        return json.substring(valueStart, valueEnd).trim();
    }

    /**
     * Escape special characters for JSON string values.
     */
    private String escapeJson(String input) {
        if (input == null)
            return "";
        return input
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
