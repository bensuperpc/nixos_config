{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:

{

  environment.shellAliases = {
    python = "python3.14";
  };

  environment.systemPackages = with pkgs; [
    (python314.withPackages (ps: with ps; [
      ninja
      numpy
      loguru
    #   ipython
    #   ipykernel
    #   jupyter
      matplotlib
      mpmath
      pandas
      scikit-learn
      scipy
      sympy
      seaborn
    #   celery
      robotframework
      beautifulsoup4
      boto3
      pipx
      # HTTP/Web libraries
      flask
      fastapi
      uvicorn
      requests
      scrapy
      internetarchive 
    ]))
  ];
}