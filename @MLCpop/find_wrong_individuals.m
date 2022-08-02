function idx = find_wrong_individuals(pop,MLC_parameters,MLC_table,idx_bad_indivs)
    % FIND_WRONG_INDIVIDUALS find individuals that don't fit the test.
    %
    % Guy Y. Cornejo Maceda, 2022/07/01
    %
    % See also clean, replace_individuals.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % The MIT License (MIT)

%% Bad individuals
  bad_indivs = pop.individuals(idx_bad_indivs);

%% find individuals close to a solution (PINBALL)
  find_wi = zeros(length(bad_indivs));
  for p=1:length(bad_indivs)
      ind = MLC_table.individuals(bad_indivs(p));
      disp('Put here your pretesting script.')
      disp('This feature will be elaborated in future versions.')
      error('The test needs to be completed by the use.')
  end

%% Output
idx = idx_bad_indivs(logical(find_wi));

end
