# init-my-workflow

[English](#english) | [中文](#中文)

---

<a name="english"></a>
## English

Automated macOS environment initialization script for rapid development setup.

### 🚀 Features
- **Package Management**: Automated installation via Homebrew (Brewfile).
- **Shell Environment**: Zsh configuration with Oh My Zsh and Powerlevel10k theme.
- **Terminal Customization**: iTerm2 with Tomorrow Night Eighties color scheme and Nerd Fonts.
- **Interactive Installation**: Selective deployment of development, database, and social tools.
- **Symbolic Linking**: Automated synchronization of dotfiles to user home directory.

### 📦 Included Software
- **Core (Default)**: Google Chrome, iTerm2, Rectangle, IINA, AlDente, Obsidian.
- **Optional**: VSCode, Sublime Text, Postman, DBeaver Community, Stats, Keka, Spotify, Telegram, LINE, Gemini CLI.

### 🛠️ Installation
```bash
git clone https://github.com/s813082/init-my-workflow.git ~/Documents/init-my-workflow
cd ~/Documents/init-my-workflow
chmod +x install.sh
./install.sh
```

---

<a name="中文"></a>
## 中文 (Traditional Chinese)

專為 macOS 設計的自動化環境初始化腳本，用於快速建立開發環境。

### 🚀 功能特點
- **套件管理**: 透過 Homebrew (Brewfile) 自動安裝軟體。
- **Shell 環境**: 預設配置 Oh My Zsh 與 Powerlevel10k 主題。
- **終端機美化**: 配置 iTerm2、Tomorrow Night Eighties 配色方案及 Nerd Fonts。
- **互動式安裝**: 可選擇性安裝開發工具、資料庫及社群軟體。
- **設定檔同步**: 自動將設定檔 (dotfiles) 以軟連結方式同步至使用者目錄。

### 📦 包含軟體
- **基礎必備 (預設)**: Google Chrome, iTerm2, Rectangle, IINA, AlDente, Obsidian。
- **選配工具**: VSCode, Sublime Text, Postman, DBeaver Community, Stats, Keka, Spotify, Telegram, LINE, Gemini CLI。

### 🛠️ 安裝方式
```bash
git clone https://github.com/s813082/init-my-workflow.git ~/Documents/init-my-workflow
cd ~/Documents/init-my-workflow
chmod +x install.sh
./install.sh
```

### ⚠️ 後續手動步驟 (Post-Installation)
1. **iTerm2 字體**: 進入 `Settings > Profiles > Text` 並選擇 **MesloLGS NF**。
2. **iTerm2 配色**: 進入 `Settings > Profiles > Colors` 並導入/選擇 **Tomorrow Night Eighties**。
3. **P10K 調整**: 執行 `p10k configure` 即可自定義終端機風格。

## License
MIT
