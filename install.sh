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
    "Stats|stats|系統|Stats"
    "Keka|keka|系統|Keka"
    "Spotify|spotify|娛樂|Spotify"
    "Telegram|telegram|社群|Telegram"
    "LINE|line|社群|LINE"
)

# 0. 權限預檢 | 安全第一，我們先檢查環境！
if [[ "$EUID" -eq 0 ]]; then
    echo "❌ 警告：請勿以 root 權限執行此腳本，這會讓 Homebrew 很困擾喔！"
    exit 1
fi

# 檢查目錄權限
CHECK_DIRS=("/usr/local/bin" "/usr/local/share" "/usr/local/share/man/man8")
for dir in "${CHECK_DIRS[@]}"; do
    if [ -d "$dir" ] && [ ! -w "$dir" ]; then
        echo "⚠️ 目錄 $dir 正在對我們耍脾氣，目前無法寫入！"
        echo "請先執行這行魔法指令修復它：sudo chown -R \$(whoami) $dir"
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
echo "🔍 正在為您全面偵測系統環境，請給我們幾秒鐘發揮魔力！✨"
echo "============================================"

# 1. 基礎環境檢查
INSTALL_BREW=false
if ! is_cmd_installed "brew"; then
    echo "💡 發現您的 Mac 尚未裝載 Homebrew 核心，等一下會幫您強力部署！"
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
echo "--- 📊 戰前掃描情報摘要 ---"
if [ ${#INSTALLED_LIST[@]} -gt 0 ]; then
    echo "✅ 這些強大夥伴已經就緒了："
    for item in "${INSTALLED_LIST[@]}"; do echo "    - $item"; done
fi

if [ ${#MISSING_LIST[@]} -gt 0 ]; then
    echo "📦 還需要徵召的夥伴清單："
    for item in "${MISSING_LIST[@]}"; do
        IFS="|" read -r name id category app_file <<< "$item"
        echo "    - $name ($category)"
    done
else
    echo "🌟 太完美了！您的系統環境已經是完全體，沒有任何缺失！"
fi
echo "------------------------------"

# 4. 批次詢問階段 | 把您的渴望一次告訴我吧！🚀
TO_INSTALL_CASKS=()
INSTALL_NODE_ENV=false

# 處理 Homebrew 需求
if ! is_cmd_installed "brew"; then
    echo -n "👉 準備好要部署最強套件管理器 Homebrew 了嗎？ (y/n) "
    read ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        INSTALL_BREW=true
    else
        echo "❌ 哎呀！沒有 Homebrew 我們就無法繼續下去了，安裝中止。"
        exit 1
    fi
fi

# 處理缺失軟體需求
if [ ${#MISSING_LIST[@]} -gt 0 ]; then
    echo ""
    echo "--- 🛠️ 裝備選擇時間！請選擇您要徵召的夥伴 ---"
    for item in "${MISSING_LIST[@]}"; do
        IFS="|" read -r name id category app_file <<< "$item"
        echo -n "想在您的 Mac 上迎接 [$category] $name 嗎？ (y/n) "
        read answer
        [[ "$answer" =~ ^[Yy]$ ]] && TO_INSTALL_CASKS+=("$id")
    done
fi

# 處理 Node.js 需求
if ! is_cmd_installed "node"; then
    echo -n "想喚醒強大的 [開發環境] Node.js 與 Gemini CLI 嗎？ (y/n) "
    read answer
    [[ "$answer" =~ ^[Yy]$ ]] && INSTALL_NODE_ENV=true
fi

# 5. 批次執行安裝階段 | 精彩的要來了！🔥
echo ""
echo "============================================"
echo "🔥 衝啊！現在開始全速安裝！您可以先去喝杯咖啡慶祝一下！"
echo "============================================"

# [1] 安裝 Homebrew
if [ "$INSTALL_BREW" = true ]; then
    echo ">>> 正在為您召喚 Homebrew 降臨..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# [2] 檢查基礎 Brewfile
echo ">>> 正在根據 Brewfile 檢查基礎配置庫，確保固若金湯..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# [3] 執行軟體批次安裝 (含智慧同步)
if [ ${#TO_INSTALL_CASKS[@]} -gt 0 ]; then
    for id in "${TO_INSTALL_CASKS[@]}"; do
        # 智慧自癒：清理殘留紀錄
        if brew list --cask "$id" &> /dev/null; then
            echo ">>> [同步] 發現 $id 留下的殘影，正在強制清除並重新召喚..."
            brew uninstall --force "$id"
        fi
        echo ">>> 正在全速安裝 $id..."
        brew install --cask "$id"
    done
fi

# [4] 部署開發環境 (Node.js)
if [ "$INSTALL_NODE_ENV" = true ]; then
    echo ">>> 正在連接 Node.js 能量，並賦予 AI 助手們生命 (Gemini & Copilot)..."
    brew install node
    npm install -g @google/generative-ai @githubnext/github-copilot-cli
fi

# [5] 設定檔同步大工程 (Zsh / P10k)
echo ">>> 正在同步您的設定檔，注入靈魂中..."

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo ">>> 正在部署 Oh My Zsh 框架..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ] && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

# 建立軟連結
[ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# 導入 iTerm2 配色方案
echo ">>> 導入華麗的 Tomorrow Night Eighties 配色..."
open "$DOTFILES_DIR/themes/Tomorrow-Night-Eighties.itermcolors"

echo "============================================"
echo "🎊 萬歲！所有的安裝與設定都完美達成！"
echo "--------------------------------------------"
echo "🌟 記得完成最後的熱血設定 (手動步驟):"
echo "1. iTerm2 > 設定 > Profiles > Text > Font: 選中 'MesloLGS NF'"
echo "2. iTerm2 > 設定 > Profiles > Colors > Color Presets: 選中 'Tomorrow Night Eighties'"
echo "3. 執行 'p10k configure' 打造您專屬的終端機外型！"
echo "============================================"
