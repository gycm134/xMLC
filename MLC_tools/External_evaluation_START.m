    % EXTERNAL_EVALUATION_START starts the run.
    % This script generates the first generation of individuals and
    % creates a file Gen1population.mat , a cell array containing the
    % control laws to evaluate.
    % The file is locate in save_runs/RUNNAME/Populations.
    %
    % Guy Y. Cornejo Maceda, 2022/07/01
    %
    % See also external_evaluation_CONTINUE, External_evaluation_END.

    % Copyright: 2022 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % The MIT License (MIT)

Initialization;
%% Start
    mlc=MLC('MyExternalPlant');
    mlc.parameters.PathExt='';
    
%% Generate population
    mlc.generate_population;
    
%% Save
    mlc.save_matlab('Gen0');
