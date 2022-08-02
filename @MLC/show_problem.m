function show_problem(MLC)
    % MLC class show_problem method
    %
    % Guy Y. Cornejo Maceda, 2022/07/01
    %
    % See also best_individual.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % The MIT License (MIT)
    
%% Initialization
param = MLC.parameters;

%% Borders
% Header
fprintf('====================== ')
fprintf('xMLC v%s',num2str(MLC.version))
fprintf(' ====================\n')

% Plot
fprintf(['Name of the run : ',param.Name,'\n'])
fprintf(['Problem to solve : ',param.EvaluationFunction,'\n'])
fprintf(['Problem type : ',param.ProblemType,'\n'])
if strcmp(param.ProblemType,'external') || strcmp(param.ProblemType,'LabView')
    fprintf(['Problem type : ',param.ProblemType,'\n'])
end
fprintf(['   Number of actuators : ',num2str(param.ProblemParameters.OutputNumber),'\n'])
fprintf(['   Number of control inputs : ',num2str(param.ProblemParameters.InputNumber),'\n'])
fprintf('\n')
fprintf('Parameters : \n')
fprintf(['   Population size : ',num2str(param.PopulationSize),'\n'])
fprintf('   Elitism : %i\n',param.Elitism)
fprintf('   Operator probabilities : \n')
fprintf('      Crossover : %0.3f\n',param.CrossoverProb)
fprintf('      Mutation : %0.3f\n',param.MutationProb)
fprintf('      Replication : %0.3f\n',param.ReplicationProb)
% Plot
fprintf('\n')

% To continue
disp('To generate a population : mlc.generate_population;')
disp('To run N generations : mlc.go(N);')
%% Borders
fprintf('===========================')
fprintf('===========================\n')
end %method
