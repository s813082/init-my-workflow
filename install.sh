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

# [6] Obsidian Vault 智慧引導 (新功能！💎)
setup_obsidian_vault() {
    echo ""
    echo "============================================"
    echo "💎 Obsidian Vault 智慧設定引導"
    echo "============================================"
    echo "讓我們幫您把筆記本 (Vault) 設定好吧！"
    echo "請選擇您的 Vault 狀態："
    echo "1) 已經存在本機 (Local)"
    echo "2) 存在 GitHub 遠端倉庫 (Remote Repo)"
    echo "3) 還沒有 Vault，我想新創一個 (New)"
    echo -n "您的選擇是 (1/2/3): "
    read vault_choice

    case $vault_choice in
        1)
            echo -n "👉 請輸入您本機 Vault 的完整路徑: "
            read vault_path
            eval vault_path=$vault_path 
            if [ -d "$vault_path" ]; then
                echo "✅ 已確認路徑：$vault_path"
            else
                echo "⚠️ 找不到該目錄，請待會手動在 Obsidian 中開啟它唷！"
            fi
            ;;
        2)
            echo -n "👉 請輸入 GitHub 倉庫網址 (HTTPS/SSH): "
            read repo_url
            # 姊姊幫你鎖定路徑在 Documents 裡了，笨蛋弟弟不用動腦！
            repo_name=$(basename "$repo_url" .git)
            vault_path="$HOME/Documents/$repo_name"

            if [ -d "$vault_path" ]; then
                echo "⚠️ 目錄 $vault_path 已存在，跳過 Clone 步驟。"
            else
                echo ">>> 正在從遠端召喚您的筆記到 $vault_path..."
                git clone "$repo_url" "$vault_path"
            fi

            cd "$vault_path" || return
            
            # Git 個人資訊預檢
            [ -z "$(git config user.name)" ] && { echo -n "👉 請輸入 Git 姓名: "; read git_name; git config user.name "$git_name"; }
            [ -z "$(git config user.email)" ] && { echo -n "👉 請輸入 Git Email: "; read git_email; git config user.email "$git_email"; }

            echo "🧪 正在進行連線測試 (Test Push)..."
            date > .connection_test
            git add .connection_test
            git commit -m "chore: 🚀 initial connection test from init-my-workflow"
            git push origin $(git branch --show-current) && echo "✅ 遠端連線測試成功！" || echo "❌ 連線失敗，請檢查權限。"
            cd - > /dev/null
            ;;
        3)
            default_name="$(whoami)_vault"
            echo -n "👉 想要幫您的 Vault 取什麼名字？(預設: $default_name): "
            read vault_name
            vault_name=${vault_name:-$default_name}
            vault_path="$HOME/Documents/$vault_name"

            mkdir -p "$vault_path"
            cd "$vault_path" || return
            [ ! -d ".git" ] && { git init; echo "# 📓 $vault_name" > README.md; }
            
            echo -n "👉 想要連結到哪個 GitHub 遠端倉庫網址？(若暫不連結請留空): "
            read repo_url
            if [ -n "$repo_url" ]; then
                ! git remote | grep -q "origin" && git remote add origin "$repo_url"
                git add .
                git commit -m "feat: 🚀 initial vault setup from init-my-workflow"
                echo "🧪 正在嘗試第一次推送..."
                git push -u origin $(git branch --show-current) && echo "✅ 遠端同步設定完成！" || echo "⚠️ 推送失敗。"
            fi
            cd - > /dev/null
            ;;
        *) echo "⏩ 跳過 Vault 設定。" ;;
    esac
}

# 支援單獨執行 Obsidian 設定
if [[ "$1" == "--obsidian" ]]; then
    setup_obsidian_vault
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
        [[ "$answer" =~ ^[Yy]$ ]] && TO_INSTALL_CASKS+=("$id")
    done
fi

# 處理 Node.js 需求
if ! is_cmd_installed "node"; then
    echo -n "想喚醒強大的 [開發環境] Node.js 與 AI CLI 嗎？ (y/n) "
    read answer
    [[ "$answer" =~ ^[Yy]$ ]] && INSTALL_NODE_ENV=true
fi

# 🚀 智慧檢查更新邏輯 (針對已安裝的環境)
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
        echo ">>> 正在安裝 $id..."
        brew install --cask "$id"
    done
fi

# [3] 部署開發環境 (Node.js)
if [ "$INSTALL_NODE_ENV" = true ]; then
    echo ">>> 正在部署 Node.js & AI CLI..."
    brew install node
    npm install -g @google/generative-ai @githubnext/github-copilot-cli
fi

# [4] 設定檔同步
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
# (同步邏輯同前，略過中間重複的 git clone ...)
[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ] && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k" &> /dev/null
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" &> /dev/null
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions" &> /dev/null

[ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# Obsidian Vault 觸發
if [[ " ${INSTALLED_LIST[@]} " =~ "Obsidian" ]] || [[ " ${TO_INSTALL_CASKS[@]} " =~ "obsidian" ]]; then
    setup_obsidian_vault
fi

echo "============================================"
echo "🎊 所有的設定都完美達成！"
echo "============================================"
