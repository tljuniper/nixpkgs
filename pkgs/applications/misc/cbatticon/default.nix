{ lib, stdenv, fetchFromGitHub, pkg-config, gettext, glib, gtk3, libnotify, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "cbatticon";
  version = "1.6.12";

  src = fetchFromGitHub {
    owner = "valr";
    repo = pname;
    rev = version;
    sha256 = "sha256-FGCT3gP+KL71Am4cd+f71iY8EwDPRZJ4+FDgQqjZK1M=";
  };

  nativeBuildInputs = [ pkg-config gettext wrapGAppsHook ];

  buildInputs =  [ glib gtk3 libnotify ];

  patchPhase = ''
    sed -i -e 's/ -Wno-format//g' Makefile
  '';

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "Lightweight and fast battery icon that sits in the system tray";
    homepage = "https://github.com/valr/cbatticon";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.domenkozar ];
  };
}
