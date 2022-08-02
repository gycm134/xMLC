classdef MLCpop < handle
    % MLCpop Population class for MLC
    % It contain the properties : population (table of individual labels),
    % parameters, table (data base), generation (integer).
    % To initiliaze a MLC object in the variable mlc: mlc = MLC;
    % The default parameters are loaded.
    % To use other parameters, create a my_problem_parameters.m file and load it
    % with the  command : mlc = MLC('my_problem');
    % To run some generations, use the method go.
    %
    % Guy Y. Cornejo Maceda, 2022/07/01
    %
    % See also MLC, MLCind, MLCtable.

    % Copyright: 2022 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % The MIT License (MIT)

    %% Properties
    properties
      % Individuals
        individuals
        costs
        chromosome_lengths
        parents
        operation
     % Population
        generation
        evaluation
     % Individuals
        CreationOrder
        Iteration
    end

    %% External methods
    methods
      % Population
        obj = create_pop(obj,MLC_parameters,MLC_table);
        obj = evaluate_pop(obj,idx_to_eval,MLC_parameters,MLC_table,idx);
        new_pop = evolve_pop(obj,MLC_parameters,MLC_table,aux_population);
      % Process population
        [N,obj] = pretesting(obj,MLC_parameters,MLC_table,pop_olds,idx);
        obj = clean(obj,MLC_parameters,MLC_table,pop_olds,idx);
        obj = remove_bad_individuals(obj,MLC_parameters,MLC_table,pop_old);
        obj = replace_individuals(obj,idx,MLC_parameters,MLC_table,pop_old);
      % Genetic operators
        obj = sort_pop(obj);
        [N,new_obj] = Elitism(new_obj,pop,MLC_parameters,MLC_table);
        new_pop = replication(new_pop,pop,MLC_parameters,MLC_table,n);
        new_pop = mutation(new_pop,pop,MLC_parameters,MLC_table,n);
        new_pop = crossover(new_pop,pop,MLC_parameters,MLC_table,n,f);
      % Find individuals
        idx = find_bad_individuals(obj,MLC_parameters); % individuals whose simulation failed
        idx = find_wrong_individuals(obj,MLC_parameters,MLC_table,bad_values); % individuals that do not satisfy the prestests.
        idx = find_bad_preeval_individuals(obj,MLC_table,bad_values);
    end

    %% Internal methods
    methods
        % Constructor
        function obj = MLCpop(gen,MLC_parameters_PopulationSize)
            Nind = MLC_parameters_PopulationSize;
            obj.individuals = zeros(Nind,1);
            obj.costs = -1*ones(Nind,1);
            obj.chromosome_lengths = zeros(Nind,2);
            obj.generation = gen;
            obj.evaluation = 'nonexistent';
            obj.parents = zeros(Nind,2);
            obj.operation = cell(Nind,1);
            for p=1:Nind
                obj.operation{p}.type = 'random';
            end
            obj.CreationOrder = -1*ones(Nind,1);
            obj.Iteration = -1*ones(Nind,1);
        end
    end
end
