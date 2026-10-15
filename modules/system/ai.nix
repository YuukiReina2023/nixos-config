{ pkgs, ... }:

{
  environment.systemPackages = [
    # 暂时将 lmstudio 注释掉，避免网络不通导致构建失败，等网络顺畅时再开启
    # pkgs.lmstudio
  ];

  # Ollama (model runner)
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm; # AMD Radeon PRO W6800

    loadModels = [ "llama3.1:8b" ]; # auto-pulls on rebuild

    environmentVariables = {
      OLLAMA_NOANALYTICS = "1"; # disable telemetry
      HSA_OVERRIDE_GFX_VERSION = "10.3.0"; # AMD Radeon PRO W6800 (gfx1030 / RDNA2)
    };
  };
}
