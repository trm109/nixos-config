{ pkgs, ... }:
{
  #openldap
  services.openldap = {
    enable = true;
  };
}
