{
  inputs = {
    agent-skills.url = "github:airRnot1106/agenput-skills-nix";
    cognitive-rhythm-writing = {
      url = "git+https://gist.github.com/k16shikano/eb2929f13ed19c97188393d297be8432.git";
      flake = false;
    };
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
      agent-skills,
      cognitive-rhythm-writing,
      japanese-tech-writing,
      nixpkgs,
      typst-skills,
      ...
    }:
    let
      inherit (nixpkgs) lib;
      forEachSystem = lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      # nput's entrypoint discovery only looks at CWD (repo root), so the
      # devShell shellHook must point `-f` back at this file explicitly.
      entrypoint = "nix/agent-skills/flake.nix";

      skills = [
        {
          name = "cognitive-rhythm-writing";
          src = cognitive-rhythm-writing;
        }
        {
          name = "japanese-tech-writing";
          src = japanese-tech-writing;
        }
        {
          name = "touying-author";
          src = typst-skills;
          subpath = "touying-author";
        }
        {
          name = "typst-author";
          src = typst-skills;
          subpath = "typst-author";
        }
      ];
    in
    {
      nput = forEachSystem (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          skills-claude = agent-skills.lib.mkSkillsManifest {
            inherit pkgs skills;
            root = agent-skills.lib.projectRoot;
            prefix = agent-skills.lib.presets.claude.project;
          };
        }
      );

      devShells = forEachSystem (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShellNoCC {
            inputsFrom = [
              (agent-skills.lib.mkSkillsDevShell {
                inherit pkgs entrypoint;
                names = [ "skills-claude" ];
              })
            ];
          };
        }
      );
    };
}
