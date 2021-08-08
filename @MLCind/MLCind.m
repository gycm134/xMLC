classdef MLCind < handle
    % MLCind Individual class for MLC
    % This class is used by and MLC object.
    % It defines a control law. Its matrix representation (chromosome),
    % its costs, its string expression (control_law), the reduced matrix
    % containing only the effective instructions, the number of times it
    % appeared during a run, the evaluation time, an hash representation, a
    % numerical equivalent (control_points) and a reference to another
    % individual if needed
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also MLC, create_indiv, evaluate_indiv.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

    %% Properties
    properties
        chromosome
        cost
        control_law
        EI
        occurences
        evaluation_time
        hash
        control_points
        ref
    end

    %% External methods
    methods
        % Create and evaluate
            obj = create_indiv(obj,MLC_parameters,fb0);
            obj = evaluate_indiv(obj,MLC_parameters,visu);
        % Genetic operators
            [mobj,instr] = mutate(obj,MLC_parameters);
            [cobj1,cobj2,pp] = crossover(obj1,obj2,MLC_parameters);
            new_obj = replication(obj);
        % Get information
            le = chromosome_length(obj);
        % Visualization
            plot(obj,MLC_parameters);
    end

    %% Internal methods
    methods
        % Constructor
        function obj = MLCind
            obj.chromosome = [];
            obj.cost = {-1};
            obj.control_law = {};
            obj.EI = [];
            obj.occurences = 1;
            obj.evaluation_time=[];
            obj.hash = 0;
            obj.control_points = [];
            obj.ref = -1;
        end

    end
end
