{
  inputs = {
    agent-skills = {
      url = "path:./nix/agent-skills";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nur-packages.url = "github:airRnot1106/nur-packages";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    typix = {
      url = "github:loqusion/typix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      agent-skills,
      flake-utils,
      git-hooks,
      nixpkgs,
      nur-packages,
      treefmt-nix,
      typix,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ nur-packages.overlays.default ];
        };
        inherit (pkgs) lib;

        typixLib = typix.lib.${system};

        # GLib.idle_add rejects keyword args, so pympress's `idle_add(..., unpause=False)`
        # raises TypeError on newer PyGObject. Wrap it in a lambda so idle_add gets a
        # no-arg callable. --replace-fail fails the build if upstream changes this line.
        pympress = pkgs.pympress.overrideAttrs (old: {
          postPatch = (old.postPatch or "") + ''
            substituteInPlace pympress/editable_label.py \
              --replace-fail "GLib.idle_add(self.page_change, unpause=False)" \
                "GLib.idle_add(lambda: self.page_change(unpause=False))"
          '';
        });

        commonArgs = {
          typstSource = "main.typ";

          fontPaths = [
            "${pkgs.biz-ud-gothic}/share/fonts/truetype"
            "${pkgs.font-awesome}/share/fonts/opentype"
            "${pkgs.hackgen-nf-font}/share/fonts/hackgen-nf"
          ];

          virtualPaths = [
            {
              src = ./assets;
              dest = "assets";
            }
          ];
        };

        unstable_typstPackages = [
          {
            name = "fontawesome";
            version = "0.6.1";
            hash = "sha256-wgHLmRlIp79JOsO1qimEdNlHKj+7ojShaYwUFxuWOB0=";
          }
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
            src = typixLib.cleanTypstSource ./.;
            typstSource = "slides/${name}/${commonArgs.typstSource}";
            pdfOutput = "slides/${name}/dist/${name}.pdf";
            deckArgs = {
              inherit src typstSource;
              typstOpts = {
                root = ".";
              };
            };

            handout-build = typixLib.buildTypstProjectLocal (
              buildArgs
              // deckArgs
              // {
                typstOutput = pdfOutput;
                scriptName = "build-${name}-handout";
              }
            );

            presentation-build = typixLib.buildTypstProjectLocal (
              buildArgs
              // deckArgs
              // {
                typstOpts = {
                  root = ".";
                  input = "presentation=true";
                };
                typstOutput = "slides/${name}/dist/${name}-presentation.pdf";
                scriptName = "build-${name}-presentation";
              }
            );
          in
          {
            drv = typixLib.buildTypstProject (buildArgs // deckArgs);

            build-script = pkgs.writeShellApplication {
              name = "build-${name}";
              text = ''
                ${lib.getExe handout-build}
                ${lib.getExe presentation-build}
              '';
            };

            watch-script = typixLib.watchTypstProject (
              commonArgs
              // (builtins.removeAttrs deckArgs [ "src" ])
              // {
                typstOutput = pdfOutput;
                scriptName = "watch-${name}";
              }
            );
          };

        decks = lib.genAttrs deckNames mkDeck;

        mkSelector =
          {
            name,
            runtimeInputs ? [ ],
            run,
          }:
          pkgs.writeShellApplication {
            inherit name;
            runtimeInputs = [ pkgs.fzf ] ++ runtimeInputs;
            text = ''
              deck=$(printf '%s\n' ${lib.escapeShellArgs deckNames} \
                | fzf --prompt='${name}> ' --select-1 --exit-0) || exit 1
              case "$deck" in
              ${lib.concatMapStringsSep "\n" (n: "${n}) ${run n} ;;") deckNames}
              *) echo "no slide selected" >&2; exit 1 ;;
              esac
            '';
          };

        build-selector = mkSelector {
          name = "build";
          run = n: ''exec ${lib.getExe decks.${n}.build-script} "$@"'';
        };

        watch-selector = mkSelector {
          name = "watch";
          run = n: ''exec ${lib.getExe decks.${n}.watch-script} "$@"'';
        };

        present-selector = mkSelector {
          name = "present";
          runtimeInputs = [ pympress ];
          run = n: ''exec pympress "slides/${n}/dist/${n}-presentation.pdf"'';
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
          present = flake-utils.lib.mkApp { drv = present-selector; } // {
            meta.description = "Select a slide and present it with pympress";
          };
        };

        formatter = (treefmt-nix.lib.evalModule pkgs ./nix/treefmt.nix).config.build.wrapper;

        checks = (lib.mapAttrs' (name: deck: lib.nameValuePair "build-${name}" deck.drv) decks) // {
          pre-commit = git-hooks.lib.${pkgs.stdenv.hostPlatform.system}.run (
            import ./nix/pre-commit.nix {
              inherit self pkgs;
            }
          );
        };

        devShells.default =
          let
            inherit (self.checks.${system}.pre-commit) shellHook enabledPackages;
          in
          typixLib.devShell {
            inherit shellHook;
            inherit (commonArgs) fontPaths virtualPaths;
            inputsFrom = [ agent-skills.devShells.${system}.default ];
            packages =
              with pkgs;
              [
                pympress
                tinymist
              ]
              ++ (map (name: decks.${name}.watch-script) deckNames)
              ++ enabledPackages;
          };
      }
    );
}
