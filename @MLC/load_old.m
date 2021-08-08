function MLC=load_old(MLC,folder,str)
    % LOAD Load method for MLC (to load old versions).
    % Loads the MLC object (mlc) from the save_runs folder.
    % Two ways :
    % 1. mlc.load('name_of_my_run');
    % 2. mlc.load('_my_folder','name_of_my_run');
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also MLC, go, @MLC/load.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

%% Check which case
  if nargin < 3
      str = folder;
      folder = [];
  end

%% Load data
  DATA = load(['save_runs/' folder '/run_',str,'.mat']);

%% Load properties
  MLC.population = DATA.MLCsave.population;
  MLC.parameters = DATA.MLCsave.parameters;
  MLC.table = DATA.MLCsave.table;
%MLC.generation = l.MLCsave.generation;
