function [idx,already_exist,MLC_table] = add_indiv(MLC_table,MLC_parameters,indiv,pop_ind)
    % ADD_INDIV adds a new individual in the MLCtable.
    % It gives the index of the individual if it already exist in the table or
    % in the population pop_ind, otherwise it gives the number of elements in
    % table+1.
    % already_exist gives 1 if the string expression has already been explored
    % otherwise it gives 0
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also MLC, MLCpop, MLCind.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

%% Parameters
  CrossGenRemoval = MLC_parameters.CrossGenRemoval;

%% Does the individual already appeared
  if CrossGenRemoval
      pop_ind = MLC_table.non_redundant; % in the database ?
    else
      max_pop_ind = max(pop_ind);
      pop_ind = union(pop_ind,max_pop_ind:MLC_table.number); % in the last generation or current generation ?
  end

%% Look for redundant
  index_indiv = MLC_table.find_indiv(indiv); % same hash function = same matrix = same individual
  redundant = MLC_table.find_redundant(indiv);
      if not(redundant) && isempty(index_indiv) % if it's a new individual or if it is not already in the base (necessary for bad individuals)
        MLC_table.non_redundant = [MLC_table.non_redundant,MLC_table.number+1];
      end

  if isempty(index_indiv)
      indiv.ref = redundant;
      MLC_table.individuals(MLC_table.number+1)=indiv;
      MLC_table.number = MLC_table.number+1;
      MLC_table.hashlist(MLC_table.number) = indiv.hash;
      MLC_table.control_points(MLC_table.number,:) = indiv.control_points;
      MLC_table.costlist(MLC_table.number) = indiv.cost{1};
      idx = MLC_table.number;
  else
      idx = index_indiv;
      Indiv = MLC_table.individuals(idx);
      Indiv.occurences = Indiv.occurences+1;
      MLC_table.individuals(idx) = Indiv;
  end

%% Does this individual has appeared before ?
  if not(CrossGenRemoval) && not(ismember(redundant,pop_ind))
    already_exist = 0;
  else
    already_exist = redundant;
  end

end
