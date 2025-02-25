{ lib
, buildPythonPackage
, click
, click-completion
, factory_boy
, faker
, fetchPypi
, inquirer
, notify-py
, pbr
, pendulum
, ptable
, pytest-mock
, pytestCheckHook
, pythonOlder
, requests
, twine
, validate-email
}:

buildPythonPackage rec {
  pname = "toggl-cli";
  version = "3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "togglCli";
    inherit version;
    sha256 = "sha256-SkA/u1q//AyYn0v6uAXXsjANhFppxxjKhlhWhsK649w=";
  };

  nativeBuildInputs = [
    pbr
    twine
  ];

  propagatedBuildInputs = [
    click
    click-completion
    inquirer
    notify-py
    pbr
    pendulum
    ptable
    requests
    validate-email
  ];

  checkInputs = [
    pytestCheckHook
    pytest-mock
    faker
    factory_boy
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "notify-py==0.3.1" "notify-py>=0.3.1" \
      --replace "click==7.1.2" "click>=7.1.2" \
      --replace "pbr==5.5.1" "pbr>=5.5.1"
    substituteInPlace pytest.ini \
      --replace ' --cov toggl -m "not premium"' ""
  '';

  preCheck = ''
    export TOGGL_API_TOKEN=your_api_token
    export TOGGL_PASSWORD=toggl_password
    export TOGGL_USERNAME=user@example.com
  '';

  disabledTests = [
    "integration"
    "premium"
    "test_parsing"
    "test_type_check"
    "test_now"
  ];

  pythonImportsCheck = [
    "toggl"
  ];

  meta = with lib; {
    description = "Command line tool and set of Python wrapper classes for interacting with toggl's API";
    homepage = "https://toggl.uhlir.dev/";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut ];
  };
}
