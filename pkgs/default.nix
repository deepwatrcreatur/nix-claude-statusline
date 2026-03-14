{ pkgs, lib }:

pkgs.stdenvNoCC.mkDerivation rec {
  pname = "claude-statusline";
  version = "1.0.4";

  src = pkgs.fetchFromGitHub {
    owner = "kamranahmedse";
    repo = "claude-statusline";
    rev = "6928c1464a6d0b72a42a7744ec754de69c98d9d1";
    hash = "sha256-V5R4ilek/cfOvAruGxbUEtAsxQs0h5TzXWugwQUESCI=";
  };

  nativeBuildInputs = [ pkgs.makeWrapper ];

  # Runtime dependencies for the statusline script
  runtimeDeps = [
    pkgs.jq
    pkgs.curl
    pkgs.git
    pkgs.coreutils
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/claude-statusline

    # Install the statusline script
    cp bin/statusline.sh $out/share/claude-statusline/statusline.sh
    chmod +x $out/share/claude-statusline/statusline.sh

    # Create wrapper with dependencies in PATH
    makeWrapper $out/share/claude-statusline/statusline.sh $out/bin/claude-statusline \
      --prefix PATH : "${lib.makeBinPath runtimeDeps}"

    runHook postInstall
  '';

  meta = {
    description = "A status line for Claude Code CLI showing model, context usage, rate limits, and more";
    homepage = "https://github.com/kamranahmedse/claude-statusline";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "claude-statusline";
  };
}
