function new_pop = mutate(new_pop,pop,MLC_parameters,MLC_table,N_indivs)
    % MUTATE operates one mutation from pop to new_pop
    % The argument N_indivs helps to keep track of the number of individuals to add.
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also Elitism, mutate, evolve_pop.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

%% Initialization
  pop_ind = pop.individuals;
  cmpt = 0;
  Nmax = MLC_parameters.MaxIterations;
  rmdd = 1;

%% While loop to generate new individuals
while rmdd && cmpt<Nmax
    % rmdd definition
    rmdd = MLC_parameters.RemoveRedundants;

    % mutation
    idx1 = selection_individual(MLC_parameters);
    idx = pop.individuals(idx1);
    [mindiv,mutated_instr] = MLC_table.individuals(idx).mutate(MLC_parameters);

    % Table update
    [idxm,already_exist] = MLC_table.add_indiv(MLC_parameters,mindiv,pop_ind);

    % rmdd update
    rmdd=rmdd && already_exist;

    % cmpt update
    cmpt = cmpt + logical(rmdd);

end

%% Population update
    if already_exist
      new_pop.costs(N_indivs+1) = MLC_table.individuals(already_exist).cost{1};
    else
      new_pop.costs(N_indivs+1) = -1;
    end
    new_pop.individuals(N_indivs+1) = idxm;
    new_pop.costs(N_indivs+1) = -1;
    new_pop.chromosome_lengths(N_indivs+1,:) = mindiv.chromosome_lengths;
    new_pop.parents(N_indivs+1,:) = [idx 0];
    new_pop.operation{N_indivs+1}.type = 'mutation';
    new_pop.operation{N_indivs+1}.instructions = mutated_instr;

end
