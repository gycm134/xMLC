function evolve_population(MLC)
    % EXTERNAL_EVALUATION evolves the last evaluated population
    % Crates a new evaluation thanks to genetic operators.
    % It should only be called by the GO.
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also go, evaluate_population, generate_population.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

%% Parameters
    PopSize = MLC.parameters.PopulationSize;
    
%% Generation
  Ngen = length(MLC.population);
  if not(strcmp(MLC.population(Ngen).evaluation,'evaluated'))
        fprintf('Generation %s not evaluated yet.\n',num2str(Ngen))
        disp('To evaluate the population: mlc.evaluate_population;')
        return
  end
      fprintf('Generation %s\n',num2str(Ngen+1))

%% Population evolution
  MLC.population(Ngen+1)=MLCpop(Ngen+1,PopSize);
  MLC.population(Ngen+1)=MLC.population(Ngen).evolve_pop(MLC.parameters,MLC.table);

%% Clean population (pretesting and possibility to add more stuff)
  MLC.population(Ngen+1).clean(MLC.parameters,MLC.table,MLC.population(max(1,Ngen)));

%% Update properties
    PopGen_plusone = MLC.population(Ngen+1);
    PopGen_plusone.evaluation = 'ready_to_evaluate';
    PopGen_plusone.CreationOrder = 1:PopSize;
  MLC.population(Ngen+1) = PopGen_plusone;
  
%% External evaluation
  if strcmp(MLC.parameters.EvaluationFunction,'external')
  % Generation of the GenN_population.mat file for evaluation
    external_evaluation(MLC,0);
      fprintf('Evaluation can begin\n')
  else
      fprintf('\n')
      disp('To evaluate the population: mlc.evaluate_population;')
  end
  
end
