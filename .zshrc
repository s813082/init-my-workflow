# 🚀 init-my-workflow | 你的終極開發大腦！

# --- ⚡️ 1. Powerlevel10k 瞬發模式 (啟動速度 Max!) ---
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${user:-$USER}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${user:-$USER}.zsh"
fi

# --- 📦 2. Oh My Zsh 核心配置 ---
export ZSH="$HOME/.oh-my-zsh"

# --- 🎨 3. 主題設定 (選用頂級的 P10K) ---
ZSH_THEME="powerlevel10k/powerlevel10k"

# --- 🔌 4. 強力插件清單 (效率加倍的秘密) ---
# 包含：Git 狀態、語法高亮、智慧自動補全
plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
)

# 啟動 Oh My Zsh！
source $ZSH/oh-my-zsh.sh

# --- 🛠️ 5. 常用縮寫 (Alias) | 讓你的手指休息一下 ---
alias cl="clear"
alias ll="ls -lah"
alias g="git"

# --- ✨ 6. 載入自定義外觀配置 ---
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
