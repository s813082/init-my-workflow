# init-my-workflow

[English](#english) | [中文](#中文)

---

<a name="english"></a>
## English

Automated macOS environment initialization script designed for rapid and reliable development setup.

### 🚀 Key Features
- **Environment Scanner**: Pre-scans `/Applications` and `Homebrew` registry to detect existing software.
- **Batch Interaction**: Collects all installation preferences upfront to ensure an uninterrupted deployment process.
- **Self-Healing Sync**: Automatically detects and fixes "orphaned" software (files manually deleted but registry remains).
- **Permission Pre-flight**: Validates directory ownership (`/usr/local`) before execution to prevent runtime failures.
- **Idempotent Design**: Safe to run multiple times; skips already configured components.

### 📦 Software Catalog
- **Core**: [Google Chrome](https://www.google.com/chrome/), [iTerm2](https://iterm2.com/), [Rectangle](https://rectangleapp.com/), [IINA](https://iina.io/), [AlDente](https://github.com/davidwernhart/AlDente), [Obsidian](https://obsidian.md/).
- **Development (Optional)**: [VSCode](https://code.visualstudio.com/), [Sublime Text](https://www.sublimetext.com/), [Postman](https://www.postman.com/), [DBeaver](https://dbeaver.io/), [Node.js](https://nodejs.org/), [Gemini CLI](https://www.npmjs.com/package/@google/generative-ai).
- **System & Social (Optional)**: [Stats](https://github.com/exelban/stats), [Keka](https://www.keka.io/), [Spotify](https://www.spotify.com/), [Telegram](https://telegram.org/), [LINE](https://line.me/tw/).

### 🛠️ Installation
```bash
git clone https://github.com/s813082/init-my-workflow.git ~/Documents/init-my-workflow
sudo chown -R $(whoami) /usr/local/share/man/man8 && cd ~/Documents/init-my-workflow && chmod +x install.sh && ./install.sh
```

---

<a name="中文"></a>
## 中文 (Traditional Chinese)

專為 macOS 設計的自動化環境初始化腳本，旨在提供快速、穩定且具備智慧偵測能力的工作流部署。

### 🚀 核心功能
- **環境智慧掃描**: 自動偵測 `/Applications` 目錄與 `Homebrew` 紀錄，精準識別已安裝軟體。
- **批次互動邏輯**: 一次性詢問所有安裝需求，避免漸進式披露導致的等待與低效率。
- **註冊表自動同步**: 偵測「軟體實體已刪除但紀錄殘留」的情況，自動執行強制清理並重新安裝（自癒功能）。
- **權限預檢機制**: 執行前自動檢查 `/usr/local` 相關目錄權限，並提供修復指引。
- **冪等性設計**: 可重複執行而不影響現有配置，僅針對缺失項目進行補全。

### 📦 包含軟體清單
- **基礎核心**: Google Chrome, iTerm2, Rectangle, IINA, AlDente, Obsidian。
- **開發工具 (選配)**: VSCode, Sublime Text, Postman, DBeaver, Node.js, Gemini CLI。
- **系統與社群 (選配)**: Stats, Keka, Spotify, Telegram, LINE。

### 🛠️ 一鍵安裝指令
```bash
git clone https://github.com/s813082/init-my-workflow.git ~/Documents/init-my-workflow
sudo chown -R $(whoami) /usr/local/share/man/man8 && cd ~/Documents/init-my-workflow && chmod +x install.sh && ./install.sh
```

---

## ❓ Q&A / 常見問題

**Q: 為什麼需要執行 `sudo chown`？**
A: Homebrew 需要對 `/usr/local` 具備寫入權限以建立軟連結。macOS 某些系統更新可能會鎖定這些目錄，此指令可確保安裝過程不因權限受阻。

**Q: 腳本會覆蓋我現有的 `.zshrc` 嗎？**
A: 不會。腳本會偵測現有的 `.zshrc` 並將其重新命名為 `.zshrc.bak` 進行備份，隨後建立連結至本倉庫之配置。

**Q: 我手動刪除了軟體，腳本能偵測到嗎？**
A: 可以。腳本以實體路徑為最高判定準則。若軟體被手動移除，腳本會識別為缺失，並在安裝前自動清理 Homebrew 的殘留紀錄。

**Q: 如何更新軟體清單？**
A: 若您手動安裝了新軟體並希望加入此工作流，請執行 `brew bundle dump --force` 更新 `Brewfile`。

## License
MIT
