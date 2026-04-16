{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.development.python;

  corePythonPackages = ps: with ps; [
    numpy
    loguru
    qrcode
    isort
    environs
    virtualenv
    sh
    av
    pipx
    ninja
  ];

  dataSciencePythonPackages = ps: with ps; [
    matplotlib
    mpmath
    pandas
    scikit-learn
    scipy
    sympy
    seaborn
  ];

  webPythonPackages = ps: with ps; [
    flask
    fastapi
    uvicorn
    requests
    scrapy
    beautifulsoup4
    boto3
    internetarchive
  ];

  automationPythonPackages = ps: with ps; [
    celery
    cantools
    canopen
  ];

  testingPythonPackages = ps: with ps; [
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


  enabledOptionalsPackages = ps: with ps;
    lib.optionals cfg.core (corePythonPackages ps)
    ++ lib.optionals cfg.dataScience (dataSciencePythonPackages ps)
    ++ lib.optionals cfg.web (webPythonPackages ps)
    ++ lib.optionals cfg.automation (automationPythonPackages ps)
    ++ lib.optionals cfg.testing (testingPythonPackages ps);

    anyEnabled = lib.any (x: x) [
      cfg.core
      cfg.dataScience
      cfg.web
      cfg.automation
      cfg.testing
    ];
in
{
  options.myConfig.apps.development.python = {
    core = moduleHelpers.mkDisabledOption "Install core Python development packages";
    dataScience = moduleHelpers.mkDisabledOption "Install Python data science and math packages";
    web = moduleHelpers.mkDisabledOption "Install Python web, scraping, and API packages";
    automation = moduleHelpers.mkDisabledOption "Install Python automation, CAN, and Robot Framework packages";
    testing = moduleHelpers.mkDisabledOption "Install Python testing and documentation packages";
  };

  config = lib.mkMerge [ 
    {
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = [
        (pkgs.python314.withPackages enabledOptionalsPackages)
      ];
      environment.shellAliases = {
        python = "python3.14";
      };
    })
  ];
}
