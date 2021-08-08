function evaluate_population(MLC,Gen)
    % EVALUATE_POPULATION evaluates a population
    % Evaluates Gen population of MLC if it is not evaluated.
    % It should only be used for problem that require an evaluation with matlab.
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also evaluate_population, evolve_population

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

%% Parameters
    EvaluationFunction = MLC.parameters.EvaluationFunction;

%% Test
  if strcmp(EvaluationFunction,'external')
    fprintf('Evaluation is external (Fortran, experiment..)\n')
    fprintf(' Once the control laws are evaluated\n')
    fprintf(' run the complete_evaluation.m method.\n')
    return
  end
  
%% Arguments
    if nargin < 2
        Gen=length(MLC.population);
        if strcmp(MLC.population(Gen).evaluation,'evaluated')
            disp('Last population already evaluated.')
            disp('To reevaluate population P: mlc.evaluate_population(P);')
            disp('To create the next generation : mlc.evolve_population;')
            return
        end
    end

%% Evaluation of the population
    idx = 1:MLC.parameters.PopulationSize;
    MLC.population(Gen).evaluate_pop(idx,MLC.parameters,MLC.table);

%% Remove bad_individuals and evaluate
    if MLC.parameters.RemoveBadIndividuals
        MLC.population(Gen).remove_bad_individuals(MLC.parameters,MLC.table,MLC.population(max(1,Gen-1)));
    end

%% Sorting
    MLC.population(Gen).sort_pop;

%% Update MLC properties
    if nargin < 2
        PopGen = MLC.population(Gen);
        PopGen.evaluation = 'evaluated';
        MLC.population(Gen) = PopGen;
        MLC.generation = MLC.generation+1;
    end
    fprintf('\n')
    
%% Print
    disp('To create the next generation : mlc.evolve_population;')
end
