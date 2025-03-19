{
  lib,
  fetchFromGitHub,
  python3Packages,
  libdrm,
  rocmSupport ? true,
}:
python3Packages.buildPythonApplication {
  pname = "exo";
  version = "0-unstable-2024-10-29";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "exo-explore";
    repo = "exo";
    rev = "04d5dca18f9f810228ca98185bde196541f737b4";
    hash = "sha256-MYQz30rbgdXjNahOiM3PhGQIy4oDuspiDJ7l+0G1eaM=";
  };

  build-system = with python3Packages; [setuptools];

  pythonRelaxDeps = true;

  pythonRemoveDeps = ["uuid"];

  dependencies = with python3Packages; [
    aiohttp
    aiohttp-cors
    aiofiles
    blobfile
    grpcio
    grpcio-tools
    jinja2
    netifaces
    numpy
    nvidia-ml-py
    pillow
    prometheus-client
    protobuf
    psutil
    pydantic
    requests
    rich
    safetensors
    tenacity
    tqdm
    transformers
    #tinygrad
    ((tinygrad.override {inherit rocmSupport;}).overridePythonAttrs
      (old: {
        src = fetchFromGitHub {
          owner = "tinygrad";
          repo = "tinygrad";
          rev = "1ea4876dfa2646123a9cbff5a82a76582909165f";
          hash = "sha256-j0vG4V+OMe2PD4Zo4UgdfFGbOpCLtceatibVbghpW8o=";
        };
        disabledTests = old.disabledTests ++ ["test_quant_128"];
      }))
    # >   - nuitka not installed
    #>   - opencv-python not installed
    #>   - scapy not installed
    #   >   - uvloop not installed
    nuitka
    opencv-python
    scapy
    uvloop
    (pkgs.python3Packages.buildPythonPackage rec {
      pname = "pyamdgpuinfo";
      version = "2.1.6";

      src = pkgs.fetchFromGitHub {
        owner = "mark9064";
        repo = "pyamdgpuinfo";
        rev = "v${version}";
        hash = "sha256-waHLLGefLAq9qjuaeLGItAIsgXi2SZPKJzxax4HYQ7U=";
      };

      pyproject = true;
      build-system = with python3Packages; [cython setuptools];
      buildInputs = [libdrm];

      postPatch = ''
        substituteInPlace ./setup.py \
          --replace-fail '"/usr/include/libdrm"' '"${lib.getDev libdrm}/include/libdrm", "${lib.getDev libdrm}/include"'
      '';

      meta = {
        homepage = "https://github.com/mark9064/pyamdgpuinfo";
        description = "Python module that provides AMD GPU information";
        licenses = with lib.licenses; [gpl3Only];
        platforms = ["x86_64-linux"];
      };
    })
  ];

  pythonImportsCheck = [
    "exo"
    "exo.inference.tinygrad.models"
  ];

  nativeCheckInputs = with python3Packages; [
    mlx
    pytestCheckHook
  ];

  disabledTestPaths = [
    "test/test_tokenizers.py"
  ];

  # Tests require `mlx` which is not supported on linux.
  doCheck = false;

  meta = {
    description = "Run your own AI cluster at home with everyday devices";
    homepage = "https://github.com/exo-explore/exo";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [GaetanLepage];
    mainProgram = "exo";
  };
}
