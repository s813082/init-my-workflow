# .zshrc - Shell Configuration

# 1. Powerlevel10k Instant Prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${user:-$USER}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${user:-$USER}.zsh"
fi

# 2. Oh My Zsh Path
export ZSH="$HOME/.oh-my-zsh"

# 3. Theme Configuration (Powerlevel10k)
ZSH_THEME="powerlevel10k/powerlevel10k"

# 4. Plugin Definitions
# Prerequisites: git, zsh-syntax-highlighting, zsh-autosuggestions
plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
)

# Initialize Oh My Zsh
source $ZSH/oh-my-zsh.sh

# 5. User Defined Aliases
alias cl="clear"
alias ll="ls -lah"
alias g="git"

# 6. P10k Configuration Loading
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
