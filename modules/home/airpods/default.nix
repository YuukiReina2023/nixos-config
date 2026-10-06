{ pkgs, ... }:

let
  airpodsStatusScript = pkgs.writeShellScriptBin "airpods-status" ''
    status=$(airpods-cli status --json 2>/dev/null)
    if [ -z "$status" ]; then
      echo '{"text":"","alt":"disconnected","class":"disconnected","tooltip":"AirPods 未连接或守护进程未启动"}'
      exit 0
    fi

    connected=$(echo "$status" | ${pkgs.jq}/bin/jq -r '.Connected // false')
    if [ "$connected" != "true" ]; then
      echo '{"text":"","alt":"disconnected","class":"disconnected","tooltip":"AirPods 未连接"}'
      exit 0
    fi

    model=$(echo "$status" | ${pkgs.jq}/bin/jq -r '.ModelName // .Model // "AirPods"')
    anc_mode=$(echo "$status" | ${pkgs.jq}/bin/jq -r '.AncMode // "off"')
    bat_l=$(echo "$status" | ${pkgs.jq}/bin/jq -r '.BatteryLeft // -1')
    bat_r=$(echo "$status" | ${pkgs.jq}/bin/jq -r '.BatteryRight // -1')
    bat_c=$(echo "$status" | ${pkgs.jq}/bin/jq -r '.BatteryCase // -1')
    chg_l=$(echo "$status" | ${pkgs.jq}/bin/jq -r '.ChargingLeft // false')
    chg_r=$(echo "$status" | ${pkgs.jq}/bin/jq -r '.ChargingRight // false')
    chg_c=$(echo "$status" | ${pkgs.jq}/bin/jq -r '.ChargingCase // false')
    ca=$(echo "$status" | ${pkgs.jq}/bin/jq -r '.ConversationalAwareness // false')

    [ "$chg_l" = "true" ] && icon_l="⚡" || icon_l=""
    [ "$chg_r" = "true" ] && icon_r="⚡" || icon_r=""
    [ "$chg_c" = "true" ] && icon_c="⚡" || icon_c=""

    case_str=""
    if [ "$bat_c" -ge 0 ]; then
      case_str=" [盒:''${bat_c}%''${icon_c}]"
    fi

    case "$anc_mode" in
      noise)
        anc_icon="🛡️"
        anc_cn="降噪"
        class_mode="anc-noise"
        ;;
      transparency)
        anc_icon="👂"
        anc_cn="通透"
        class_mode="anc-transparency"
        ;;
      adaptive)
        anc_icon="🎛️"
        anc_cn="自适应"
        class_mode="anc-adaptive"
        ;;
      *)
        anc_icon="⏹️"
        anc_cn="关闭"
        class_mode="anc-off"
        ;;
    esac

    if [ "$bat_l" -ge 0 ] && [ "$bat_r" -ge 0 ]; then
      text="󰋋 L:''${bat_l}%''${icon_l} R:''${bat_r}%''${icon_r}''${case_str} ''${anc_icon}"
    elif [ "$bat_l" -ge 0 ]; then
      text="󰋋 ''${bat_l}%''${icon_l}''${case_str} ''${anc_icon}"
    elif [ "$bat_r" -ge 0 ]; then
      text="󰋋 ''${bat_r}%''${icon_r}''${case_str} ''${anc_icon}"
    else
      text="󰋋 已连接 ''${anc_icon}"
    fi

    tooltip="''${model}\n──────────────────\n左耳: $([ "$bat_l" -ge 0 ] && echo "''${bat_l}% ''${icon_l}" || echo "未知")\n右耳: $([ "$bat_r" -ge 0 ] && echo "''${bat_r}% ''${icon_r}" || echo "未知")\n充电盒: $([ "$bat_c" -ge 0 ] && echo "''${bat_c}% ''${icon_c}" || echo "未入盒")\n降噪状态: ''${anc_cn} (''${anc_mode})\n对话感知: $([ "$ca" = "true" ] && echo "开启" || echo "关闭")\n──────────────────\n左键: 轮换降噪模式\n右键: 打开控制菜单"

    ${pkgs.jq}/bin/jq -cn \
      --arg text "$text" \
      --arg alt "$anc_mode" \
      --arg tooltip "$tooltip" \
      --arg class "connected $class_mode" \
      '{text: $text, alt: $alt, tooltip: $tooltip, class: $class}'
  '';

  airpodsCycleAncScript = pkgs.writeShellScriptBin "airpods-cycle-anc" ''
    status=$(airpods-cli status --json 2>/dev/null)
    connected=$(echo "$status" | ${pkgs.jq}/bin/jq -r '.Connected // false')
    if [ "$connected" != "true" ]; then
      ${pkgs.libnotify}/bin/notify-send -a "AirPods" -i "audio-headphones" "AirPods" "未连接，无法切换模式"
      exit 1
    fi

    mode=$(echo "$status" | ${pkgs.jq}/bin/jq -r '.AncMode // "off"')
    case "$mode" in
      noise)
        next="transparency"
        msg="👂 已切换至 通透模式"
        ;;
      transparency)
        next="off"
        msg="⏹️ 已关闭 降噪/通透"
        ;;
      *)
        next="noise"
        msg="🛡️ 已切换至 降噪模式"
        ;;
    esac

    airpods-cli anc "$next" 2>/dev/null
    ${pkgs.libnotify}/bin/notify-send -a "AirPods" -i "audio-headphones" -h string:x-canonical-private-synchronous:airpods "AirPods 模式" "$msg"
    pkill -RTMIN+8 waybar 2>/dev/null || true
  '';

  airpodsMenuScript = pkgs.writeShellScriptBin "airpods-menu" ''
    status=$(airpods-cli status --json 2>/dev/null)
    connected=$(echo "$status" | ${pkgs.jq}/bin/jq -r '.Connected // false')

    if [ "$connected" != "true" ]; then
      options="🔄 重新连接 AirPods\n🔍 扫描配对模式耳机\n🩺 系统安装诊断 (Doctor)"
      chosen=$(echo -e "$options" | ${pkgs.rofi}/bin/rofi -dmenu -p "🎧 AirPods (未连接)" -theme-str 'window {width: 460px;}')
      case "$chosen" in
        *"重新连接"*)
          airpods-cli reconnect
          ${pkgs.libnotify}/bin/notify-send -a "AirPods" -i "audio-headphones" "AirPods" "正在重新连接..."
          ;;
        *"扫描配对"*)
          ${pkgs.foot}/bin/foot -T "AirPods 扫描" -e sh -c "airpods-cli scan; read -p '按 Enter 退出...'"
          ;;
        *"诊断"*)
          ${pkgs.foot}/bin/foot -T "AirPods 诊断" -e sh -c "airpods-cli doctor; read -p '按 Enter 退出...'"
          ;;
      esac
      exit 0
    fi

    model=$(echo "$status" | ${pkgs.jq}/bin/jq -r '.ModelName // .Model // "AirPods"')
    anc_mode=$(echo "$status" | ${pkgs.jq}/bin/jq -r '.AncMode // "off"')
    bat_l=$(echo "$status" | ${pkgs.jq}/bin/jq -r '.BatteryLeft // -1')
    bat_r=$(echo "$status" | ${pkgs.jq}/bin/jq -r '.BatteryRight // -1')
    bat_c=$(echo "$status" | ${pkgs.jq}/bin/jq -r '.BatteryCase // -1')
    ca=$(echo "$status" | ${pkgs.jq}/bin/jq -r '.ConversationalAwareness // false')

    header="🎧 ''${model} (左:''${bat_l}% 右:''${bat_r}% 盒:''${bat_c}%)"

    options="🛡️ 开启降噪模式 (Noise Cancellation)\n👂 开启通透模式 (Transparency)\n🎛️ 自适应降噪 (Adaptive)\n⏹️ 关闭降噪/通透 (Off)\n🗣️ 切换对话感知 (当前: $([ "$ca" = "true" ] && echo "开" || echo "关"))\n🎵 均衡器: 低音增强 (Bass Boost)\n🔇 均衡器: 关闭 (EQ Off)\n🔄 重新连接 AirPods\n🔌 断开连接"

    chosen=$(echo -e "$options" | ${pkgs.rofi}/bin/rofi -dmenu -p "$header" -theme-str 'window {width: 520px;}')

    case "$chosen" in
      *"降噪模式"*)
        airpods-cli anc noise
        ${pkgs.libnotify}/bin/notify-send -a "AirPods" -i "audio-headphones" "AirPods" "🛡️ 已开启降噪模式"
        ;;
      *"通透模式"*)
        airpods-cli anc transparency
        ${pkgs.libnotify}/bin/notify-send -a "AirPods" -i "audio-headphones" "AirPods" "👂 已开启通透模式"
        ;;
      *"自适应降噪"*)
        airpods-cli anc adaptive
        ${pkgs.libnotify}/bin/notify-send -a "AirPods" -i "audio-headphones" "AirPods" "🎛️ 已开启自适应降噪"
        ;;
      *"关闭降噪/通透"*)
        airpods-cli anc off
        ${pkgs.libnotify}/bin/notify-send -a "AirPods" -i "audio-headphones" "AirPods" "⏹️ 已关闭降噪"
        ;;
      *"对话感知"*)
        if [ "$ca" = "true" ]; then
          airpods-cli ca off
          ${pkgs.libnotify}/bin/notify-send -a "AirPods" -i "audio-headphones" "AirPods" "🗣️ 已关闭对话感知"
        else
          airpods-cli ca on
          ${pkgs.libnotify}/bin/notify-send -a "AirPods" -i "audio-headphones" "AirPods" "🗣️ 已开启对话感知"
        fi
        ;;
      *"低音增强"*)
        airpods-cli eq bass-boost
        ${pkgs.libnotify}/bin/notify-send -a "AirPods" -i "audio-headphones" "AirPods" "🎵 已应用低音增强均衡器"
        ;;
      *"均衡器: 关闭"*)
        airpods-cli eq off
        ${pkgs.libnotify}/bin/notify-send -a "AirPods" -i "audio-headphones" "AirPods" "🔇 已关闭均衡器"
        ;;
      *"重新连接"*)
        airpods-cli reconnect
        ${pkgs.libnotify}/bin/notify-send -a "AirPods" -i "audio-headphones" "AirPods" "正在重新连接..."
        ;;
      *"断开连接"*)
        airpods-cli disconnect
        ${pkgs.libnotify}/bin/notify-send -a "AirPods" -i "audio-headphones" "AirPods" "已断开连接"
        ;;
    esac
    pkill -RTMIN+8 waybar 2>/dev/null || true
  '';
in
{
  home.packages = [
    airpodsStatusScript
    airpodsCycleAncScript
    airpodsMenuScript
  ];
}
