{ lib, rustPlatform, fetchFromGitHub, pkg-config, dbus }:

rustPlatform.buildRustPackage rec {
  pname = "airpods-helper";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "superninjv";
    repo = "airpods-helper";
    rev = "9df8f5f423eae2b4e32f71601d09efcf94abc6e4";
    hash = "sha256-SvcDFvmtUWmAgzrf2P+qfX/9U2mFGrwvgNp0vi0VBDI=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus ];

  postInstall = ''
    install -Dm644 daemon/org.costa.AirPods.service $out/share/dbus-1/services/org.costa.AirPods.service
    sed -i 's|%h/.local/bin/airpods-daemon|/run/wrappers/bin/airpods-daemon|' $out/share/dbus-1/services/org.costa.AirPods.service
    install -Dm644 config.example.toml $out/share/airpods-helper/config.example.toml
  '';

  doCheck = false;

  meta = with lib; {
    description = "Native Apple AirPods support for Linux (ANC, battery, EQ, ear detection, CLI)";
    homepage = "https://github.com/superninjv/airpods-helper";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "airpods-cli";
  };
}
