/**
 * showToast(message, type)
 * type: 'success' | 'error' | 'info'
 * Ensures #toast-container exists and shows a styled toast that auto-dismisses.
 */
function showToast(message, type) {
    type = type || 'info';
    var container = document.getElementById('toast-container');
    if (!container) {
        container = document.createElement('div');
        container.id = 'toast-container';
        document.body.appendChild(container);
    }

    var icons = {
        success: '✓',
        error: '✕',
        info: 'ℹ'
    };

    var toast = document.createElement('div');
    toast.className = 'toast toast-' + type;
    toast.setAttribute('role', 'alert');
    toast.innerHTML = '<span class="toast-icon">' + (icons[type] || icons.info) + '</span><span class="toast-message">' + escapeHtml(message) + '</span>';
    container.appendChild(toast);

    var duration = type === 'error' ? 5000 : 3500;
    var exitDuration = 300;

    setTimeout(function() {
        toast.classList.add('toast-exit');
        setTimeout(function() {
            if (toast.parentNode) {
                toast.parentNode.removeChild(toast);
            }
        }, exitDuration);
    }, duration);
}

function escapeHtml(text) {
    if (!text) return '';
    var div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}
