{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, meson
, ninja
, pkgconfig
, python3Packages
, dbus
, glslang
, libglvnd
, libXNVCtrl
, mesa
, vulkan-headers
, vulkan-loader
, xorg
}:

stdenv.mkDerivation rec {
  pname = "mangohud${lib.optionalString stdenv.is32bit "_32"}";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "flightlessmango";
    repo = "MangoHud";
    rev = "v${version}";
    sha256 = "038ywhcfskmkqgninlyy24ns8a8fmwrx7arqk9cim96xv10vz3y2";
  };

  mesonFlags = [
    "-Dappend_libdir_mangohud=false"
    "-Duse_system_vulkan=enabled"
    #"--libdir=lib${lib.optionalString stdenv.is32bit "32"}"
    "--libdir=lib${if stdenv.is64bit then "64" else "32"}"
  ];

  buildInputs = [
    dbus
    glslang
    libglvnd
    libXNVCtrl
    mesa
    python3Packages.Mako
    vulkan-headers
    vulkan-loader
    xorg.libX11
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    python3Packages.Mako
    python3Packages.python
  ];

  preConfigure = ''
    mkdir -p "$out/share/vulkan/"
    ln -sf "${vulkan-headers}/share/vulkan/registry/" $out/share/vulkan/
    ln -sf "${vulkan-headers}/include" $out
  '';

  meta = with lib; {
    description = "A Vulkan and OpenGL overlay for monitoring FPS, temperatures, CPU/GPU load and more";
    homepage = "https://github.com/flightlessmango/MangoHud";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ zeratax ];
  };
}
