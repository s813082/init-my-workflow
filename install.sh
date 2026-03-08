#!/bin/bash

# macOS 智慧批次安裝腳本 (init-my-workflow)
# 邏輯：掃描 -> 批次詢問 -> 不中斷安裝

DOTFILES_DIR="/Users/lisa20260130/Documents/init-my-workflow"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# 軟體定義清單 (名稱|CaskID|類別|應用程式目錄名稱)
APPS=(
    "Google Chrome|google-chrome|核心|Google Chrome"
    "iTerm2|iterm2|核心|iTerm"
    "Rectangle|rectangle|核心|Rectangle"
    "IINA|iina|核心|IINA"
    "AlDente|aldente|核心|AlDente"
    "Obsidian|obsidian|核心|Obsidian"
    "VSCode|visual-studio-code|開發|Visual Studio Code"
    "Sublime Text|sublime-text|開發|Sublime Text"
    "Postman|postman|開發|Postman"
    "DBeaver|dbeaver-community|開發|DBeaver"
    "Stats|stats|系統|Stats"
    "Keka|keka|系統|Keka"
    "Spotify|spotify|娛樂|Spotify"
    "Telegram|telegram|社群|Telegram"
    "LINE|line|社群|LINE"
)

# 0. 環境預檢
if [[ "$EUID" -eq 0 ]]; then
    echo "錯誤: 禁止以 root 執行。"
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

# 指令檢查函式
is_cmd_installed() { command -v "$1" &> /dev/null; }

# 增強版 Cask 檢查函式 (檢查 brew 紀錄與 /Applications 目錄)
is_cask_installed() {
    local cask_id=$1
    local app_file=$2
    
    # 1. 檢查 Homebrew 紀錄
    brew list --cask "$cask_id" &> /dev/null && return 0
    
    # 2. 檢查 /Applications 及其子目錄
    [ -d "/Applications/${app_file}.app" ] && return 0
    [ -d "$HOME/Applications/${app_file}.app" ] && return 0
    
    return 1
}

echo "============================================"
echo "🔍 系統環境深度掃描中..."
echo "============================================"

# 1. 基礎環境檢查
INSTALL_BREW=false
if ! is_cmd_installed "brew"; then
    echo ">>> Homebrew 缺失，將於後續步驟優先安裝。"
fi

# 2. 彙整軟體狀態
MISSING_LIST=()
INSTALLED_LIST=()

for app in "${APPS[@]}"; do
    IFS="|" read -r name id category app_file <<< "$app"
    if is_cask_installed "$id" "$app_file"; then
        INSTALLED_LIST+=("$name ($category)")
    else
        MISSING_LIST+=("$app")
    fi
done

# 3. 輸出掃描摘要
echo "--- 掃描摘要 ---"
if [ ${#INSTALLED_LIST[@]} -gt 0 ]; then
    echo "[✔] 偵測到已安裝項目:"
    for item in "${INSTALLED_LIST[@]}"; do echo "    - $item"; done
fi

if [ ${#MISSING_LIST[@]} -gt 0 ]; then
    echo "[✘] 偵測到缺失項目:"
    for item in "${MISSING_LIST[@]}"; do
        IFS="|" read -r name id category app_file <<< "$item"
        echo "    - $name ($category)"
    done
else
    echo "[✔] 系統環境已完整安裝所有軟體。"
fi
echo "----------------"

# 4. 批次詢問階段
TO_INSTALL_CASKS=()
INSTALL_NODE_ENV=false

# 處理 Homebrew 需求
if ! is_cmd_installed "brew"; then
    echo -n "是否安裝 Homebrew? (y/n) "
    read ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        INSTALL_BREW=true
    else
        echo "錯誤: Homebrew 為必要組件，終止。"
        exit 1
    fi
fi

# 處理缺失軟體需求
if [ ${#MISSING_LIST[@]} -gt 0 ]; then
    echo ""
    echo "--- 軟體安裝偏好設定 ---"
    for item in "${MISSING_LIST[@]}"; do
        IFS="|" read -r name id category app_file <<< "$item"
        echo -n "安裝 [$category] $name? (y/n) "
        read answer
        [[ "$answer" =~ ^[Yy]$ ]] && TO_INSTALL_CASKS+=("$id")
    done
fi

# 處理 Node.js 需求
if ! is_cmd_installed "node"; then
    echo -n "安裝 [開發] Node.js & Gemini CLI? (y/n) "
    read answer
    [[ "$answer" =~ ^[Yy]$ ]] && INSTALL_NODE_ENV=true
fi

# 5. 批次執行安裝階段
echo ""
echo "============================================"
echo "🚀 開始執行安裝程序 (不中斷模式)"
echo "============================================"

# [步驟 1] 安裝 Homebrew
if [ "$INSTALL_BREW" = true ]; then
    echo ">>> 正在安裝 Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# [步驟 2] 執行基礎 Brewfile
echo ">>> 正在檢查基礎核心套件..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# [步驟 3] 批次安裝已選取軟體
if [ ${#TO_INSTALL_CASKS[@]} -gt 0 ]; then
    for id in "${TO_INSTALL_CASKS[@]}"; do
        echo ">>> 正在安裝 $id..."
        brew install --cask "$id"
    done
fi

# [步驟 4] 安裝 Node.js 環境
if [ "$INSTALL_NODE_ENV" = true ]; then
    echo ">>> 正在安裝 Node.js 與 Gemini CLI..."
    brew install node
    npm install -g @google/generative-ai
fi

# [步驟 5] 設定檔同步
echo ">>> 執行配置同步..."
[ ! -d "$HOME/.oh-my-zsh" ] && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ] && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

# 建立軟連結
echo ">>> 建立設定檔軟連結 (.zshrc)..."
[ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# 導入主題
echo ">>> 導入 iTerm2 配色方案..."
open "$DOTFILES_DIR/themes/Tomorrow-Night-Eighties.itermcolors"

echo "============================================"
echo "🎉 安裝作業完成。"
echo "============================================"
