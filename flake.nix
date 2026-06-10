{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    typix = {
      url = "github:loqusion/typix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      flake-utils,
      nixpkgs,
      typix,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (pkgs) lib;

        typixLib = typix.lib.${system};

        commonArgs = {
          typstSource = "main.typ";

          fontPaths = [
            "${pkgs.noto-fonts-cjk-sans-static}/share/fonts/opentype/noto-cjk"
            "${pkgs.hackgen-nf-font}/share/fonts/hackgen-nf"
          ];

          virtualPaths = [
          ];
        };

        unstable_typstPackages = [
          {
            name = "rose-pine";
            version = "0.2.1";
            hash = "sha256-2kjQ7A2srog4+elaiaznXTcOqNaLvP4HErsmW6BNChg=";
          }
          {
            name = "touying";
            version = "0.7.4";
            hash = "sha256-G7Z+7o6SQjRa63DCLXcSNAtzohrk4Kljk4pSb4rJfeU=";
          }
          {
            name = "uniwarn";
            version = "0.1.1";
            hash = "sha256-alpI7IgUJfjxDy6KXlPGX2N9KMEHPms/pbxXHRJrmZw=";
          }
        ];

        slidesDir = ./slides;
        deckNames = builtins.attrNames (
          lib.filterAttrs (
            name: type:
            type == "directory" && builtins.pathExists (slidesDir + "/${name}/${commonArgs.typstSource}")
          ) (builtins.readDir slidesDir)
        );

        buildArgs = commonArgs // {
          inherit unstable_typstPackages;
        };

        mkDeck =
          name:
          let
            src = typixLib.cleanTypstSource (slidesDir + "/${name}");
            pdfOutput = "slides/${name}/dist/${name}.pdf";
          in
          {
            drv = typixLib.buildTypstProject (buildArgs // { inherit src; });

            build-script = typixLib.buildTypstProjectLocal (
              buildArgs
              // {
                inherit src;
                typstOutput = pdfOutput;
                scriptName = "build-${name}";
              }
            );

            watch-script = typixLib.watchTypstProject (
              commonArgs
              // {
                typstSource = "slides/${name}/${commonArgs.typstSource}";
                typstOutput = pdfOutput;
                scriptName = "watch-${name}";
              }
            );
          };

        decks = lib.genAttrs deckNames mkDeck;

        mkSelector =
          {
            name,
            script,
          }:
          pkgs.writeShellApplication {
            inherit name;
            runtimeInputs = [ pkgs.fzf ];
            text = ''
              deck=$(printf '%s\n' ${lib.escapeShellArgs deckNames} \
                | fzf --prompt='${name}> ' --select-1 --exit-0) || exit 1
              case "$deck" in
              ${lib.concatMapStringsSep "\n" (
                n: "${n}) exec ${lib.getExe decks.${n}.${script}} \"$@\" ;;"
              ) deckNames}
              *) echo "no slide selected" >&2; exit 1 ;;
              esac
            '';
          };

        build-selector = mkSelector {
          name = "build";
          script = "build-script";
        };
        watch-selector = mkSelector {
          name = "watch";
          script = "watch-script";
        };
      in
      {
        packages = lib.mapAttrs (_: deck: deck.drv) decks;

        apps = {
          build = flake-utils.lib.mkApp { drv = build-selector; } // {
            meta.description = "Select a slide and build it";
          };
          watch = flake-utils.lib.mkApp { drv = watch-selector; } // {
            meta.description = "Select a slide and watch it for changes";
          };
        };

        checks = lib.mapAttrs' (name: deck: lib.nameValuePair "build-${name}" deck.drv) decks;

        devShells.default = typixLib.devShell {
          inherit (commonArgs) fontPaths virtualPaths;
          packages = map (name: decks.${name}.watch-script) deckNames;
        };
      }
    );
}
