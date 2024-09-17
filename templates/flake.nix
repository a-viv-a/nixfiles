{
  description = "Aviva's flake templates";

  outputs =
    { self, ... }:
    {
      templates = {
        rust = {
          path = ./rust;
          description = "a rust project, with analysis and runner support";
        };
      };
    };
}
