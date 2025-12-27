{
  lib,
  config,
  ...
}:
let
  cfg = config.modules.services.keyd;
in
{
  options.modules.services.keyd = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Enable the keyring service.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    #users.users.root.extraGroups = [ "keyd" ];
    # make keyd group
    users.groups.keyd = { };
    # Add user to keyd group
    users.users.saik.extraGroups = [ "keyd" ];
    # enable kwallet for all users
    services.keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = [
            "1532:008f" # Wired
            "1532:0090" # 2.4G dongle
            "1532:0092" # Bluetooth
          ];
          settings = {
            # main = {
            #   "1" = "left";
            #   "2" = "up";
            #   "3" = "right";
            #   "4" = "kpminus";
            #   "5" = "macro2(20, 140, leftmouse)";
            #   "6" = "kpplus";
            # };
            aliases = {
              "1" = "button1";
              "2" = "button2";
              "3" = "button3";
              "4" = "button4";
              "5" = "button5";
              "6" = "button6";
              "7" = "button7";
              "8" = "button8";
              "9" = "button9";
              "0" = "button10";
              "minus" = "button11";
              "equals" = "button12";
              #button1 = left
              #button2 = up
              #button3 = right
              #button4 = kpminus
              #button5 = macro2(10, 50, leftmouse)
              #button6 = kpplus

              #"minus" = "button11";
              #"equals" = "button12";
            };
          };
        };
      };
    };
    systemd.services.keyd.serviceConfig = {
      User = "root";
      Group = "keyd";
      #CapabilitiesBoundingSet = [
      #  "CAP_SYS_NICE"
      #  "CAP_SETGID"
      #];
      #ProtectControlGroups = true;
      RestrictSUIDSGID = lib.mkForce false;
    };
  };
}
