{ pkgs, ... }:

{
  config = {
    nixpkgs.overlays = [ (import ./overlay.nix) ];
    services.nginx = {
      enable = true;
      virtualHosts."holyjit.org" = {
        forceSSL = true;
        enableACME = true;
        locations."/".root = pkgs.holyjit-org;
      };
    };
  };
}
