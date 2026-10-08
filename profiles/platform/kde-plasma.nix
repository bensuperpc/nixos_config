{ moduleHelpers, ... }:
{
  myConfig.gui = {
    desktop = "plasma";
    plasma = moduleHelpers.mkDefaults {
      integration = true;
      utilities = true;
      multimedia = true;
      education = true;
    };
  };
}
