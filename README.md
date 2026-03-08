# init-my-workflow

Automated macOS environment initialization script for rapid development setup.

## Features

- **Package Management**: Automated installation via Homebrew (Brewfile).
- **Shell Environment**: Zsh configuration with Oh My Zsh and Powerlevel10k theme.
- **Terminal Customization**: iTerm2 with Tomorrow Night Eighties color scheme and Nerd Fonts.
- **Interactive Installation**: Selective deployment of development, database, and social tools.
- **Symbolic Linking**: Automated synchronization of dotfiles to user home directory.

## Included Software

### Core (Default)
- **Browsers**: Google Chrome
- **Terminal**: iTerm2 (with MesloLGS NF)
- **Utilities**: Rectangle (Window Management), IINA (Media Player), AlDente (Battery Management), Obsidian (Knowledge Base)

### Optional (Interactive Selection)
- **Development**: VSCode, Sublime Text, Postman, DBeaver Community
- **AI Tools**: Node.js, Gemini CLI
- **System Enhancement**: Stats (System Monitor), Keka (Archiver)
- **Communication**: Spotify, Telegram, LINE

## Installation

```bash
git clone https://github.com/s813082/init-my-workflow.git ~/Documents/init-my-workflow
cd ~/Documents/init-my-workflow
chmod +x install.sh
./install.sh
```

## Post-Installation Requirements

1. **iTerm2 Font**: Navigate to `Settings > Profiles > Text` and select **MesloLGS NF**.
2. **iTerm2 Color**: Navigate to `Settings > Profiles > Colors` and import/select **Tomorrow Night Eighties**.
3. **P10K Configuration**: Execute `p10k configure` to customize the prompt style.

## Maintenance

Update software list via:
```bash
brew bundle dump --force
```

## License
MIT
