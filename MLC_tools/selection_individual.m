function idx = selection_individual(MLC_parameters)
    % SELECTION_INDIVIDUAL selects an individual in the generation
    % following the tournament selection method.
    % The functions selects N_Tour (tournament size) individuals and gives the best
    % one of them with probability p_tour. If the condition is not reached then
    % the second is selected with probability p_tour and so on.
    % This function is called only by EVOLVE_POPULATION.
    % The individuals selected for the tournament can be the same, there is a
    % replacement.
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also read, mat2lisp, simplify_my_LISP.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

%% Parameters
  PopSize = MLC_parameters.PopulationSize;
  p_tour = MLC_parameters.p_tour;
  tournament_size = MLC_parameters.TournamentSize;

%% Tournament size definition
  if tournament_size>PopSize
    tournament_size = PopSize;
  end

%% Initialization
  selected = zeros(1,tournament_size);

  for p=1:tournament_size
    n = ceil(rand*PopSize);
    selected(p) = n;
  end

% Sorting
  selected = sort(selected,'ascend');

%Selection following the tournament parameter p_tour
  r=rand;
  while (r>p_tour && length(selected) > 1)
    selected(1) = [];
    r=rand;
  end
  idx = selected(1);

end
