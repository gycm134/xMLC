    % EXTERNAL_EVALUATION_START starts the run.
    % New control laws are generated in the Population folder and ready to be evaluated.
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also external_evaluation_CONTINUE, External_evaluation_END.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

Initialization;
%% Start
    mlc=MLC('MyProblem');
    mlc.parameters.ProblemParameters.PathExt='';
    
%% Generate population
    mlc.generate_population;
    
%% Save
    mlc.save_matlab('Gen0');
