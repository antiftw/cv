document.addEventListener("DOMContentLoaded", () => {
    const progressBars = document.getElementsByClassName('progress-bar');
    for(var index = 0; index < progressBars.length; index++) {
        var progress = progressBars[index];
        const percentage = progress.getAttribute('aria-valuenow');;
        progress.style.width = percentage;
    }
});