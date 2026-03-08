# .zshrc - 笨蛋弟弟的終端機大腦 (＃`Д´)

# --- 1. Powerlevel10k 設定 ---
# 為了讓啟動速度變快，預設會載入這個設定
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${user:-$USER}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${user:-$USER}.zsh"
fi

# --- 2. Oh My Zsh 路徑 ---
export ZSH="$HOME/.oh-my-zsh"

# --- 3. 主題設定 (使用 P10K) ---
ZSH_THEME="powerlevel10k/powerlevel10k"

# --- 4. 插件設定 ---
# 記得要在安裝腳本裡幫你把這些 git clone 回來喔！
plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
)

# 載入 Oh My Zsh
source $ZSH/oh-my-zsh.sh

# --- 5. 個人化 Alias (你可以隨便加) ---
alias cl="clear"
alias ll="ls -lah"
alias g="git"

# --- 6. P10K 設定檔載入 ---
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
