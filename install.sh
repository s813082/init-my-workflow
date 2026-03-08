#!/bin/bash

# macOS 智慧安裝腳本 (init-my-workflow)
# 特點：全自動掃描、狀態彙整、精準詢問

DOTFILES_DIR="/Users/lisa20260130/Documents/init-my-workflow"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# 軟體定義清單 (名稱|CaskID|類別)
APPS=(
    "Google Chrome|google-chrome|核心"
    "iTerm2|iterm2|核心"
    "Rectangle|rectangle|核心"
    "IINA|iina|核心"
    "AlDente|aldente|核心"
    "Obsidian|obsidian|核心"
    "VSCode|visual-studio-code|開發"
    "Sublime Text|sublime-text|開發"
    "Postman|postman|開發"
    "DBeaver|dbeaver-community|開發"
    "Stats|stats|系統"
    "Keka|keka|系統"
    "Spotify|spotify|娛樂"
    "Telegram|telegram|社群"
    "LINE|line|社群"
)

# 0. 環境預檢
if [[ "$EUID" -eq 0 ]]; then
    echo "錯誤: 請勿以 root 權限執行此腳本。Homebrew 將無法運作。"
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

# 檢查指令是否已安裝
is_cmd_installed() {
    command -v "$1" &> /dev/null
}

# 檢查 Cask 是否已安裝
is_cask_installed() {
    brew list --cask "$1" &> /dev/null
}

echo "============================================"
echo "🔍 正在掃描系統環境，請稍候..."
echo "============================================"

# 1. 執行 Homebrew 檢查 (這是所有動作的前提)
if ! is_cmd_installed "brew"; then
    echo ">>> [缺失] Homebrew 未安裝。這將是第一個安裝項目。"
else
    echo ">>> [偵測] Homebrew 已就緒。"
fi

# 2. 彙整目前軟體狀態
INSTALLED_LIST=()
MISSING_LIST=()

for app in "${APPS[@]}"; do
    IFS="|" read -r name id category <<< "$app"
    if is_cask_installed "$id"; then
        INSTALLED_LIST+=("$name ($category)")
    else
        MISSING_LIST+=("$app")
    fi
done

# 3. 輸出掃描摘要
echo ""
echo "--- 目前系統狀態摘要 ---"
echo "[✔] 已安裝項目:"
if [ ${#INSTALLED_LIST[@]} -eq 0 ]; then
    echo "    (無)"
else
    for item in "${INSTALLED_LIST[@]}"; do
        echo "    - $item"
    done
fi

echo ""
echo "[✘] 尚未安裝項目:"
if [ ${#MISSING_LIST[@]} -eq 0 ]; then
    echo "    (全部已安裝！)"
else
    for item in "${MISSING_LIST[@]}"; do
        IFS="|" read -r name id category <<< "$item"
        echo "    - $name ($category)"
    done
fi
echo "-----------------------"
echo ""

# 4. 開始安裝流程

# 安裝 Homebrew
if ! is_cmd_installed "brew"; then
    echo -n "是否安裝 Homebrew? (y/n) "
    read ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        echo ">>> 正在安裝 Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "錯誤: Homebrew 為必需組件，安裝中止。"
        exit 1
    fi
fi

# 依序詢問缺失項目
for item in "${MISSING_LIST[@]}"; do
    IFS="|" read -r name id category <<< "$item"
    echo -n "是否安裝 [$category] $name? (y/n) "
    read answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        echo ">>> 正在安裝 $name..."
        brew install --cask "$id"
    else
        echo ">>> 已跳過 $name。"
    fi
done

# 5. 特別處理: Node & Gemini CLI (非 Cask)
if ! is_cmd_installed "node"; then
    echo -n "是否安裝 [開發] Node.js & Gemini CLI? (y/n) "
    read ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        echo ">>> 正在安裝 Node.js 與 Gemini CLI..."
        brew install node
        npm install -g @google/generative-ai
    else
        echo ">>> 已跳過 Node.js 與 Gemini CLI。"
    fi
else
    echo ">>> [偵測] Node.js 已安裝。"
fi

# 6. 配置同步 (Zsh / P10k)
echo ""
echo ">>> 正在檢查/同步 Zsh 配置..."

# Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo ">>> 正在安裝 Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo ">>> [偵測] Oh My Zsh 已安裝。"
fi

# P10k 與插件
[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ] && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

# 建立軟連結
echo ">>> 正在連結設定檔 (.zshrc)..."
[ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# 導入 iTerm2 配色
echo ">>> 正在導入 iTerm2 配色方案..."
open "$DOTFILES_DIR/themes/Tomorrow-Night-Eighties.itermcolors"

echo "============================================"
echo "🎉 安裝流程完成"
echo "--------------------------------------------"
echo "手動執行清單:"
echo "1. iTerm2 > 設定 > Profiles > Text > Font: 選擇 MesloLGS NF"
echo "2. iTerm2 > 設定 > Profiles > Colors > Color Presets: 選擇 Tomorrow Night Eighties"
echo "3. 執行 'p10k configure' 調整終端機樣式"
echo "============================================"
