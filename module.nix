{ pkgs, ... }:

{
  config = {
    nixpkgs.overlays = [ (import ./overlay.nix) ];
    services.nginx = {
      enable = true;
      virtualHosts."holyjit.org" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          root = pkgs.holyjit-org;
          index = "index.html";
          extraConfig = ''
            error_page 404 /404.html;
          '';
        };
      };
    };
  };
}
