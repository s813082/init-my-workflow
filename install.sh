#!/bin/bash

# macOS Environment Installation Script
# Usage: cd ~/Documents/init-my-workflow && chmod +x install.sh && ./install.sh

DOTFILES_DIR="/Users/lisa20260130/Documents/init-my-workflow"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

echo "============================================"
echo "macOS Initialization Started"
echo "============================================"

# Utility: Installation Inquiry
ask_install() {
    local name=$1
    echo -n "Install [$name]? (y/n) "
    read answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        return 0
    else
        return 1
    fi
}

# 1. Homebrew Verification
if ! command -v brew &> /dev/null; then
    echo ">>> Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 2. Bundle Installation (Brewfile)
echo ">>> Installing core software via Brewfile..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# 3. Development & Utility Selection

# [1] Editor Suites
if ask_install "Editor Suite (VSCode, Sublime)"; then
    echo ">>> Installing editors..."
    brew install --cask visual-studio-code sublime-text
fi

# [2] API & Database Tools
if ask_install "API & Database Tools (Postman, DBeaver)"; then
    echo ">>> Installing development tools..."
    brew install --cask postman dbeaver-community
fi

# [3] System Utilities
if ask_install "System Utilities (Stats, Keka)"; then
    echo ">>> Installing utilities..."
    brew install --cask stats keka
fi

# [4] Social & Communication
if ask_install "Social Apps (Spotify, Telegram, LINE)"; then
    echo ">>> Installing communication apps..."
    brew install --cask spotify telegram line
fi

# [5] Node & AI CLI
if ask_install "Node.js & Gemini CLI Environment"; then
    echo ">>> Installing Node.js and Gemini CLI..."
    brew install node
    npm install -g @google/generative-ai
fi

# 4. Oh My Zsh Environment
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo ">>> Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 5. Theme & Plugins
echo ">>> Setting up Powerlevel10k and Plugins..."
[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ] && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

# 6. Configuration Deployment (Symlinks)
echo ">>> Deploying dotfiles (.zshrc)..."
[ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# 7. iTerm2 Theme Import
echo ">>> Importing iTerm2 theme (Tomorrow Night Eighties)..."
open "$DOTFILES_DIR/themes/Tomorrow-Night-Eighties.itermcolors"

echo "============================================"
echo "Installation Process Completed"
echo "--------------------------------------------"
echo "Manual Steps Required:"
echo "1. iTerm2 > Settings > Profiles > Text > Font: MesloLGS NF"
echo "2. iTerm2 > Settings > Profiles > Colors > Color Presets: Tomorrow Night Eighties"
echo "3. Shell > Execute 'p10k configure' for prompt customization"
echo "============================================"
