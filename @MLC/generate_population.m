function generate_population(MLC)
    % GENERATE_POPULATION generates the first population
    % Creates the first generation if it doesn't exist.
    % The population needs then to be evaluated.
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also evaluate_population, evolve_population

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

%% Parameters
  PopSize = MLC.parameters.PopulationSize;
  Name = MLC.parameters.Name;
  
%% Create folders
    create_folders(Name);
    
%% First generation
    if isempty(MLC.population)
        % Create the first population
            MLC.population=MLCpop(1,PopSize);
            MLC.population.create_pop(MLC.parameters,MLC.table);
        % Clean population (pretesting and stuff )
            if MLC.parameters.OptiMonteCarlo
              MLC.population.clean(MLC.parameters,MLC.table,MLC.population);
            end
        % Update properties
            MLC.population.evaluation = 'ready_to_evaluate';
            MLC.population.CreationOrder = 1:PopSize;
    else
        fprintf('First population already generated\n')
    end

%% External evaluation
  if strcmp(MLC.parameters.EvaluationFunction,'external')
    %Generation of the GenN_population.mat file for evaluation----------------------
      external_evaluation(MLC,0);
      fprintf('Evaluation can begin\n')
  else
      fprintf('\n')
      disp('To evaluate the population: mlc.evaluate_population;')
  end

end
