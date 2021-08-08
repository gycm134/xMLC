function new_pop = crossover(new_pop,pop,MLC_parameters,MLC_table,N_indivs,f2)
    % CROSSOVER operates one crossover from pop to new_pop
    % The argument N_indivs helps to keep track of the number of individuals to add.
    % f2 indicates if one or two control laws needs to be added.
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also Elitism, mutate, evolve_pop.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

%% Argument
  if nargin<6, f2=false; end

%% Initialization
PopIndivs = pop.individuals;
cmpt = 0;
Nmax = MLC_parameters.MaxIterations;
rmdd = 1;

%% While loop to generate new individuals
  while rmdd && cmpt<Nmax
      % rmdd definition
      rmdd = MLC_parameters.RemoveRedundants;

      % crossover
      idx1 = selection_individual(MLC_parameters);
      idx2 = selection_individual(MLC_parameters);
      idx_1 = pop.individuals(idx1);
      idx_2 = pop.individuals(idx2);
      ind1 = MLC_table.individuals(idx_1);
      ind2 = MLC_table.individuals(idx_2);
      [cindiv1,cindiv2,point_parts] = crossover(ind1,ind2,MLC_parameters);

      % Table update - already exist in the population pop?
      [idx_n1,already_exist1] = MLC_table.add_indiv(MLC_parameters,cindiv1,PopIndivs);
      if f2 || already_exist1
        [idx_n2,already_exist2] = MLC_table.add_indiv(MLC_parameters,cindiv2,PopIndivs);
      end

      % Have both of the offsprings already been evaluated
      if f2 || already_exist1
        already_exist = already_exist1 && already_exist2;
      else
        already_exist = already_exist1;
      end

      % rmdd update
      rmdd=rmdd && already_exist;

      % cmpt update
      cmpt = cmpt + logical(rmdd);
  end

%% Swap individuals in the case the first one already exist
  if already_exist1
      [idx_n1,idx_n2]=swap(idx_n1,idx_n2);
      [cindiv1,cindiv2]=swap(cindiv1,cindiv2);
      [point_parts{1},point_parts{2}] = swap(point_parts{1},point_parts{2});
      [already_exist1,already_exist2] = swap(already_exist1,already_exist2);
  end

% If no remove redundants, no need to exclude individuals that already exists
  if not(MLC_parameters.RemoveRedundants)
      already_exist1 = 0;
      already_exist2 = 0;
  end

%% Population update
    if already_exist1
%       new_pop.costs(N_indivs+1) = MLC_table.individuals(already_exist1).cost{1};
      new_pop.costs(N_indivs+1) = MLC_table.individuals(idx_n1).cost{1};
    else
      new_pop.costs(N_indivs+1) = -1;
    end
      new_pop.individuals(N_indivs+1) = idx_n1;
      new_pop.chromosome_lengths(N_indivs+1,:) = cindiv1.chromosome_lengths;
      new_pop.parents(N_indivs+1,:) = [idx_1 idx_2];
      new_pop.operation{N_indivs+1}.type = 'crossover';
      new_pop.operation{N_indivs+1}.points_parts = point_parts{1};

    if f2 && not(already_exist2)
    new_pop.individuals(N_indivs+2) = idx_n2;
    new_pop.costs(N_indivs+2) = -1;
    new_pop.chromosome_lengths(N_indivs+2,:) = cindiv2.chromosome_lengths;
    new_pop.parents(N_indivs+2,:) = [idx_1 idx_2];
    new_pop.operation{N_indivs+2}.type = 'crossover';
    new_pop.operation{N_indivs+2}.points_parts = point_parts{2};

    end
end

function [b,a]=swap(a,b)
end
