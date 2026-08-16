{ pkgs, ... }:

{
  # Ollama (model runner)
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm; # AMD Radeon PRO W6800

    loadModels = [ "llama3.1:8b" ]; # auto-pulls on rebuild

    environmentVariables = {
      OLLAMA_NOANALYTICS = "1"; # disable telemetry
    };
  };
}
