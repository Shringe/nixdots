{ lib, ... }:
with lib;
let
  # Recursively constructs an attrset of a given folder, recursing on directories, value of attrs is the filetype
  getDir =
    dir:
    mapAttrs (file: type: if type == "directory" then getDir "${dir}/${file}" else type) (
      builtins.readDir dir
    );

  # Collects all files of a directory as a list of strings of paths
  files =
    dir: collect isString (mapAttrsRecursive (path: type: concatStringsSep "/" path) (getDir dir));

  # Filters out directories that don't end with .nix or are this file, also makes the strings absolute
  validFiles =
    dir:
    map (file: ./. + "/${file}") (
      filter (
        file:
        hasSuffix ".nix" file
        && file != "default.nix"
        && !lib.hasPrefix "x/taffybar/" file
        && !lib.hasSuffix "-hm.nix" file
      ) (files dir)
    );

  # Check if a file already defines programs.nixvim
  fileDefinesNixvim =
    file:
    let
      content = builtins.readFile file;
    in
    builtins.match ".*programs\.nixvim.*" content != null;

  # Files that don't already define programs.nixvim, or aren't "wrapped", get wrapped in a programs.nixvim attribute set
  partitionedFiles = partition (file: fileDefinesNixvim file) (validFiles ./.);
  unwrappedFiles = partitionedFiles.wrong;
  wrappedFiles = partitionedFiles.right;

  # Determine and pass plugin enabled status
  # Pass a function rather than a bool, so it's evaluated lazily with config
  isEnabledFor =
    file: isWrappedNixvim: config:
    let
      fileName = lib.removeSuffix ".nix" (baseNameOf (toString file));
    in
    if isWrappedNixvim then
      config.programs.nixvim.plugins.${fileName}.enable
    else
      config.plugins.${fileName}.enable;

  provideIsEnabled =
    file: isWrappedNixvim:
    let
      module = import file;
      isEnabledFn = isEnabledFor file isWrappedNixvim;
    in
    if builtins.isFunction module then
      lib.setFunctionArgs
        (
          args:
          let
            isEnabled = isEnabledFn args.config;
          in
          module (
            args
            // {
              inherit isEnabled;
              ifIsEnabled = lib.mkIf isEnabled;
              ifNotEnabled = lib.mkIf (!isEnabled);
            }
          )
        )
        (
          builtins.functionArgs module
          // {
            isEnabled = true;
            ifIsEnabled = true;
            ifNotEnabled = true;
            config = true;
          }
        )
    else
      module;

  provideIsEnabledWrapped = file: provideIsEnabled file true;
  provideIsEnabledUnwrapped = file: provideIsEnabled file false;
in
{
  programs.nixvim.imports = map provideIsEnabledUnwrapped unwrappedFiles;
  imports = map provideIsEnabledWrapped wrappedFiles;
}
