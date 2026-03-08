#!/bin/bash

# 🚀 init-my-workflow | macOS 一鍵工作流安裝腳本
# 打造屬於你的完美開發環境！

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

# 0. 環境預檢 | 先檢查一下環境安不安全 (＃`Д´)
if [[ "$EUID" -eq 0 ]]; then
    echo "❌ 警告: 請勿以 root 權限執行此腳本。Homebrew 將無法運作！"
    exit 1
fi

# 檢查目錄權限
CHECK_DIRS=("/usr/local/bin" "/usr/local/share" "/usr/local/share/man/man8")
for dir in "${CHECK_DIRS[@]}"; do
    if [ -d "$dir" ] && [ ! -w "$dir" ]; then
        echo "⚠️ 目錄 $dir 目前無法寫入，這會阻礙 Homebrew 安裝。"
        echo "請先執行: sudo chown -R \$(whoami) $dir"
        exit 1
    fi
done

# 指令檢查函式
is_cmd_installed() { command -v "$1" &> /dev/null; }

# 智慧型 Cask 檢查函式 (結合實體路徑)
is_cask_installed() {
    local cask_id=$1
    local app_file=$2
    [ -d "/Applications/${app_file}.app" ] && return 0
    [ -d "$HOME/Applications/${app_file}.app" ] && return 0
    return 1
}

echo "============================================"
echo "🔍 正在為您掃描系統環境，請稍候..."
echo "============================================"

# 1. 基礎環境檢查
INSTALL_BREW=false
if ! is_cmd_installed "brew"; then
    echo "💡 發現您的系統還沒有 Homebrew，等一下會幫您裝起來！"
fi

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
echo "--- 掃描摘要 (Scan Summary) ---"
if [ ${#INSTALLED_LIST[@]} -gt 0 ]; then
    echo "✅ 已經就緒的項目:"
    for item in "${INSTALLED_LIST[@]}"; do echo "    - $item"; done
fi

if [ ${#MISSING_LIST[@]} -gt 0 ]; then
    echo "📦 還需要補齊的項目:"
    for item in "${MISSING_LIST[@]}"; do
        IFS="|" read -r name id category app_file <<< "$item"
        echo "    - $name ($category)"
    done
else
    echo "🌟 恭喜！系統環境已非常完整，所有軟體都已就緒！"
fi
echo "------------------------------"

# 4. 批次詢問階段 | 把您的選擇一次告訴我吧！(／>///<)／
TO_INSTALL_CASKS=()
INSTALL_NODE_ENV=false

# 處理 Homebrew 需求
if ! is_cmd_installed "brew"; then
    echo -n "👉 是否要安裝 Homebrew? (y/n) "
    read ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        INSTALL_BREW=true
    else
        echo "❌ 由於 Homebrew 是必備組件，安裝將無法繼續。"
        exit 1
    fi
fi

# 處理缺失軟體需求 (批次詢問，效率第一！)
if [ ${#MISSING_LIST[@]} -gt 0 ]; then
    echo ""
    echo "--- 請選擇您想要安裝的軟體 ---"
    for item in "${MISSING_LIST[@]}"; do
        IFS="|" read -r name id category app_file <<< "$item"
        echo -n "需要安裝 [$category] $name 嗎? (y/n) "
        read answer
        [[ "$answer" =~ ^[Yy]$ ]] && TO_INSTALL_CASKS+=("$id")
    done
fi

# 處理 Node.js 需求
if ! is_cmd_installed "node"; then
    echo -n "需要安裝 [開發] Node.js 與 Gemini CLI 嗎? (y/n) "
    read answer
    [[ "$answer" =~ ^[Yy]$ ]] && INSTALL_NODE_ENV=true
fi

# 5. 批次執行安裝階段 | 精彩的要來了！🚀
echo ""
echo "============================================"
echo "🚀 啟動安裝程序！您可以先去喝杯咖啡，交給我吧！"
echo "============================================"

# [1] 安裝 Homebrew
if [ "$INSTALL_BREW" = true ]; then
    echo ">>> 正在為您部署 Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# [2] 檢查基礎 Brewfile
echo ">>> 正在根據 Brewfile 檢查基礎配置..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# [3] 執行軟體批次安裝 (含自癒同步清理)
if [ ${#TO_INSTALL_CASKS[@]} -gt 0 ]; then
    for id in "${TO_INSTALL_CASKS[@]}"; do
        # 智慧自癒：清理殘留紀錄
        if brew list --cask "$id" &> /dev/null; then
            echo ">>> [同步] 偵測到 $id 的舊紀錄，正在幫您執行強制清理..."
            brew uninstall --force "$id"
        fi
        echo ">>> 正在為您安裝 $id..."
        brew install --cask "$id"
    done
fi

# [4] 部署開發環境 (Node.js)
if [ "$INSTALL_NODE_ENV" = true ]; then
    echo ">>> 正在部署 Node.js 與喚醒 Gemini CLI..."
    brew install node
    npm install -g @google/generative-ai
fi

# [5] 配置同步大工程 (Zsh / P10k)
echo ">>> 正在進行最後的設定檔同步..."

# Oh My Zsh 安裝與自定義
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ] && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

# 建立軟連結
[ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# 導入 iTerm2 主題
open "$DOTFILES_DIR/themes/Tomorrow-Night-Eighties.itermcolors"

echo "============================================"
echo "🎉 所有的安裝與設定都完成啦！您太棒了！"
echo "--------------------------------------------"
echo "💡 最後的溫馨小提醒 (手動設定步驟):"
echo "1. iTerm2 > 設定 > Profiles > Text > Font: 選擇 'MesloLGS NF'"
echo "2. iTerm2 > 設定 > Profiles > Colors > Color Presets: 選擇 'Tomorrow Night Eighties'"
echo "3. 執行 'p10k configure' 可以重新調整您的終端機風格喔！"
echo "============================================"
