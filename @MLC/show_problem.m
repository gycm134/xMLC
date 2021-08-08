function show_problem(MLC)
    % MLC class show_problem method
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also best_individual.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA
    
%% Initialization
param = MLC.parameters;

%% Borders
fprintf('======================== ')
fprintf('xMLC')
fprintf(' =======================\n')
fprintf('\n')

% Plot
fprintf(['Name of the run : ',param.Name,'\n'])
fprintf(['Problem to solve : ',param.EvaluationFunction,'\n'])
fprintf(['   Number of actuators       : ',num2str(param.ProblemParameters.OutputNumber),'\n'])
fprintf(['   Number of control inputs  : ',num2str(param.ProblemParameters.InputNumber),'\n'])
fprintf('\n')
fprintf('Parameters : \n')
fprintf(['   Population size : ',num2str(param.PopulationSize),'\n'])
fprintf('\n')
fprintf('Strategy : \n')
fprintf('   Elitism : %i\n',param.Elitism)
fprintf('   Crossover : %f\n',param.CrossoverProb)
fprintf('   Mutation : %f\n',param.MutationProb)
fprintf('   Replication : %f\n',param.ReplicationProb)
% Plot
fprintf('\n')

% To continue
disp('To generate a population : mlc.generate_population;')
disp('To run N generations : mlc.go(N);')
%% Borders
fprintf('===========================')
fprintf('===========================\n')
end %method
