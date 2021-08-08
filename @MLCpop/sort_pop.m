function pop = sort_pop(pop)
    % SORT_POP sorts population
    % We sort the individuals following their cost.
    % For two individuals with the same cost, we sort following the number of
    % instructions.
    % To be updated..
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also Elitism, mutate, evolve_pop.

% Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
% CC-BY-SA

%% Sorting
  sorting_table = horzcat(pop.costs,pop.chromosome_lengths);
  [~,indices_costs] = sortrows(sorting_table,[1,2,3]);

%% Updating
  pop.individuals = pop.individuals(indices_costs);
  pop.costs = pop.costs(indices_costs);
  pop.chromosome_lengths = pop.chromosome_lengths(indices_costs,:);
  pop.parents = pop.parents(indices_costs,:);
  pop.operation = pop.operation(indices_costs);
  pop.CreationOrder = pop.CreationOrder(indices_costs);

end
