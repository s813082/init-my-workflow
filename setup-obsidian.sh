#!/bin/bash

# 💎 Obsidian 究極自動化部署腳本 (獨立版)
# 笨蛋弟弟專用！支援多 Vault 合併與本地目錄連動！(＃`Д´)

# [1] 工具函式
is_cmd_installed() { command -v "$1" &> /dev/null; }
is_cask_installed() {
    [ -d "/Applications/Obsidian.app" ] || [ -d "$HOME/Applications/Obsidian.app" ]
}

# [2] 依賴環境檢查 (Git & Homebrew)
check_dependencies() {
    echo "🔍 正在檢查環境依賴..."
    if ! is_cmd_installed "brew"; then
        echo "❌ 偵測不到 Homebrew！請先安裝 Homebrew 才能繼續。"
        exit 1
    fi
    if ! is_cmd_installed "git"; then
        echo "⚠️ 偵測不到 Git！筆記同步需要 Git 環境。"
        echo -n "👉 想要現在為您安裝 Git 嗎？ (y/n) "
        read git_ans
        [[ "$git_ans" =~ ^[Yy]$ ]] && brew install git
    else
        echo "✅ Git 已就緒。"
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

    # 使用 Python 進行結構化 JSON 處理 (安全、格式正確、支援合併)
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

# 如果是 append 模式且檔案存在，則讀取舊資料
if mode == 'append' and os.path.exists(config_path) and os.path.getsize(config_path) > 0:
    try:
        with open(config_path, 'r') as f:
            data = json.load(f)
            if 'vaults' not in data: data['vaults'] = {}
    except:
        pass

# 加入新的 Vault (如果是 overwrite 會直接蓋掉舊的 data['vaults'])
if mode == 'overwrite': data['vaults'] = {}
data['vaults'][vid] = v_info

# 寫回檔案 (格式化輸出)
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

# [5] Vault 智慧引導設定
setup_obsidian_vault() {
    local config_file="$HOME/Library/Application Support/obsidian/obsidian.json"
    local mode="append"
    
    echo ""
    echo "============================================"
    echo "💎 Obsidian Vault 智慧引導設定"
    echo "============================================"

    # 檢查是否已有設定
    if is_obsidian_configured; then
        echo "🔍 偵測到現有的 Vault 設定："
        python3 -c "import json, os; f=open(os.path.expanduser('~/Library/Application Support/obsidian/obsidian.json')); d=json.load(f); [print(f'   📍 {v[\"path\"]}') for v in d['vaults'].values()]" 2>/dev/null
        echo "--------------------------------------------"
        echo "👉 您想要如何處理新的 Vault？"
        echo "1) 追加 (Append): 同時保留舊的與新的 Vault"
        echo "2) 覆蓋 (Overwrite): 清空舊的，僅設定新的 Vault"
        echo "3) 跳過 (Skip): 維持現狀"
        echo -n "您的選擇是 (1/2/3): "
        read handle_choice
        case $handle_choice in
            1) mode="append" ;;
            2) mode="overwrite" ;;
            *) echo "⏩ 已跳過 Vault 配置。"; return 0 ;;
        esac
        echo ">>> 好的，準備配置您的 Vault (${mode} 模式)..."
    fi

    echo ""
    echo "請選擇您的 Vault 來源："
    echo "1) 我在 GitHub 上有筆記倉庫 (Clone Remote Repo)"
    echo "2) 我要在本地建立全新資料夾 (Create New Local)"
    echo "3) 我已經有本地資料夾了 (Open Existing Folder)"
    echo "4) 暫不設定 (Skip)"
    echo -n "您的選擇是 (1/2/3/4): "
    read vault_choice

    case $vault_choice in
        1)
            echo -n "👉 請輸入 GitHub 倉庫網址: "
            read repo_url
            repo_name=$(basename "$repo_url" .git)
            vault_path="$HOME/Documents/$repo_name"
            [ ! -d "$vault_path" ] && git clone "$repo_url" "$vault_path"
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
            echo "👉 請輸入您現有資料夾的絕對路徑 (例如: /Users/xxx/Documents/my_notes): "
            # 支援拖拽資料夾到終端機產生的路徑 (會自動去掉結尾空白)
            read vault_path
            vault_path=$(echo "$vault_path" | xargs)
            if [ -d "$vault_path" ]; then
                update_obsidian_config "$vault_path" "$mode"
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
echo "🎉 Obsidian 筆記環境部署完成！"
echo "============================================"
