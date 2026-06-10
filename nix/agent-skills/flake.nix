{
  inputs = {
    agent-skills.url = "github:Kyure-A/agent-skills-nix";
    ja-writing-tools = {
      url = "github:finelagusaz/ja-writing-tools";
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
      ja-writing-tools,
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
    in
    {
      devShells = forEachSystem (
        system:
        let
          pkgs = import nixpkgs { inherit system; };

          agentLib = agent-skills.lib.agent-skills;
          sources = {
            refine-ja = {
              path = ja-writing-tools;
              subdir = "plugins/refine-ja/skills";
            };
            proofread-ja = {
              path = ja-writing-tools;
              subdir = "plugins/proofread-ja/skills";
            };
            typst-skills = {
              path = typst-skills;
            };
          };
          catalog = agentLib.discoverCatalog sources;
          allowlist = agentLib.allowlistFor {
            inherit catalog sources;
            enable =
              # ja-writing-tools
              [
                "proofread-ja"
                "refine-ja"
              ]
              ++
              # typst-skills
              [
                "touying-author"
                "typst-author"
              ];
          };
          selection = agentLib.selectSkills {
            inherit catalog allowlist sources;
            skills = { };
          };
          bundle = agentLib.mkBundle { inherit pkgs selection; };
          localTargets = {
            claude = agentLib.defaultLocalTargets.claude // {
              enable = true;
            };
          };
        in
        {
          default = pkgs.mkShellNoCC {
            shellHook = agentLib.mkShellHook {
              inherit pkgs bundle;
              targets = localTargets;
            };
          };
        }
      );
    };
}
