{ config, lib, ... }:
let
  langsEnabler =
    let reducer = l: r: { "${r}".enable = true; } // l;
    in builtins.foldl' reducer { } config.enabledLanguages;

in
{
  options.enabledLanguages =
    lib.mkOption { type = lib.types.listOf lib.types.str; };

  config = { languages = langsEnabler; };
}
