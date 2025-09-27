function vote() {
    const votingSection = document.getElementById('voting-section');
    const thanksSection = document.getElementById('thanks-section');

    // Hide voting section with animation
    votingSection.classList.add('hidden');

    // Show thanks section after a delay
    setTimeout(() => {
        thanksSection.classList.add('show');
    }, 300);
}

function reset() {
    const votingSection = document.getElementById('voting-section');
    const thanksSection = document.getElementById('thanks-section');

    // Hide thanks section
    thanksSection.classList.remove('show');

    // Show voting section after a delay
    setTimeout(() => {
        votingSection.classList.remove('hidden');
    }, 300);
}

// Add some hover effects
document.addEventListener('DOMContentLoaded', function() {
    const buttons = document.querySelectorAll('button');
    buttons.forEach(button => {
        button.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-2px) scale(1.05)';
        });

        button.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0) scale(1)';
        });
    });
});
