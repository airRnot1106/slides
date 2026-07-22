{
  inputs = {
    agenput-skills.url = "github:airRnot1106/agenput-skills-nix";
    cognitive-rhythm-writing = {
      url = "git+https://gist.github.com/k16shikano/eb2929f13ed19c97188393d297be8432.git";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";
    japanese-tech-writing = {
      url = "git+https://gist.github.com/k16shikano/fd287c3133457c4fd8f5601d34aa817d.git";
      flake = false;
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    typst-skills = {
      url = "github:apcamargo/typst-skills";
      flake = false;
    };
  };

  outputs =
    {
      self,
      agenput-skills,
      flake-utils,
      nixpkgs,
      ...
    }@inputs:
    let
      # nput's entrypoint discovery only looks at CWD (repo root), so the
      # devShell shellHook must point `-f` back at this file explicitly.
      entrypoint = "nix/agent-skills/flake.nix";

      skills = [
        {
          name = "cognitive-rhythm-writing";
          src = inputs.cognitive-rhythm-writing;
        }
        {
          name = "japanese-tech-writing";
          src = inputs.japanese-tech-writing;
        }
        {
          name = "touying-author";
          src = inputs.typst-skills;
          subpath = "touying-author";
        }
        {
          name = "typst-author";
          src = inputs.typst-skills;
          subpath = "typst-author";
        }
      ];
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        nput.skills-claude = agenput-skills.lib.mkSkillsManifest {
          inherit pkgs skills;
          root = agenput-skills.lib.projectRoot;
          prefix = agenput-skills.lib.presets.claude.project;
        };

        devShells.default = pkgs.mkShellNoCC {
          inputsFrom = [
            (agenput-skills.lib.mkSkillsDevShell {
              inherit pkgs entrypoint;
              names = builtins.attrNames self.nput.${system};
            })
          ];
        };
      }
    );
}
