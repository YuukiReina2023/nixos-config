<div align="center">

# ❄ nixos-config

**宣告式 NixOS 配置 — Niri 合成器 + Noctalia 桌面外殼，完全可重現。**

[![NixOS](https://img.shields.io/badge/NixOS-unstable-5277C3?style=flat-square&logo=nixos&logoColor=white)](https://nixos.org)
[![Niri](https://img.shields.io/badge/WM-niri-8AADF4?style=flat-square)](https://github.com/YaLTeR/niri)
[![Noctalia](https://img.shields.io/badge/Shell-noctalia-C3E88D?style=flat-square)](https://github.com/noctalia-dev/noctalia)
[![Home Manager](https://img.shields.io/badge/Home_Manager-enabled-CBA6F7?style=flat-square)](https://github.com/nix-community/home-manager)

</div>

---

<div align="center">

| | |
|:---:|:---:|
| ![preview-1](previews/preview-1.png) | ![preview-2](previews/preview-2.png) |
| ![preview-3](previews/preview-3.png) | ![preview-4](previews/preview-4.png) |

</div>

---

## 總覽

一套乾淨、可重現的 NixOS 配置，以 **[niri](https://github.com/YaLTeR/niri)**（可橫向捲動的平鋪式 Wayland 合成器）為核心，搭配 **[noctalia-shell](https://github.com/noctalia-dev/noctalia)**（現代 GTK4 桌面外殼），提供完整的工具列、啟動器、鎖定畫面、桌布挑選器、控制中心與通知系統，全部由桌布動態擷取的色彩方案驅動。

所有內容皆透過 Nix flakes 與 Home Manager 宣告式管理。在任何相容機器上重建，皆可產生完全相同的環境。

---

## 技術棧

| 層級 | 工具 |
|---|---|
| 作業系統 | NixOS (unstable) |
| 合成器 | [niri](https://github.com/YaLTeR/niri) |
| 桌面外殼 | [noctalia-shell](https://github.com/noctalia-dev/noctalia) (zh-CN) |
| 編輯器 | [nixvim](https://github.com/nix-community/nixvim) (Neovim — Tokyo Night Moon) |
| 終端機 | [foot](https://codeberg.org/dnkl/foot) / kitty |
| Shell | bash + [fish](https://fishshell.com) |
| 提示字元 | [Starship](https://starship.rs) (Tokyo Night Moon 色盤) |
| GTK 主題 | Colloid-Dark |
| 圖示 | Papirus-Dark |
| 游標 | volantes\_cursors |
| 字型 | JetBrainsMono Nerd Font、Fira Code Nerd Font、Hack Nerd Font、Noto Sans CJK（預設中文字型）、LXGW WenKai、AR PL UKai、WenQuanYi Micro Hei |
| 音訊 | PipeWire + WirePlumber |
| GPU | AMD Radeon PRO W6800 (RDNA2, amdgpu) |
| 輸入法 | fcitx5 (拼音, Shift_L 切換, Wayland text-input-v3) |
| 遊戲 | Steam + Proton、HMCL (Minecraft 啟動器)、Bottles、gamescope、gamemode |
| 虛擬化 | Docker、virt-manager/QEMU/KVM |
| 資料庫 | PostgreSQL 17 |
| AI | Ollama (ROCm, llama3.1:8b) |
| 安全工具 | Burp Suite Professional |
| 音樂 | 網易雲音樂 (netease-cloud-music-gtk) |
| 媒體 | MPV、OBS Studio |
| 3D 建模 | Blender (AMD HIP/ROCm GPU 加速) |
| 筆記 | Obsidian |
| 通訊 | Discord (Vencord)、Telegram Desktop |
| 瀏覽器 | Google Chrome |
| 檔案管理 | Yazi、file-roller |

---

## 功能特色

### Niri — 可捲動平鋪合成器

- **無限橫向捲動** — 工作區向左右延伸，視窗在欄位內垂直堆疊
- 彈簧式視窗開啟/移動動畫、expo 曲線工作區切換
- 所有視窗圓角（10–12 px）與陰影
- 各應用透明度規則 — 終端機 92%、VS Code 94%、Obsidian 93%
- 透明版面背景，聚焦環漸層（藍 → 深藍，210°）
- 自然觸控板手勢、focus-follows-mouse、自適應加速
- 透過 `xwayland-satellite` 提供 XWayland 相容舊版應用程式

### Noctalia 桌面外殼

- **浮動工具列** — 透明背景、外框圓角、中央工作區藥丸指示器
- **左側小工具**：發行版標誌 → 控制中心、時鐘（含秒）、網路、藍牙、媒體迷你播放器（含波形視覺化）
- **右側小工具**：系統托盤、CPU/RAM/網路監控、音量、麥克風、夜燈、亮度、電池、通知鈴、工作階段選單
- **啟動器** — 應用程式搜尋 + 剪貼簿歷史 + 視窗切換器 + 設定搜尋
- **控制中心** — 個人資料卡、快速開關（Wi-Fi、藍牙、保持喚醒、電源模式、通知、夜燈、桌布）、音訊卡、亮度、天氣、媒體 + 系統監控
- **桌布挑選器** — 隨機輪播、多種動畫轉場（fade、disc、stripes、wipe、zoom、honeycomb）、Wallhaven 整合
- **鎖定畫面** — 模糊 + 色調、倒數計時、可選媒體控制、閒置 5 分鐘調暗、16 分鐘自動鎖定
- **動態色彩方案** — 桌布產生的 Material You 色彩，同步至 GTK、niri 聚焦環與終端機（透過範本）
- **夜燈** — 手動或自動排程色溫（夜間 4300 K / 日間 3800 K）
- **OSD** — 音量、亮度、麥克風覆蓋層顯示於右上角

### 編輯器 — Nixvim

以 Nix 管理的完整 Neovim 配置：

- **色彩主題**：Tokyo Night Moon（支援透明）
- **LSP**、補全、Treesitter、Telescope、Git 整合（gitsigns）
- vim-tmux-navigator 無縫窗格導覽
- 前導鍵：`<Space>`

### CLI 環境

| 工具 | 用途 |
|---|---|
| [yazi](https://github.com/sxyazi/yazi) / lf | 終端機檔案管理員 |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | 智慧目錄跳轉 |
| [atuin](https://github.com/atuinsh/atuin) | Shell 歷史同步 |
| [eza](https://github.com/eza-community/eza) | 現代 `ls` 替代品 |
| [fastfetch](https://github.com/fastfetch-cli/fastfetch) | 系統資訊 |
| [btop](https://github.com/aristocratos/btop) / htop | 資源監控 |
| [tmux](https://github.com/tmux/tmux) | 終端機多工器 |
| [starship](https://starship.rs) | 跨 Shell 提示字元 |
| [wireshark](https://www.wireshark.org) | 網路分析 |
| bat | 語法高亮的 cat 替代品 |
| cava | 音訊視覺化 |

### 遊戲與轉譯層

- **Steam** — 完整遊戲平台（使用者套件，自動處理 32 位元支援），可透過 `xwayland-satellite` 在 niri 下執行
- **Proton** — Steam 內建 Windows 遊戲相容層；`protonup-qt` 可管理 GE-Proton 等社群版本
- **Bottles** — 基於 Wine 的 Windows 應用程式管理工具，提供圖形化介面建立與管理相容層
- **gamescope** — Wayland 遊戲合成器，Steam 遊戲可全螢幕執行（啟動選項：`gamescope -e -- %command%`）
- **gamemode** — CPU/GPU 自動調頻，提升遊戲效能

---

## 快捷鍵

> `Mod` = Super

### 應用程式

| 快捷鍵 | 動作 |
|---|---|
| `Mod + Return` / `Mod + E` | 開啟終端機 (foot) |
| `Mod + B` | Chrome 瀏覽器（Wayland 模式 + IME） |
| `Mod + Q` | 檔案管理員 (Thunar) |
| `Mod + Space` | 應用程式啟動器 (noctalia) |
| `Mod + Shift + Space` | 控制中心 |
| `Mod + W` | 桌布挑選器 |
| `Mod + V` | 剪貼簿歷史 (rofi) |
| `Mod + S` | 區域截圖 |
| `Mod + Shift + S` | 全螢幕截圖 |
| `Mod + Escape` | 工作階段選單 |

### 視窗管理

| 快捷鍵 | 動作 |
|---|---|
| `Mod + C` | 關閉視窗 |
| `Mod + F` | 最大化欄位 |
| `Mod + Shift + F` | 全螢幕 |
| `Mod + T` | 切換浮動 |
| `Mod + O` | 切換總覽 |
| `Mod + R` | 循環欄位寬度 (50 / 75 / 100 %) |
| `Mod + H/L` | 聚焦左/右欄位 |
| `Mod + J/K` | 聚焦上/下視窗 |
| `Mod + Ctrl + H/L/J/K` | 移動欄位/視窗 |
| `Mod + Shift + ←/→` | 調整欄位寬度 |
| `Mod + Shift + ↑/↓` | 調整視窗高度 |
| `Mod + 1–9` | 切換工作區 |
| `Mod + Shift + 1–9` | 移動視窗至工作區 |

### 系統

| 快捷鍵 | 動作 |
|---|---|
| `Mod + Alt + L` / `Mod + Shift + L` | 鎖定畫面 |
| `Mod + Shift + M` | 結束 niri |
| `Mod + Shift + B` | 切換工具列 |
| `Mod + Shift + N` | 切換夜燈 |
| `Mod + P` | 播放/暫停媒體 |
| `Mod + ,` / `Mod + .` | 上一首 / 下一首 |
| `XF86Audio*` | 音量控制（鎖定畫面亦可用） |
| `XF86Brightness*` | 亮度（鎖定畫面亦可用） |
| `Shift_L` | 切換輸入法 (fcitx5 拼音) |

---

## 目錄結構

```
nixos-config/
├── flake.nix                     # Flake 輸入與系統定義
├── hardware-configuration.nix    # 硬體掃描輸出
└── modules/
    ├── home/                     # Home Manager 模組
    │   ├── default.nix           # 模組匯入彙整
    │   ├── window-managers/
    │   │   ├── niri/             # Niri 配置、快捷鍵、視窗規則
    │   │   └── hyprland/         # Hyprland（已停用，保留 hypridle/hyprlock 供 niri 使用）
    │   ├── noctalia/             # Noctalia 桌面外殼設定
    │   ├── nixvim/               # Neovim (LSP、外掛、色彩主題)
    │   │   └── plugins/          # nixvim 外掛配置
    │   ├── waybar/               # Waybar（已配置，noctalia 為主要外殼）
    │   │   └── scripts/          # Waybar 輔助腳本
    │   ├── rofi/                 # Rofi 啟動器
    │   ├── foot/                 # 終端機模擬器
    │   ├── fish/                 # Fish shell 配置
    │   ├── bash/                 # Bash 配置
    │   ├── starship/             # 提示字元主題
    │   ├── tmux/                 # Tmux 配置
    │   ├── yazi/                 # 檔案管理員
    │   ├── gtk/                  # GTK 主題、圖示、游標
    │   ├── fcitx5/               # 輸入法框架 (拼音)
    │   ├── fastfetch/            # Fetch 配置
    │   ├── mpv/                  # MPV 媒體播放器
    │   ├── obsidian/             # Obsidian 筆記
    │   ├── qq/                   # SB QQ
    │   ├── discord/              # Discord (Vencord)
    │   ├── chrome/               # 瀏覽器配置
    │   ├── telegram/             # Telegram Desktop
    │   ├── netease-cloud-music/  # 網易雲音樂
    │   ├── hmcl/                 # HMCL Minecraft 啟動器
    │   ├── bottles/              # Bottles (Windows 應用程式管理)
    │   ├── steam/                # Steam 遊戲平台
    │   ├── gamescope/            # Wayland 遊戲合成器
    │   ├── gamemode/             # 遊戲模式最佳化
    │   ├── obs-studio/           # OBS Studio
    │   ├── blender/              # Blender (AMD HIP/ROCm GPU 加速)
    │   ├── swappy/               # 截圖註解
    │   ├── virt-manager/         # virt-manager dconf
    │   ├── file-roller/          # 檔案壓縮管理員
    │   ├── wallpapers/           # 桌布收藏
    │   ├── cli/                  # CLI 工具配置 (bat, btop, cava, htop)
    │   ├── devshell/             # 開發環境 (base, Go, Node, Python)
    │   │   └── shells/           # 開發環境定義
    │   ├── packages.nix          # 使用者套件
    │   ├── tools.nix             # 工具 (zoxide, atuin, eza, wireshark)
    │   ├── cc/                   # Claude Code 配置
    │   ├── flake-pkgs.nix        # Flake 衍生套件 (Burp Suite Pro)
    │   ├── deploy-files.nix      # 部署檔案
    │   ├── xdg-portal.nix        # XDG Portal 設定
    │   └── features/             # 功能模組 (截圖)
    ├── system/                   # NixOS 系統模組
    │   ├── default.nix           # 模組匯入彙整
    │   ├── amdgpu.nix            # AMD Radeon PRO W6800 (amdgpu)
    │   ├── nvidia.nix            # NVIDIA（已棄用，未匯入）
    │   ├── audio.nix             # PipeWire + WirePlumber
    │   ├── boot.nix              # systemd-boot、核心參數、BBR
    │   ├── fonts.nix             # 系統字型 (CJK 含 Noto Sans CJK、LXGW WenKai、Nerd Fonts)
    │   ├── network.nix           # NetworkManager
    │   ├── nix.nix               # Nix 設定 (Tsinghua 鏡像、GC、效能調校)
    │   ├── virtualisation.nix    # Docker + virt-manager / KVM
    │   ├── ai.nix                # Ollama (ROCm, 已啟用)
    │   ├── services.nix          # 服務 (PostgreSQL、藍牙、niri)
    │   ├── systemd.nix           # Systemd 設定（未匯入）
    │   ├── filesystems.nix       # 檔案系統配置
    │   ├── locale.nix            # 語言環境與時區
    │   ├── users.nix             # 使用者帳號
    │   └── packages.nix          # 系統套件 (protonup-qt 等)
    └── scripts/                  # 截圖輔助腳本
```

---

## 安裝與復原

<details>
<summary><b>🖥️ 圖形化安裝指導（點擊展開）</b></summary>

> 以下為使用 NixOS 官方圖形化安裝程式（Calamares）從零安裝的完整流程。

### 步驟 1：下載 ISO 映像檔

前往 [NixOS 官方下載頁面](https://nixos.org/download/)，下載 **GNOME** 或 **KDE** 圖形化 ISO（例如 `nixos-gnome-25.05.xxxx.x86_64-linux.iso`，或最新穩定版）。

### 步驟 2：製作開機隨身碟

使用 [Rufus](https://rufus.ie/)（Windows）、`dd`（Linux/macOS）或 [balenaEtcher](https://etcher.balena.io/) 將 ISO 寫入 USB 隨身碟：

```bash
# Linux/macOS 範例（請確認裝置名稱，勿覆蓋錯誤磁碟！）
sudo dd if=nixos-gnome-25.05.iso of=/dev/sdX bs=4M status=progress
```

### 步驟 3：從 USB 開機

1. 重新啟動電腦，進入 BIOS/UEFI 開機選單（通常按 `F12` / `F2` / `Del`）
2. 選擇 USB 隨身碟開機
3. 在開機選單選擇 **NixOS 圖形化安裝**（Graphical installer）

### 步驟 4：使用圖形化安裝程式

1. 開機後會進入 GNOME/KDE 桌面，點選 **「Install NixOS」** 圖示啟動 Calamares
2. **語言**：選擇繁體中文或 English
3. **安裝類型**：選擇 **「Minimal」**（無桌面最小化安裝）。本配置自帶 niri 合成器與 Noctalia 桌面外殼，不需要額外的桌面環境，最小化安裝可避免套件衝突並加快建構
4. **分割區**（建議手動分割，使用 **btrfs** 格式以支援快照與休眠）：
   - `/boot`：EFI 分割區，512MB–1GB，**FAT32**，掛載點 `/boot`
   - `/`：**btrfs**，使用剩餘空間，掛載點 `/`
   - `swap`：**建議與 RAM 相同大小或更大**（本機 32GB RAM → 建議 32–64GB），用於**休眠**（suspend-to-disk）。安裝後需記錄 swap 的 UUID，並在 `modules/system/boot.nix` 的 `boot.kernelParams` 加入 `resume=UUID=<swap 的 UUID>` 才能正常休眠
5. **使用者**：建立使用者帳號（此配置的使用者名稱為 `yuukireina2023`，可於安裝後修改配置）
6. **安裝**：點選安裝並等待完成
7. 安裝完成後重新啟動，移除 USB

### 步驟 5：連線網路並檢查（復原前必做）

最小化安裝沒有桌面環境，需用命令列連線 WiFi。**復原配置前必須先連上網路**，否則無法 clone 與建構：

```bash
# 使用 NetworkManager CLI 連線 WiFi
nmcli device wifi list                          # 列出可用 WiFi
nmcli device wifi connect <SSID> password <密碼>  # 連線 WiFi

# 或使用 iwd（若系統使用 iwd 而非 NetworkManager）
iwctl station wlan0 scan                        # 掃描 WiFi
iwctl station wlan0 connect <SSID>              # 連線 WiFi（會提示輸入密碼）

# 確認網路連線（能 ping 通即代表網路正常）
ping -c 3 nixos.org
```

> **有線網路**：直接插上網路線即可，NetworkManager 會自動取得 IP，無需額外設定。
>
> **注意**：若 `nmcli` 不存在，表示系統未啟用 NetworkManager，可先執行 `sudo systemctl start NetworkManager` 再重試。

### 步驟 6：安裝後套用此配置

```bash
# 進入系統後，先安裝 git（最小化安裝預設沒有 git）
sudo nix-env -iA nixos.git

# 複製此配置
git clone https://github.com/yuukireina2023/nixos-config ~/nixos-config
cd ~/nixos-config

# 產生硬體配置並取代現有檔案
sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix

# 套用系統配置
sudo nixos-rebuild switch --flake .#nixos

# 开机锁屏看不到头像的解决方法
将头像重命名为 ".face" 放入 "/home/yuukireina2023/"
```

> **注意**：此配置面向 **AMD Radeon PRO W6800**（見 `modules/system/amdgpu.nix`）。舊的 `modules/system/nvidia.nix` 已棄用且不再匯入 — 若改用 NVIDIA 顯示卡，請重新啟用並移除 `modules/system/default.nix` 中的 `amdgpu.nix` 匯入。

## 系統檢查

```bash
# Flake 與系統狀態
nix flake check                          # 檢查 flake 是否能正確求值並執行測試
nix flake show                           # 查看 flake 提供的輸出
sudo nixos-rebuild list-generations      # 列出所有系統世代
journalctl -b -p 3                       # 查看本次開機的錯誤日誌（優先級 3 = error）

# 合成器與顯示
niri msg version                         # 確認 niri 版本
rocm-smi                                 # AMD GPU 狀態（溫度、時脈、VRAM）

# 字型與中文顯示
fc-list | grep -i "lxgw wenkai"          # 確認 LXGW WenKai 字型已安裝
fc-cache -fv                             # 重建字型快取（中文顯示為方塊時執行）

# 音訊與輸入法
wpctl status                             # 查看 PipeWire 音訊裝置與預設輸出
pactl info                               # 查看 PulseAudio 伺服器資訊
fcitx5-diagnose                          # 輸入法診斷（fcitx5）

# 休眠與 swap（btrfs 配置）
cat /sys/power/mem_sleep                 # 確認硬體支援的睡眠狀態（[s2idle] shallow deep）
swapon --show                            # 確認 swap 已啟用
cat /proc/cmdline | tr ' ' '\n' | grep resume   # 確認 resume 核心參數指向正確的 swap UUID
systemctl hibernate                      # 測試休眠（需先確認 swap ≥ RAM 且 resume= 已設定）

# btrfs 檔案系統
btrfs filesystem usage /                 # 磁碟使用量與可用空間
btrfs subvolume list /                   # 列出所有子卷
sudo btrfs scrub start /                 # 開始檢查檔案系統完整性（背景執行）
sudo btrfs scrub status /                # 查看 scrub 進度

# 服務
systemctl status postgresql              # 查看 PostgreSQL 服務狀態
systemctl --user status                  # 查看使用者服務狀態
ollama run llama3.1:8b                   # 測試 Ollama 推理
```

### 命令更改速查

```bash
# 重建與套用
sudo nixos-rebuild switch --flake .#nixos    # 套用配置（切換到新世代）
sudo nixos-rebuild test --flake .#nixos      # 測試配置（不永久切換，重開機還原）
sudo nixos-rebuild boot --flake .#nixos      # 下次開機才套用
sudo nixos-rebuild dry-run --flake .#nixos   # 乾跑：只顯示會變更的內容，不實際套用
sudo nixos-rebuild build-vm --flake .#nixos  # 建構為 VM 測試

# Flake 管理
nix flake update                             # 更新所有輸入（nixpkgs、home-manager、noctalia 等）
nix flake update nixpkgs                     # 只更新特定輸入
nix flake lock                               # 重新產生鎖定檔（不更新版本）

# 世代管理與回收
sudo nixos-rebuild rollback                  # 回滾到上一世代
sudo nix-collect-garbage -d                  # 刪除所有舊世代並垃圾回收（釋放磁碟空間）
nix store du --human-readable                # 查看 store 使用量

# Home Manager（整合為 NixOS 模組，見 flake.nix，無獨立 homeConfigurations 輸出）
sudo nixos-rebuild switch --flake .#nixos    # 套用 home 配置（與系統配置一起）
home-manager generations                     # 列出 home 世代

# 開發與套件
nix develop                                  # 進入開發環境（devshell）
nix search nixpkgs <套件名稱>                 # 搜尋套件
nix run nixpkgs#<套件名稱>                    # 直接執行套件（不安裝）
nix shell nixpkgs#<套件名稱>                  # 進入含套件的臨時 shell

# btrfs 快照與備份
sudo btrfs subvolume snapshot -r / /snapshots/root-$(date +%Y%m%d)   # 建立唯讀快照（復原前先備份）
sudo btrfs send /snapshots/root-20260101 | sudo btrfs receive /mnt/backup   # 備份快照到外部磁碟
sudo btrfs balance start /                   # 重新平衡（btrfs 空間不足時）

# 休眠設定（btrfs + swap）
findmnt -no UUID -T /swap/swapfile           # 取得 swap 所在裝置的 UUID
sudo btrfs inspect-internal map-swapfile -r /swap/swapfile   # 取得 btrfs swap 檔案的 resume_offset
# 在 modules/system/boot.nix 的 boot.kernelParams 加入：
#   "resume=UUID=<swap 的 UUID>"
#   "resume_offset=<btrfs map-swapfile 的輸出>"
```

</details>

### 疑難排解

| 問題 | 解決方法 |
|---|---|
| 重建失敗：找不到套件 | 執行 `nix flake update` 更新鎖定檔，或檢查套件名稱是否已變更 |
| 無法登入圖形介面 | 確認 niri 合成器已正確啟動（檢查 `journalctl -b` 中的 niri 相關錯誤） |
| 桌布小工具未顯示 | 執行 `niri msg outputs` 確認主輸出；座標依 4K 邏輯解析度調整，可用 `noctalia msg desktop-widgets-edit` 微調 |
| 中文顯示為方塊 | 執行 `fc-cache -fv` 重建字型快取，確認 Noto Sans CJK / LXGW WenKai 字型已安裝 |
| 輸入法無法使用 | 確認 fcitx5 已啟動（`pgrep fcitx5`），執行 `fcitx5-diagnose` 診斷；Qt 應用需 `QT_IM_MODULE=fcitx`（已於 home 層級設定） |
| Chrome 無法輸入中文 | 確認 Chrome 以 Wayland 模式啟動（`--ozone-platform=wayland --enable-wayland-ime`，已於 niri 綁定與 desktop entry 設定） |
| Steam 遊戲無法全螢幕 | 在 Steam 遊戲「啟動選項」加入 `gamescope -e -- %command%` |
| Ollama 無法使用 GPU | 確認 `ollama-rocm` 已建構，執行 `ollama run llama3.1:8b` 測試 |
| 休眠失敗：`Not enough free memory` | swap 需 ≥ RAM 大小，且 `resume=` 參數指向正確的 swap UUID（參考 [ArchWiki](https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate)） |
| 休眠後立即喚醒 | 檢查 `journalctl -b | grep -i hibernate`，確認 swap 空間足夠且未分散於多個 swap |
| btrfs 空間不足但 `df` 顯示有空間 | 執行 `sudo btrfs balance start /` 重新平衡資料與中繼資料區塊 |
| btrfs 無法建立快照 | 含啟用中 swap 檔案的子卷無法快照，swap 檔案需放在獨立子卷（如 `/swap`） |

</details>

---

<div align="center">

以 ❄ 建構於 NixOS，歡迎自由使用與自訂 :)

</div>
