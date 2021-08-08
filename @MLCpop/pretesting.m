function [IND,pop] = pretesting(pop,MLC_parameters,MLC_table,pop_old,idx_bad_values)
    % PRETESTING removes wrong individuals
    % Wrong individuals are individuals that do not satisfy the pretest.
    % It finds the wrong individuals in the list of idx_bad_values indices of the
    % population.
    % Those individuals are then removed and replaced by new individuals generated
    % from the evolution of the last population.
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also clean, replace_individuals, find_wrong_individuals.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

%% Find the wrong individuals
    idx = find_wrong_individuals(pop,MLC_parameters,MLC_table,idx_bad_values); %logical

%% If there are wrong individuals remove/generate/replace
    fprintf('%i pretested individuals to be removed\n',length(idx))
  % If there is no wrong indivuals end the method.
    IND = pop.individuals;
    if not(length(idx))
        return
    end

%% Replace bad individuals with new individuals
    pop.replace_individuals(idx,MLC_parameters,MLC_table,pop_old);

%% Individuals
    IND = pop.individuals;

end
