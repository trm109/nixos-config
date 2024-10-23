{ home-manager, ... }:
{
  imports = [
    ./hosts
    ./modules
    ./users
  ];
}
