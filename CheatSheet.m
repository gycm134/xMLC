    % GMFM cheat sheet
    % Contains basic parameters and functions to run MLC on any dynamical
    % system.
    % The sections should be executed one by one.
    %
    % Guy Y. Cornejo Maceda, 2022/07/01
    %
    %
    % Copyright: 2022 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % The MIT License (MIT)

%% Initialization
% Loads all the path files and create a mlc object
    Initialization;
    
%% Clean last run
    % Delete the last run to avoid overwritings
    system('rm -r save_runs/AQuickTest');
    
%% Initialization
    % To load the toy problem (GMFM)
    mlc = MLC;
    % To load my problem
%     mlc = MLC('MyProblem'); % see save_runs/MyProblem/MyProblem_parameters.m
    
%% Update parameters
    mlc.parameters.Name = 'AQuickTest';
    mlc.parameters.PopulationSize=100;
    mlc.parameters.Elitism = 1;
    mlc.parameters.CrossoverProb = 0.6;
    mlc.parameters.MutationProb = 0.3;
    mlc.parameters.ReplicationProb = 0.1;
   
%% Go
    % Create the first generation
    mlc.generate_population;
    % Evaluate it
    mlc.evaluate_population;
    
    % Gen 2
    % Generate the next generation
    mlc.evolve_population;
    % Evaluate it
    mlc.evaluate_population;
    
    % Gen 3
    % Generate and evaluate the next generation
    mlc.go
    
    % Evolve 7 more generations until Gen 10
    mlc.go(10);
    
%% Save
    mlc.save_matlab;

%% Extract the best individua
    mlc.best_individual;
    
%% Save with another name
    % We change the name to avoid overwriting
    mlc.parameters.Name = 'AQuickTest1';
    mlc.save_matlab;    
    
%% Post processing
    % Plot run information such as cost distribution, pareto front,
    % learning curve etc...
    mlc.learning_process;
    mlc.Pareto_diagram;
    mlc.cost_distribution;
    mlc.spectrogram;
    % Best individual
    mlc.best_individual;
    % Print the 10 best individuals after 5 generations
    mlc.best_individuals(5,10);
    % To plot another control
    mlc.plotindiv(IDNumber); % where IDNumber is the ID number of another individual.
    mlc.give(IDNumber); % gives some information about this individual.
    
%% Print the current figure
    % The current figure is printed in eps and png format in the
    % save_runs/AQuickTest/Figures folder
    mlc.printfigure('NameOfMyFigure_1');
    mlc.printfigure('NameOfMyFigure_1',1); % to overwrite existing figure
    
%% Continue from previous save
    % Load
    mlc.load_matlab('AQuickTest');
    % Rename to avoid overwritings
    mlc.parameters.Name = 'AQuickTest2';
    % Change parameters
    mlc.parameters.Elitism = 0;
    mlc.parameters.CrossoverProb = 0.3;
    mlc.parameters.MutationProb = 0.5;
    mlc.parameters.ReplicationProb = 0.2;
    % Run 5 more generaions
    mlc.go(10);
    % Save
    mlc.save_matlab;
    % Best individual
    mlc.best_individual;
    % Print
    mlc.printfigure('NameOfMyFigure_2');
    
%% Plot sensor, constant and operators distribution
    % Plots sensor, constant and operators distribution in 
    % save_runs/AQuickTest/Figures/. The name of the plots begin with the
    % generation.
    % To plot information concerning the first generation:
    mlc.CL_descriptions(1);
    % To plot information concerning generation 5 and 10:
    mlc.CL_descriptions([5,10]);
