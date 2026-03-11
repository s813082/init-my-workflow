#!/bin/bash

# 🚀 init-my-workflow | macOS 終極工作流部署腳本
# 準備好迎接全新的開發體驗了嗎？讓我們開始吧！

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
    "Royal TSX|royal-tsx|開發|Royal TSX"
    "Stats|stats|系統|Stats"
    "Keka|keka|系統|Keka"
    "Bitwarden|bitwarden|系統|Bitwarden"
    "Tailscale|tailscale|系統|Tailscale"
    "Spotify|spotify|娛樂|Spotify"
    "Telegram|telegram|社群|Telegram"
    "LINE|line|社群|LINE"
)

# [輔助函式] 更新 Obsidian 配置文件
# (已遷移至 setup-obsidian.sh)

# 檢查 Obsidian 是否已經設定過 Vault
# (已遷移至 setup-obsidian.sh)

# 支援單獨執行 Obsidian 設定
if [[ "$1" == "--obsidian" ]]; then
    bash "$DOTFILES_DIR/setup-obsidian.sh"
    exit 0
fi

# 0. 權限預檢
if [[ "$EUID" -eq 0 ]]; then
    echo "❌ 警告：請勿以 root 權限執行此腳本！"
    exit 1
fi

# 指令檢查函式
is_cmd_installed() { command -v "$1" &> /dev/null; }
is_cask_installed() {
    local cask_id=$1
    local app_file=$2
    [ -d "/Applications/${app_file}.app" ] && return 0
    [ -d "$HOME/Applications/${app_file}.app" ] && return 0
    return 1
}

echo "============================================"
echo "🔍 正在全面偵測系統環境... ✨"
echo "============================================"

# 2. 智慧掃描軟體狀態
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

# 3. 輸出掃描成果摘要
if [ ${#INSTALLED_LIST[@]} -gt 0 ]; then
    echo "✅ 這些夥伴已經就緒了："
    for item in "${INSTALLED_LIST[@]}"; do echo "    - $item"; done
fi

# 4. 批次詢問階段
TO_INSTALL_CASKS=()
WANT_OBSIDIAN=false
INSTALL_NODE_ENV=false
DO_BREW_UPDATE=false

# 處理缺失軟體
if [ ${#MISSING_LIST[@]} -gt 0 ]; then
    echo ""
    echo "--- 🛠️ 裝備選擇時間！ ---"
    for item in "${MISSING_LIST[@]}"; do
        IFS="|" read -r name id category app_file <<< "$item"
        echo -n "想在您的 Mac 上迎接 [$category] $name 嗎？ (y/n) "
        read answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            if [[ "$id" == "obsidian" ]]; then
                WANT_OBSIDIAN=true
            else
                TO_INSTALL_CASKS+=("$id")
            fi
        fi
    done
fi

# 處理 Node.js 需求
if ! is_cmd_installed "node"; then
    echo -n "想喚醒強大的 [開發環境] Node.js 與 AI CLI 嗎？ (y/n) "
    read answer
    [[ "$answer" =~ ^[Yy]$ ]] && INSTALL_NODE_ENV=true
fi

# 🚀 智慧檢查更新邏輯 (針對已安裝的環境)
# 這裡原本有 logic 判斷是否需要更新，但為了確保每次都問，我們稍微調整
if [ ${#TO_INSTALL_CASKS[@]} -eq 0 ] && [ "$INSTALL_NODE_ENV" = false ]; then
    echo ""
    echo "💡 偵測到您目前不需要安裝新軟體。"
    echo ">>> 正在掃描 Homebrew 與已安裝套件是否有新版本... (這可能需要一點時間)"
    brew update &> /dev/null
    OUTDATED=$(brew outdated --cask --quiet)
    if [ -n "$OUTDATED" ]; then
        echo "⚠️ 發現以下套件有新版本："
        echo "$OUTDATED"
        echo -n "👉 想要一次性將所有套件更新至最新版嗎？ (y/n) "
        read update_ans
        [[ "$update_ans" =~ ^[Yy]$ ]] && DO_BREW_UPDATE=true
    else
        echo "🌟 太棒了！您的所有軟體都已經是最新版本！"
    fi
fi

# 5. 批次執行安裝/更新階段
echo ""
echo "============================================"
echo "🔥 衝啊！全速執行中！"
echo "============================================"

# [1] 更新/維護 Homebrew
if [ "$DO_BREW_UPDATE" = true ]; then
    echo ">>> 正在全速更新所有套件..."
    brew upgrade --cask --greedy
fi

# [2] 安裝新軟體
if [ ${#TO_INSTALL_CASKS[@]} -gt 0 ]; then
    for id in "${TO_INSTALL_CASKS[@]}"; do
        if brew list --cask "$id" &> /dev/null; then
            echo ">>> [同步] 偵測到 $id 註冊紀錄殘留，正在為您強制同步環境..."
            brew uninstall --cask --force "$id"
        fi
        echo ">>> 正在全速安裝 $id..."
        brew install --cask "$id"
    done
fi

# [3] 部署開發環境 (Node.js & GitHub CLI)
if [ "$INSTALL_NODE_ENV" = true ]; then
    echo ">>> 正在部署 Node.js, GitHub CLI & AI CLI..."
    brew install node gh
    npm install -g @google/generative-ai @githubnext/github-copilot-cli
fi

# [4] 設定檔同步 (僅在有 iTerm2 的情況下執行)
if [[ " ${INSTALLED_LIST[@]} " =~ "iTerm2" ]] || [[ " ${TO_INSTALL_CASKS[@]} " =~ "iterm2" ]]; then
    echo ">>> 偵測到 iTerm2，正在為您打造最強終端機環境..."
    
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo ">>> 正在部署 Oh My Zsh 框架..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    echo ">>> 正在同步您的設定檔，注入靈魂中..."
    [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ] && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k" &> /dev/null
    [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" &> /dev/null
    [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions" &> /dev/null

    [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
    ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

    # 導入 iTerm2 配色方案
    echo ">>> 導入華麗的 Tomorrow Night Eighties 配色..."
    open "$DOTFILES_DIR/themes/Tomorrow-Night-Eighties.itermcolors"
fi

# Obsidian 軟體安裝與 Vault 智慧連動
# (所有邏輯都封裝在 setup-obsidian.sh 裡面了)
if [ "$WANT_OBSIDIAN" = true ] || [[ " ${INSTALLED_LIST[@]} " =~ "Obsidian" ]]; then
    if bash "$DOTFILES_DIR/setup-obsidian.sh" --check && [ "$WANT_OBSIDIAN" != true ]; then
        echo ">>> 偵測到您已經設定過 Obsidian Vault。"
    else
        bash "$DOTFILES_DIR/setup-obsidian.sh"
    fi
fi

echo "============================================"
echo "🎊 所有的設定都完美達成！"
echo "--------------------------------------------"
echo "🌟 記得完成最後的熱血設定 (手動步驟):"
echo "1. iTerm2 > 設定 > Profiles > Text > Font: 選中 'MesloLGS NF'"
echo "2. iTerm2 > 設定 > Profiles > Colors > Color Presets: 選中 'Tomorrow Night Eighties'"
echo "3. 執行 'p10k configure' 打造您專屬的終端機外型！"
echo "============================================"
