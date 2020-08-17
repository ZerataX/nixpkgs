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
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "flightlessmango";
    repo = "MangoHud";
    rev = "acf2d88fbcb7a7a47f957a87d20739c67049bd0d";
    sha256 = "0qmprnxrvh8bkn6dnrk22v53am3flpixh046w7ach3pnfck1hpfb";
  };

  mesonFlags = [
    "-Dappend_libdir_mangohud=false"
    "-Duse_system_vulkan=enabled"
    "--libdir=lib${lib.optionalString stdenv.is32bit "32"}"
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
