{ lib
, fetchFromGitHub
, python3
}:

let
  py = python3.override {
    packageOverrides = self: super: {

      click = super.click.overridePythonAttrs (oldAttrs: rec {
        version = "7.1.2";

        src = oldAttrs.src.override {
          inherit version;
          hash = "sha256-0rUlXHxjSbwb0eWeCM0SrLvWPOZJ8liHVXg6qU37axo=";
        };
      });

    };
  };
in
with py.pkgs;

buildPythonApplication rec {
  pname = "oci-cli";
  version = "3.6.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "oracle";
    repo = "oci-cli";
    rev = "v${version}";
    hash = "sha256-ADjHPRG3QzSWR7FvcTIJdcBYmzZK+SWipdY1giNtaME=";
  };

  propagatedBuildInputs = [
    arrow
    certifi
    click
    configparser
    cryptography
    jmespath
    oci
    pyopenssl
    python-dateutil
    pytz
    pyyaml
    retrying
    six
    terminaltables
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "cryptography>=3.2.1,<=3.4.7" "cryptography" \
      --replace "pyOpenSSL==19.1.0" "pyOpenSSL" \
      --replace "PyYAML>=5.4,<6" "PyYAML" \
      --replace "terminaltables==3.1.0" "terminaltables"
  '';

  # https://github.com/oracle/oci-cli/issues/187
  doCheck = false;

  pythonImportsCheck = [
    " oci_cli "
  ];

  meta = with lib; {
    description = "Command Line Interface for Oracle Cloud Infrastructure";
    homepage = "https://docs.cloud.oracle.com/iaas/Content/API/Concepts/cliconcepts.htm";
    license = with licenses; [ asl20 /* or */ upl ];
    maintainers = with maintainers; [ ilian ];
  };
}
