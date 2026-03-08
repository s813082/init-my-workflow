#!/bin/bash

# macOS 環境自動化初始化腳本
# 用法: cd ~/Documents/init-my-workflow && chmod +x install.sh && ./install.sh

DOTFILES_DIR="/Users/lisa20260130/Documents/init-my-workflow"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# 0. 權限與環境預檢
if [[ "$EUID" -eq 0 ]]; then
    echo "錯誤: 請勿以 root/sudo 權限執行此腳本。Homebrew 將無法運作。"
    exit 1
fi

# 檢查目錄權限
CHECK_DIRS=("/usr/local/bin" "/usr/local/share" "/usr/local/share/man/man8")
for dir in "${CHECK_DIRS[@]}"; do
    if [ -d "$dir" ] && [ ! -w "$dir" ]; then
        echo "錯誤: 目錄 $dir 無法寫入。"
        echo "請先執行: sudo chown -R \$(whoami) $dir"
        exit 1
    fi
done

echo "============================================"
echo "macOS 環境初始化啟動"
echo "============================================"

# 輔助函式: 檢查軟體是否已安裝 (Cask)
is_cask_installed() {
    brew list --cask "$1" &> /dev/null
}

# 輔助函式: 檢查指令是否已存在 (Brew/NPM)
is_cmd_installed() {
    command -v "$1" &> /dev/null
}

# 輔助函式: 詢問並安裝
smart_install_cask() {
    local name=$1
    local cask_id=$2
    
    if is_cask_installed "$cask_id"; then
        echo ">>> [跳過] $name 已安裝。"
    else
        echo -n "是否安裝 [$name]? (y/n) "
        read answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            echo ">>> 正在安裝 $name..."
            brew install --cask "$cask_id"
        fi
    fi
}

# 1. Homebrew 檢查
if ! is_cmd_installed "brew"; then
    echo ">>> 正在安裝 Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo ">>> [跳過] Homebrew 已安裝。"
fi

# 2. 執行基礎軟體安裝 (Brewfile)
echo ">>> 正在根據 Brewfile 安裝基礎核心軟體..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# 3. 互動式開發工具安裝

# [1] 編輯器
smart_install_cask "Visual Studio Code" "visual-studio-code"
smart_install_cask "Sublime Text" "sublime-text"

# [2] 開發與資料庫工具
smart_install_cask "Postman" "postman"
smart_install_cask "DBeaver Community" "dbeaver-community"

# [3] 系統增強工具
smart_install_cask "Stats" "stats"
smart_install_cask "Keka" "keka"

# [4] 社交與通訊軟體
smart_install_cask "Spotify" "spotify"
smart_install_cask "Telegram" "telegram"
smart_install_cask "LINE" "line"

# [5] Node & Gemini CLI
if is_cmd_installed "node"; then
    echo ">>> [跳過] Node.js 已安裝。"
else
    echo -n "是否安裝 [Node.js & Gemini CLI]? (y/n) "
    read answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        echo ">>> 正在安裝 Node.js 與 Gemini CLI..."
        brew install node
        npm install -g @google/generative-ai
    fi
fi

# 4. Oh My Zsh 環境
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo ">>> [跳過] Oh My Zsh 已安裝。"
else
    echo ">>> 正在安裝 Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 5. 主題與插件
echo ">>> 正在檢查/安裝 Powerlevel10k 與插件..."
[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ] && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

# 6. 配置同步
echo ">>> 正在建立設定檔連結 (.zshrc)..."
[ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# 7. iTerm2 主題導入
echo ">>> 正在導入 iTerm2 配色方案..."
open "$DOTFILES_DIR/themes/Tomorrow-Night-Eighties.itermcolors"

echo "============================================"
echo "安裝流程完成"
echo "--------------------------------------------"
echo "手動執行清單:"
echo "1. iTerm2 > 設定 > Profiles > Text > Font: 選擇 MesloLGS NF"
echo "2. iTerm2 > 設定 > Profiles > Colors > Color Presets: 選擇 Tomorrow Night Eighties"
echo "3. 執行 'p10k configure' 調整終端機樣式"
echo "============================================"
