{
  ...
}:
{
  imports = [
    ./common
    ./drivers
    ./gui
    ./applications
  ];

  config = {
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;
  };
}
