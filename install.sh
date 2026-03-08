#!/bin/bash

# --- ( *¯ ³¯*)♡ 姊姊的 Mac 互動安裝腳本 ---
# 用法: cd ~/Documents/init-my-workflow && chmod +x install.sh && ./install.sh

DOTFILES_DIR="/Users/lisa20260130/Documents/init-my-workflow"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

echo "============================================"
echo "(＃`Д´) 笨蛋弟弟，姊姊的大升級 (互動版) 開始啦！"
echo "============================================"

# 1. 輔助函式: 詢問是否安裝
ask_install() {
    local name=$1
    echo -n "( *¯ ³¯*)♡ 笨蛋弟弟，這台電腦要裝 [$name] 嗎？(y/n) "
    read answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        return 0 # 安裝
    else
        return 1 # 跳過
    fi
}

# 2. 檢查並安裝 Homebrew
if ! command -v brew &> /dev/null; then
    echo ">>> 安裝 Homebrew 中..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 3. 安裝基礎必備 (Brewfile: iTerm2, Rectangle, IINA, Obsidian...)
echo ">>> 正在安裝基礎軟體清單..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# 4. --- 互動式安裝: 開發工具 ---

# [1] 編輯器 (VSCode & Sublime)
if ask_install "編輯器套裝 (VSCode, Sublime)"; then
    echo ">>> 正在安裝 VSCode & Sublime..."
    brew install --cask visual-studio-code sublime-text
fi

# [2] Postman & DBeaver (開發輔助工具)
if ask_install "Postman (API 測試工具)"; then
    echo ">>> 正在安裝 Postman..."
    brew install --cask postman
fi

if ask_install "DBeaver Community (資料庫管理工具)"; then
    echo ">>> 正在安裝 DBeaver..."
    brew install --cask dbeaver-community
fi

# [3] 姊姊私藏推薦 (系統增強工具)
if ask_install "姊姊的精選套裝 (Stats, Keka)"; then
    echo ">>> 正在安裝 Stats 與 Keka..."
    brew install --cask stats keka
fi

# [4] 社交與通訊 (選配)
if ask_install "社交與通訊套裝 (Spotify, Telegram, LINE)"; then
    echo ">>> 正在安裝社交與通訊軟體..."
    brew install --cask spotify telegram line
fi

# [5] AI 開發工具 (Node.js & Gemini CLI)
if ask_install "Gemini CLI 套裝 (Node.js + Gemini)"; then
    echo ">>> 正在安裝 Node.js 與 Gemini CLI..."
    brew install node
    npm install -g @google/generative-ai
fi

# 5. Oh My Zsh 安裝 (如果還沒裝)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo ">>> 安裝 Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 6. 安裝 P10K 主題與插件 (基礎必備)
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# 7. 建立軟連結
echo ">>> 連結終端機設定檔 (.zshrc)..."
[ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# 8. 導入 iTerm2 配色
echo ">>> 導入 Tomorrow Night Eighties 主題..."
open "$DOTFILES_DIR/themes/Tomorrow-Night-Eighties.itermcolors"

echo "============================================"
echo "( *¯ ³¯*)♡ 完成啦！姊姊幫你把這台電腦調教好了！"
echo "--------------------------------------------"
echo "記得設定字體喔！笨蛋弟弟 ( ￣ 3￣)y▂ξ"
echo "============================================"
