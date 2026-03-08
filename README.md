# init-my-workflow

macOS 環境自動化初始化腳本，旨在快速部署開發與日常辦公環境。

## 核心功能

- **套件管理**: 整合 Homebrew (Brewfile) 進行軟體自動化部署。
- **Shell 整合**: 預配置 Zsh 環境 (Oh My Zsh) 及 Powerlevel10k 介面。
- **終端機美化**: 配置 iTerm2、Tomorrow Night Eighties 色彩方案及支援 Nerd Fonts 之字體。
- **互動式流程**: 支援選擇性安裝開發工具、資料庫管理軟體及通訊程式。
- **配置同步**: 自動建立設定檔 (dotfiles) 之軟連結至使用者目錄。

## 包含軟體清單 (Software Catalog)

### 核心基礎 (Core Infrastructure)
- **瀏覽器**: [Google Chrome](https://www.google.com/chrome/)
- **終端機**: [iTerm2](https://iterm2.com/) (搭配 [MesloLGS NF](https://github.com/romkatv/dotfiles-public/blob/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Regular.ttf) 字體)

### 效率與系統管理 (Productivity & System)
- **視窗管理**: [Rectangle](https://rectangleapp.com/) - 視窗快捷分割工具。
- **電池維護**: [AlDente](https://github.com/davidwernhart/AlDente) - 限制充電上限以保護電池。
- **系統監控**: [Stats](https://github.com/exelban/stats) - 選單列系統狀態顯示。
- **解壓縮**: [Keka](https://www.keka.io/) - 萬能壓縮與解壓縮軟體。

### 開發工具 (Development Tools) - *互動式選擇安裝*
- **程式編輯器**: [Visual Studio Code](https://code.visualstudio.com/), [Sublime Text](https://www.sublimetext.com/)
- **API 測試**: [Postman](https://www.postman.com/)
- **資料庫管理**: [DBeaver Community](https://dbeaver.io/)
- **AI 助手**: [Gemini CLI (@google/generative-ai)](https://www.npmjs.com/package/@google/generative-ai)

### 知識與影音娛樂 (Media & Knowledge)
- **知識管理**: [Obsidian](https://obsidian.md/) - 第二大腦筆記工具。
- **影音播放**: [IINA](https://iina.io/) - 現代化影片播放器。
- **音樂串流**: [Spotify](https://www.spotify.com/)

### 社群通訊 (Communication) - *互動式選擇安裝*
- **通訊軟體**: [Telegram](https://telegram.org/), [LINE](https://line.me/tw/)

## 安裝步驟

```bash
git clone https://github.com/s813082/init-my-workflow.git ~/Documents/init-my-workflow
cd ~/Documents/init-my-workflow
chmod +x install.sh
./install.sh
```

## 安裝後手動設定

1. **iTerm2 字體**: 於 `Settings > Profiles > Text` 選擇 **MesloLGS NF**。
2. **iTerm2 配色**: 於 `Settings > Profiles > Colors` 導入並選擇 **Tomorrow Night Eighties**。
3. **P10K 配置**: 執行 `p10k configure` 進行個人化介面調整。

## 維護指南

更新軟體清單：
```bash
brew bundle dump --force
```

## 授權
MIT
