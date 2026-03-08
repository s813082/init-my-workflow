# init-my-workflow

macOS 環境自動化初始化腳本，旨在快速部署開發與日常辦公環境。

## 核心功能

- **套件管理**: 整合 Homebrew (Brewfile) 進行軟體自動化部署。
- **Shell 整合**: 預配置 Zsh 環境 (Oh My Zsh) 及 Powerlevel10k 介面。
- **終端機美化**: 配置 iTerm2、Tomorrow Night Eighties 色彩方案及支援 Nerd Fonts 之字體。
- **互動式流程**: 支援選擇性安裝開發工具、資料庫管理軟體及通訊程式。
- **配置同步**: 自動建立設定檔 (dotfiles) 之軟連結至使用者目錄。

## 包含軟體清單

### 核心軟體 (預設安裝)
- **瀏覽器**: Google Chrome
- **終端機**: iTerm2 (搭配 MesloLGS NF 字體)
- **視窗管理**: Rectangle
- **媒體播放**: IINA
- **電池管理**: AlDente
- **知識管理**: Obsidian

### 選配軟體 (互動式選擇)
- **開發編輯**: VSCode, Sublime Text
- **測試與資料庫**: Postman, DBeaver Community
- **系統增強**: Stats, Keka
- **通訊娛樂**: Spotify, Telegram, LINE
- **AI 環境**: Node.js, Gemini CLI

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
