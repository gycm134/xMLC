function External_evaluation_CONTINUE(gen)
    % EXTERNAL_EVALUATION_CONTINUE continues the run.
    % To be used after the evaluation of the individuals of generation GEN.
    % Retrieves the cost information and makes the population evolve.
    % New control laws are generated in the Population folder and ready to 
    % be evaluated.
    %
    % Guy Y. Cornejo Maceda, 2022/07/01
    %
    % See also External_evaluation_END, External_evaluation_START.

    % Copyright: 2022 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % The MIT License (MIT)

%Evolve_population_script
Initialization;
mlc=MLC('MyExternalPlant');
%% Load
    mlc.load_matlab('ExternalTestRun',['Gen',num2str(gen-1)]);

%% Complete
    matJ = External_build_matJ(mlc.parameters,gen);
    complete_evaluation(mlc,gen,matJ);

%% Evolve
    evolve_population(mlc);

%% Save
    mlc.save_matlab(['Gen',num2str(length(mlc.population)-1)]);
    

