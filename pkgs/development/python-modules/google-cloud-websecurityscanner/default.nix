{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  mock,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-websecurityscanner";
  version = "1.14.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JqI7ELEfq8MUEdk5PI94YZHUc0Hyf3V1qb1ORXPBUz4=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    google-api-core
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "google.cloud.websecurityscanner_v1alpha"
    "google.cloud.websecurityscanner_v1beta"
  ];

  meta = with lib; {
    description = "Google Cloud Web Security Scanner API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-websecurityscanner";
    changelog = "https://github.com/googleapis/google-cloud-python/tree/google-cloud-websecurityscanner-v${version}/packages/google-cloud-websecurityscanner";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
