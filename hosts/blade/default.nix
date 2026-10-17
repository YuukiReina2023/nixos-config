{ config, lib, pkgs, ... }:
{
  networking.hostName = "blade";

  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
    ../../modules/system/default.nix
  ];

  # 1. Intel 平台温控与电源调节
  services.thermald.enable = true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  # 2. 笔记本睡眠与盒盖策略
  services.logind.settings = {
    Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "lock";
    };
  };

  # 3. OpenRazer 驱动与外设生态支持（雷蛇笔记本键盘背光与快捷控制）
  hardware.openrazer = {
    enable = true;
    users = [ "yuukireina2023" ];
  };

  # 4. 本地 AI：针对 NVIDIA RTX 3070 Mobile 启用 CUDA 加速
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    loadModels = [ "llama3.1:8b" ];
    environmentVariables = {
      OLLAMA_NOANALYTICS = "1";
    };
  };

  # 5. 笔记本专属软件包
  environment.systemPackages = with pkgs; [
    polychromatic      # Razer Chroma RGB 控制界面
    nvtopPackages.full # 监视 Intel 核显与 NVIDIA 独显资源
    cudaPackages.cudatoolkit
  ];

  # 6. 笔记本睡眠防误触与唤醒优化：
  # - 保留 PWRB（电源键）、XHC（USB 主控，承载键盘/触控板唤醒）与 AWAC
  # - 白名单放行雷蛇内置键盘 (1532:026f) 唤醒，禁用外接鼠标晃动误唤醒
  # - 禁用 PCIe 桥接端口（RP01-RP24、CNVW Wi-Fi）防止合盖误唤醒
  services.udev.extraRules = lib.mkAfter ''
    ACTION=="add|change", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="1532", ATTRS{idProduct}=="026f", ATTR{power/wakeup}="enabled"
  '';

  systemd.services.disable-acpi-wakeup = {
    description = "Configure laptop sleep wakeup sources";
    wantedBy = [ "multi-user.target" "post-resume.target" ];
    after = [ "multi-user.target" "post-resume.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "configure-laptop-wakeup" ''
        # 确保机箱/笔记本电源键与 USB 主控保持启用
        for target in PWRB XHC AWAC; do
          if grep -qE "^$target\s+.*\*disabled" /proc/acpi/wakeup; then
            echo "$target" > /proc/acpi/wakeup
          fi
        done

        # 禁用多余的 PCIe / WiFi 唤醒端口，防止背包内误唤醒
        while read -r dev _ status _; do
          case "$dev" in
            RP*|CNVW|PEG*|PEGP)
              if [ "$status" = "*enabled" ]; then
                echo "$dev" > /proc/acpi/wakeup
              fi
              ;;
          esac
        done < /proc/acpi/wakeup
      '';
    };
  };
}
