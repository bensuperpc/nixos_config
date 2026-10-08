{
  config,
  lib,
  pkgsSets,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.development.python;

  groups = {
    core = {
      description = "Install core Python development packages";
      pythonPackages =
        ps: with ps; [
          numpy
          loguru
          qrcode
          isort
          environs
          virtualenv
          sh
          av
          # pipx # buggy in 1.8.0 with python 3.14
          ninja
        ];
    };
    dataScience = {
      description = "Install Python data science and math packages";
      pythonPackages =
        ps: with ps; [
          matplotlib
          mpmath
          pandas
          scikit-learn
          scipy
          sympy
          seaborn
        ];
    };
    web = {
      description = "Install Python web, scraping, and API packages";
      pythonPackages =
        ps: with ps; [
          flask
          fastapi
          uvicorn
          requests
          scrapy
          beautifulsoup4
          boto3
          internetarchive
        ];
    };
    automation = {
      description = "Install Python automation and CAN packages";
      pythonPackages =
        ps: with ps; [
          celery
          cantools
          canopen
        ];
    };
    llm = {
      description = "Install Python LLM and AI packages";
      pythonPackages =
        ps: with ps; [
          unsloth
          transformers
          datasets
          peft
          trl
          torch
        ];
    };
    testing = {
      description = "Install Python testing, documentation, and Robot Framework packages";
      pythonPackages =
        ps: with ps; [
          pytest
          pytest-bdd
          sphinx
          robotframework
          robotframework-seleniumlibrary
          robotframework-requests
          robotframework-pythonlibcore
          robotframework-databaselibrary
          robotframework-assertion-engine
        ];
    };
  };

  generated = moduleHelpers.mkPackageGroupModule { inherit cfg groups; };

  enabledPythonPackages =
    ps: lib.concatMap (name: groups.${name}.pythonPackages ps) generated.enabledGroups;
in
{
  options.myConfig.apps.development.python = generated.options;

  config = lib.mkIf generated.anyEnabled {
    environment.systemPackages = [
      (
        (pkgsSets.stable-2605.python313.override {
          packageOverrides =
            if cfg.web then
              (_pyFinal: pyPrev: {
                scrapy = pyPrev.scrapy.overrideAttrs (_old: {
                  doCheck = false;
                  doInstallCheck = false;
                });
              })
            else
              (_pyFinal: _pyPrev: { });
        }).withPackages
          enabledPythonPackages
      )
    ];
  };
}
