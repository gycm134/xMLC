classdef MLCtable < handle
    % MLCtable Data base of all the individuals of the MLC object.
    % It contain the properties : individuals, number, control_points,
    % costlist, non_redundant.
    % The property individual is MLCind array containing all the individuals.
    %
    % Guy Y. Cornejo Maceda, 2022/07/01
    %
    % See also MLC, MLCpop, MLCind.

    % Copyright: 2022 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % The MIT License (MIT)

    %% Properties
    properties
        % Individuals
          individuals
          non_redundant
        % Number
          number
        % Individual information
          control_points
          costlist
    end

    %% External methods
    methods
        [idx,already_exist,obj]=add_indiv(obj,MLC_parameters,indiv,pop_ind);
        index_indiv = find_indiv(obj,indiv)
        index_indiv = find_redundant(obj,indiv)
    end

    %% Internal methods
    methods
        % Constructor
        function obj = MLCtable(parameters,Nind)
            if nargin<2
                Nind=1000;
            end            
            ind = MLCind;
              individuals(Nind) = ind;
            obj.individuals = individuals;
            obj.number = 0;
            Nep = parameters.ControlLaw.ControlPointNumber;
            MI = parameters.ProblemParameters.OutputNumber;
            obj.control_points = NaN(Nind,Nep*MI);
            obj.costlist = -1*ones(Nind,1);
            obj.non_redundant=[];
        end
    end
end
