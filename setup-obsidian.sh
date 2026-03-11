#!/bin/bash

# 💎 Obsidian 究極自動化部署腳本 (GH 強化版)
# 笨蛋弟弟專用！支援 GitHub CLI (gh) 智慧認證！(＃`Д´)

# [1] 工具函式
is_cmd_installed() { command -v "$1" &> /dev/null; }
is_cask_installed() {
    [ -d "/Applications/Obsidian.app" ] || [ -d "$HOME/Applications/Obsidian.app" ]
}

# [2] 依賴環境檢查 (Git, Homebrew & GitHub CLI)
check_dependencies() {
    echo "🔍 正在檢查環境依賴..."
    if ! is_cmd_installed "brew"; then
        echo "❌ 偵測不到 Homebrew！請先安裝 Homebrew 才能繼續。"
        exit 1
    fi
    
    # 檢查 Git
    if ! is_cmd_installed "git"; then
        echo "⚠️ 偵測不到 Git！筆記同步需要 Git 環境。"
        echo -n "👉 想要現在為您安裝 Git 嗎？ (y/n) "
        read git_ans
        [[ "$git_ans" =~ ^[Yy]$ ]] && brew install git
    else
        echo "✅ Git 已就緒。"
    fi

    # 檢查 GitHub CLI (gh)
    if ! is_cmd_installed "gh"; then
        echo "⚠️ 偵測不到 GitHub CLI (gh)！強烈建議安裝以簡化認證流程。"
        echo -n "👉 想要現在為您安裝 gh 嗎？ (y/n) "
        read gh_ans
        [[ "$gh_ans" =~ ^[Yy]$ ]] && brew install gh
    else
        echo "✅ GitHub CLI 已就緒。"
    fi
}

# [3] Obsidian 軟體安裝
install_obsidian() {
    if is_cask_installed; then
        echo "✅ Obsidian 已經安裝過了。"
    else
        echo "🚀 正在為您安裝 Obsidian..."
        brew install --cask obsidian
    fi
}

# [4] Obsidian 配置文件更新 (支援合併模式)
update_obsidian_config() {
    local v_path="$1"
    local mode="${2:-append}" # mode: overwrite | append
    local config_file="$HOME/Library/Application Support/obsidian/obsidian.json"
    local config_dir=$(dirname "$config_file")

    mkdir -p "$config_dir"

    # 使用 Python 進行結構化 JSON 處理
    python3 -c "
import json, os, time, random, string

config_path = os.path.expanduser('~/Library/Application Support/obsidian/obsidian.json')
v_path = '$v_path'
mode = '$mode'

# 產生新的 Vault 資訊
vid = ''.join(random.choices(string.hexdigits.lower(), k=16))
v_info = {
    'path': v_path,
    'ts': int(time.time() * 1000),
    'open': True
}

data = {'vaults': {}}

if mode == 'append' and os.path.exists(config_path) and os.path.getsize(config_path) > 0:
    try:
        with open(config_path, 'r') as f:
            data = json.load(f)
            if 'vaults' not in data: data['vaults'] = {}
    except:
        pass

if mode == 'overwrite': data['vaults'] = {}
data['vaults'][vid] = v_info

with open(config_path, 'w') as f:
    json.dump(data, f, indent='\t')
"
    echo "✅ 已成功連動 Vault 路徑: $v_path (${mode} 模式)"
}

# 檢查是否有設定過 Vault
is_obsidian_configured() {
    local config_file="$HOME/Library/Application Support/obsidian/obsidian.json"
    if [ ! -f "$config_file" ] || [ ! -s "$config_file" ]; then return 1; fi
    python3 -c "import json, os; f=open(os.path.expanduser('~/Library/Application Support/obsidian/obsidian.json')); d=json.load(f); p=list(d['vaults'].values())[0]['path']; exit(0 if p else 1)" 2>/dev/null
}

# [5] GitHub CLI 認證檢查
check_gh_auth() {
    if is_cmd_installed "gh"; then
        if ! gh auth status &> /dev/null; then
            echo "⚠️ 偵測到您尚未登入 GitHub (gh)。"
            echo -n "👉 想要現在執行 'gh auth login' 進行登入嗎？ (y/n) "
            read login_ans
            if [[ "$login_ans" =~ ^[Yy]$ ]]; then
                gh auth login
            else
                echo "⏩ 已跳過登入。後續可能需要手動輸入帳號密碼。"
            fi
        fi
    fi
}

# [6] Vault 智慧引導設定
setup_obsidian_vault() {
    local mode="append"
    
    echo ""
    echo "============================================"
    echo "💎 Obsidian Vault 智慧引導設定 (GH 強化版)"
    echo "============================================"

    if is_obsidian_configured; then
        echo "🔍 偵測到現有的 Vault 設定："
        python3 -c "import json, os; f=open(os.path.expanduser('~/Library/Application Support/obsidian/obsidian.json')); d=json.load(f); [print(f'   📍 {v[\"path\"]}') for v in d['vaults'].values()]" 2>/dev/null
        echo "--------------------------------------------"
        echo "👉 您想要如何處理新的 Vault？ (1) 追加 (2) 覆蓋 (3) 跳過: "
        read handle_choice
        case $handle_choice in
            1) mode="append" ;;
            2) mode="overwrite" ;;
            *) echo "⏩ 已跳過 Vault 配置。"; return 0 ;;
        esac
    fi

    echo ""
    echo "請選擇您的 Vault 來源："
    echo "1) 我在 GitHub 上有筆記倉庫 (gh repo clone)"
    echo "2) 我要在本地建立全新資料夾 (Create New Local)"
    echo "3) 我已經有本地資料夾了 (Open Existing Folder)"
    echo "4) 暫不設定 (Skip)"
    echo -n "您的選擇是 (1/2/3/4): "
    read vault_choice

    case $vault_choice in
        1)
            check_gh_auth
            echo -n "👉 請輸入 GitHub 倉庫名稱 (例如: s813082/my-vault): "
            read repo_name
            # 如果輸入的是完整 URL，gh 也能處理，但我們預設存在 Documents 下
            vault_path="$HOME/Documents/$(basename "$repo_name")"
            if [ ! -d "$vault_path" ]; then
                echo "🚀 正在透過 gh 智慧同步倉庫..."
                gh repo clone "$repo_name" "$vault_path"
            fi
            [ -d "$vault_path" ] && update_obsidian_config "$vault_path" "$mode"
            ;;
        2)
            default_name="$(whoami)_vault"
            echo -n "👉 資料夾名稱？(預設: $default_name): "
            read vault_name
            vault_name=${vault_name:-$default_name}
            vault_path="$HOME/Documents/$vault_name"
            mkdir -p "$vault_path"
            update_obsidian_config "$vault_path" "$mode"
            ;;
        3)
            echo "👉 請輸入您現有資料夾的絕對路徑: "
            read vault_path
            vault_path=$(echo "$vault_path" | xargs)
            if [ -d "$vault_path" ]; then
                update_obsidian_config "$vault_path" "$mode"
                
                # 額外小驚喜：如果還沒 git 化，問他要不要 gh repo create
                if is_cmd_installed "gh" && [ ! -d "$vault_path/.git" ]; then
                    echo ""
                    echo -n "💡 偵測到此資料夾尚未同步到 GitHub。要幫您建立遠端倉庫嗎？ (y/n) "
                    read backup_ans
                    if [[ "$backup_ans" =~ ^[Yy]$ ]]; then
                        check_gh_auth
                        cd "$vault_path"
                        git init && git add . && git commit -m "initial commit"
                        gh repo create "$(basename "$vault_path")" --private --source=. --push
                    fi
                fi
            else
                echo "❌ 找不到該目錄，請確認路徑是否正確！"
            fi
            ;;
        4)
            echo "⏩ 已跳過自動化 Vault 設定。"
            ;;
        *)
            echo "⏩ 未選擇有效選項，跳過設定。"
            ;;
    esac
}

# --- 執行主流程 ---

if [[ "$1" == "--check" ]]; then
    is_obsidian_configured && exit 0 || exit 1
fi

check_dependencies
install_obsidian
setup_obsidian_vault

echo "============================================"
echo "🎉 Obsidian 筆記環境部署完成！ (GH 智慧連動已啟動)"
echo "============================================"
