function [N_indivs,new_pop] = elitism(new_pop,pop,MLC_parameters,MLC_table)
    % ELITISM Elitism operation
    % Saves individuals from last population to the population
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also crossover, mutate, evolve_pop.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

%% Parameters
  N_Elitism = MLC_parameters.Elitism;

%% Saving
  new_pop.individuals(1:N_Elitism) = pop.individuals(1:N_Elitism);
  new_pop.costs(1:N_Elitism) = pop.costs(1:N_Elitism);
  new_pop.chromosome_lengths(1:N_Elitism,:) = pop.chromosome_lengths(1:N_Elitism,:);

%% Update table and population
  for p=1:N_Elitism
      idx = pop.individuals(p);
      Indiv = MLC_table.individuals(idx);
      Indiv.occurences = Indiv.occurences+1;
      MLC_table.individuals(idx) = Indiv;
      new_pop.operation{p}.type = 'Elitism';
      new_pop.parents(p,1) = idx;

  end

%% Number of new individuals
  N_indivs=N_Elitism;

end
