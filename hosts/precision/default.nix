{ config, lib, pkgs, ... }:
{
  networking.hostName = "precision";

  imports = [
    ./hardware-configuration.nix
    ./amdgpu.nix
    ../../modules/system/default.nix
  ];

  # 台式机工作站始终运行在高性能调度模式
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  # 本地 AI：针对 AMD Radeon PRO W6800 启用 ROCm 加速
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    loadModels = [ "llama3.1:8b" ];
    environmentVariables = {
      OLLAMA_NOANALYTICS = "1";
      HSA_OVERRIDE_GFX_VERSION = "10.3.0"; # AMD Radeon PRO W6800 (gfx1030 / RDNA2)
    };
  };

  # 工作站专属软件包
  environment.systemPackages = with pkgs; [
    rocmPackages.rocm-smi # AMD GPU 状态监控
  ];

  # Precision 工作站睡眠秒醒优化：
  # - 确保 PWRB（机箱电源键）与 XHCI（USB 控制器，承载键盘唤醒）处于启用状态
  # - 禁用多余的 ACPI 唤醒设备（包括 Broadcom WiFi 网卡 PXSX/RP09、Intel 有线网 GBE1、AMD 显卡 PEGP、NVMe BR2D 等）
  # - 仅放行 2.4G 无线键盘接收器（Compx 3554:fa09）与电源键唤醒
  services.udev.extraRules = lib.mkAfter ''
    ACTION=="add|change", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="3554", ATTRS{idProduct}=="fa09", ATTR{power/wakeup}="enabled"
    ACTION=="add|change", SUBSYSTEM=="net", NAME=="enp0s31f6", ATTR{device/power/wakeup}="disabled"
  '';

  systemd.services.disable-acpi-wakeup = {
    description = "Configure desktop sleep wakeup sources (keep only keyboard and power button)";
    wantedBy = [ "multi-user.target" "post-resume.target" ];
    after = [ "multi-user.target" "post-resume.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "configure-desktop-wakeup" ''
        # 1. 确保机箱电源键（PWRB）与 USB 主控（XHCI）保持启用，确保键盘与电源键能唤醒
        for target in PWRB XHCI; do
          if grep -qE "^$target\s+.*\*disabled" /proc/acpi/wakeup; then
            echo "$target" > /proc/acpi/wakeup
          fi
        done

        # 2. 斩草除根：禁用除 PWRB 与 XHCI 之外的所有 ACPI 唤醒源（WiFi、有线网、显卡、NVMe、PCIe 端口等）
        while read -r dev _ status _; do
          if [ "$status" = "*enabled" ] && [ "$dev" != "PWRB" ] && [ "$dev" != "XHCI" ]; then
            echo "$dev" > /proc/acpi/wakeup
          fi
        done < /proc/acpi/wakeup

        # 3. 兜底确保 USB 设备的唤醒状态：仅允许无线键盘 3554:fa09 唤醒，有线鼠标与其他所有 USB 设备一律 disabled
        for dev_dir in /sys/bus/usb/devices/*; do
          if [ -f "$dev_dir/power/wakeup" ]; then
            vid=$(cat "$dev_dir/idVendor" 2>/dev/null || true)
            pid=$(cat "$dev_dir/idProduct" 2>/dev/null || true)
            if [ "$vid" = "3554" ] && [ "$pid" = "fa09" ]; then
              echo enabled > "$dev_dir/power/wakeup"
            else
              echo disabled > "$dev_dir/power/wakeup"
            fi
          fi
        done
      '';
    };
  };
}
