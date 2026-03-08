# 🚀 init-my-workflow

[English](#english) | [中文](#中文)

---

<a name="english"></a>
## 🌟 English | Ready for Battle!

An automated macOS initialization suite designed to get you up and running in record time. Say goodbye to manual setups! 🚀

### ✨ Key Highlights
- **Smart System Scan**: Instantly identifies what's already installed and what's missing.
- **Efficient Batch Setup**: Choose all your tools at once, then sit back while it handles the rest.
- **Self-Healing Logic**: Automatically cleans up broken Homebrew links before re-installing.
- **Permission Guard**: Validates system directory access before it even starts.
- **Total Peace of Mind**: Zero risk of overwriting your hard work—backups are created automatically.

### 🛠️ The Powerhouse Toolkit
- **Essentials**: [Chrome](https://www.google.com/chrome/), [iTerm2](https://iterm2.com/), [Rectangle](https://rectangleapp.com/), [IINA](https://iina.io/), [AlDente](https://github.com/davidwernhart/AlDente), [Obsidian](https://obsidian.md/).
- **Dev Power**: [VSCode](https://code.visualstudio.com/), [Postman](https://www.postman.com/), [DBeaver](https://dbeaver.io/), [Node.js](https://nodejs.org/).
- **Boosters**: [Stats](https://github.com/exelban/stats), [Keka](https://www.keka.io/), [Spotify](https://www.spotify.com/), [Telegram](https://telegram.org/).

### ⚡ One-Line Magic
```bash
git clone https://github.com/s813082/init-my-workflow.git ~/Documents/init-my-workflow
sudo chown -R $(whoami) /usr/local/share/man/man8 && cd ~/Documents/init-my-workflow && chmod +x install.sh && ./install.sh
```

---

<a name="中文"></a>
## 🌟 中文 | 熱血工作流啟動！

這是一套專為 macOS 設計的自動化初始化工具包，旨在讓您換新機時不再手忙腳亂，一鍵建立最強開發環境！🚀

### ✨ 核心亮點
- **智慧環境偵測**: 自動掃描實體目錄與註冊表，精準識別已安裝軟體。
- **高效批次選擇**: 一次性選好所有軟體，安裝過程不再需要停下來回覆詢問。
- **註冊表自癒同步**: 偵測到「軟體已刪但紀錄殘留」時，會自動清除舊紀錄並重新乾淨安裝。
- **權限自動防禦**: 執行前自動檢查並修復常見的 Homebrew 寫入權限問題。
- **無痛設定遷移**: 自動備份現有的 `.zshrc`，讓您的舊設定永遠有一份保險。

### 📦 包含軟體清單
- **基礎核心**: [Google Chrome](https://www.google.com/chrome/), [iTerm2](https://iterm2.com/), [Rectangle](https://rectangleapp.com/), [IINA](https://iina.io/), [AlDente](https://github.com/davidwernhart/AlDente), [Obsidian](https://obsidian.md/).
- **專業開發**: [VSCode](https://code.visualstudio.com/), [Postman](https://www.postman.com/), [DBeaver](https://dbeaver.io/), [Node.js](https://nodejs.org/).
- **效率與社群**: [Stats](https://github.com/exelban/stats), [Keka](https://www.keka.io/), [Spotify](https://www.spotify.com/), [Telegram](https://telegram.org/).

### 🛠️ 一鍵安裝指令
```bash
git clone https://github.com/s813082/init-my-workflow.git ~/Documents/init-my-workflow
sudo chown -R $(whoami) /usr/local/share/man/man8 && cd ~/Documents/init-my-workflow && chmod +x install.sh && ./install.sh
```

---

## ❓ 您的疑問，我們來解答 (FAQ)

**Q: 執行 `sudo chown` 安全嗎？**
A: 這只是將 `/usr/local` 相關目錄的所有權轉回給您目前的帳號，這是 Homebrew 運作的標準做法，完全不會影響系統核心安全喔！

**Q: 我原本的 Zsh 設定會不見嗎？**
A: 別擔心！腳本會偵測到您的舊 `.zshrc` 並將它重新命名為 `.zshrc.bak`。您的回憶與設定都會被好好保護著！

**Q: 如果安裝失敗了怎麼辦？**
A: 腳本具備冪等性設計，您可以隨時重新執行。只要網路通暢，它會自動從斷掉的地方繼續前進！

## 📄 授權 (License)
MIT
