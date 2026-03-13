{ pkgs, lib }:

pkgs.buildNpmPackage rec {
  pname = "claude-statusline";
  version = "1.0.0"; # From upstream package.json

  src = pkgs.fetchFromGitHub {
    owner = "kamranahmedse";
    repo = "claude-statusline";
    rev = "v${version}"; # Assuming a tag exists, otherwise use commit hash or 'main'
    # Set to "" initially, Nix will tell you the correct hash on first build failure.
    sha256 = "";
  };

  # npmDepsHash is crucial for reproducible Node.js builds.
  # Set to "" initially, Nix will tell you the correct hash on first build failure.
  npmDepsHash = "";

  # Ensure Node.js and other necessary tools are available
  nativeBuildInputs = [
    pkgs.nodejs # For Node.js runtime
    pkgs.jq     # For JSON processing
    pkgs.curl   # For making HTTP requests
    pkgs.git    # For Git operations (if any are performed by the script)
    pkgs.makeWrapper # For wrapProgram
  ];

  # The main executable is index.js
  # buildNpmPackage usually handles creating the bin entry from package.json "bin"
  # You might need a custom installPhase if it's more complex.
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp index.js $out/bin/claude-statusline # Copy the main executable
    chmod +x $out/bin/claude-statusline # Ensure it's executable

    # Wrap the executable to ensure external dependencies (jq, curl, git) are in its PATH at runtime
    wrapProgram $out/bin/claude-statusline --prefix PATH : "${pkgs.lib.makeBinPath [
      pkgs.jq
      pkgs.curl
      pkgs.git
    ]}"

    runHook postInstall
  '';

  meta = {
    description = "A statusline generator for Claude AI interactions";
    homepage = "https://github.com/kamranahmedse/claude-statusline";
    license = pkgs.lib.licenses.mit; # Assuming MIT from repo
  };
}
