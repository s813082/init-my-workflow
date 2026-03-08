// Initialize Theme
function initTheme() {
    const savedTheme = localStorage.getItem('theme') || (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
    setTheme(savedTheme);
}

function setTheme(theme) {
    const html = document.documentElement;
    const icon = document.getElementById('theme-icon');
    
    if (theme === 'dark') {
        html.classList.add('dark');
        html.classList.remove('light');
        if (icon) icon.classList.replace('fa-sun', 'fa-moon');
    } else {
        html.classList.add('light');
        html.classList.remove('dark');
        if (icon) icon.classList.replace('fa-moon', 'fa-sun');
    }
    localStorage.setItem('theme', theme);
}

function toggleTheme() {
    const currentTheme = document.documentElement.classList.contains('dark') ? 'light' : 'dark';
    setTheme(currentTheme);
}

// Copy Command
function copyCommand(id = 'copy-toast') {
    const cmd = 'git clone https://github.com/s813082/init-my-workflow.git ~/Documents/init-my-workflow && sudo chown -R $(whoami) /usr/local/share/man/man8 && cd ~/Documents/init-my-workflow && chmod +x install.sh && ./install.sh';
    navigator.clipboard.writeText(cmd).then(() => {
        const toast = document.getElementById(id);
        if (toast) {
            toast.style.opacity = '1';
            setTimeout(() => { toast.style.opacity = '0'; }, 2000);
        }
    });
}

// Navbar Scroll Effect
function initNavbar() {
    const nav = document.querySelector('nav');
    window.addEventListener('scroll', () => {
        if (window.scrollY > 20) {
            nav.classList.add('glass', 'shadow-sm');
            nav.classList.remove('bg-transparent');
        } else {
            nav.classList.remove('glass', 'shadow-sm');
        }
    });
}

// Active Nav Link
function setActiveLink() {
    const currentPath = window.location.pathname.split('/').pop() || 'index.html';
    const links = document.querySelectorAll('.nav-link');
    links.forEach(link => {
        if (link.getAttribute('href') === currentPath) {
            link.classList.add('active');
        }
    });
}

// Run on Load
document.addEventListener('DOMContentLoaded', () => {
    initTheme();
    initNavbar();
    setActiveLink();
});
