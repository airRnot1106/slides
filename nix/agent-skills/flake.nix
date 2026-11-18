{
  inputs = {
    agenput-skills.url = "github:airRnot1106/agenput-skills-nix";
    airrnot-skills = {
      url = "github:airRnot1106/skills";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    typst-skills = {
      url = "github:apcamargo/typst-skills";
      flake = false;
    };
  };

  outputs =
    {
      agenput-skills,
      flake-utils,
      nixpkgs,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };

        skills = agenput-skills.lib.mkSkills {
          inherit pkgs;
          sets.skills-claude = {
            scope = "project";
            paths = [ agenput-skills.lib.presets.claude.project ];
            sources = [
              {
                src = inputs.airrnot-skills;
                dir = "skills";
                skills = [
                  "code-prose-writing"
                  "japanese-tech-writing"
                ];
              }
              {
                src = inputs.typst-skills;
                skills = [
                  "touying-author"
                  "typst-author"
                ];
              }
            ];
          };
        };
      in
      {
        inherit (skills) layat;

        devShells.default = skills.devShell;
      }
    );
}
