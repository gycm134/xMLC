function new_pop = replication(new_pop,pop,MLC_parameters,MLC_table,N_indivs)
    % REPLICATION operates one replication from pop to new_pop
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also Elitism, mutate, evolve_pop.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

%% Selects the individual
    idx1 = selection_individual(MLC_parameters);
    idx = pop.individuals(idx1);
%% Population update
    new_pop.individuals(N_indivs+1) = idx;
    new_pop.costs(N_indivs+1) = pop.costs(idx1);
    new_pop.chromosome_lengths(N_indivs+1,:) = pop.chromosome_lengths(idx1,:);
    new_pop.parents(N_indivs+1,:) = [idx,0];
    new_pop.operation{N_indivs+1}.type = 'replication';
%% Table update
    Indiv = MLC_table.individuals(idx);
    Indiv.occurences = Indiv.occurences+1;
    MLC_table.individuals(idx) = Indiv;
end
