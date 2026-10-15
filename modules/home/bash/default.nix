{ pkgs, ... }:
{
  programs.bash = {
    enable = true;
    shellAliases = {
      "ff" = "clear && fastfetch";
      "fm" = "yazi";
    };

    bashrcExtra = ''
      if [[ $- == *i* ]]; then
        fastfetch
        if [ -f "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh" ]; then
          source "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"
        fi
      fi
    '';

  };

  home.sessionVariables = {
    PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
    PRISMA_QUERY_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/query-engine";
    PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines}/lib/libquery_engine.node";
    PRISMA_FMT_BINARY = "${pkgs.prisma-engines}/bin/prisma-fmt";
  };
}
