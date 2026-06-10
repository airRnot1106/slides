{ pkgs }:
let
  textlint-plugin-typst = pkgs.buildNpmPackage {
    pname = "textlint-plugin-typst";
    version = "1.4.2";

    src = ./.;
    npmDepsHash = "sha256-Gc0nHxcMRdBIj9ky7wtt5zbp4mt4iB3/GFKjtlfO6Oo=";

    dontNpmBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/lib"
      cp -r node_modules "$out/lib/node_modules"
      runHook postInstall
    '';
  };
in
pkgs.textlint.withPackages (
  with pkgs;
  [
    textlint-filter-rule-comments
    textlint-plugin-typst
    textlint-rule-preset-ai-writing
    textlint-rule-preset-ja-spacing
    textlint-rule-preset-ja-technical-writing
    textlint-rule-terminology
  ]
)
