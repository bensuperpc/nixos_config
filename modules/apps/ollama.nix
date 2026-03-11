{ lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:
{
  services.ollama = {
    enable = true;
    # ollama-cpu, ollama-vulkan, or ollama-cuda
    package = lib.mkDefault pkgs.ollama-vulkan;
    host = "0.0.0.0";
    port = 11434;
    syncModels = true;
    loadModels = [
      "qwen3.5:0.8b"
      "qwen3.5:9b"
    ];
    environmentVariables = {
      OLLAMA_GPU_OVERHEAD = 0;
      OLLAMA_VULKAN = 1;
      OLLAMA_NEW_ENGINE = 1;
      # OLLAMA_GPU_LAYERS = 25;
      # OLLAMA_SCHED_SPREAD = 1;
      # OLLAMA_FLASH_ATTENTION = 1;
    };
  };
  services.open-webui = {
    enable = config.services.ollama.enable;
    host = "0.0.0.0";
    port = 3000;
    environment = {
      OLLAMA_API_BASE_URL = "http://localhost:11434";
    }; 
  };
  networking.firewall.allowedTCPPorts = [
    config.services.ollama.port
    config.services.open-webui.port
  ];
}