function idx = find_bad_preeval_individuals(pop,MLC_table,idx_bad_indivs)
    % FIND_BAD_PREEVAL_INDIVIDUALS find individuals whos pre-evaluation
    % gave NAN or INF values.
    %
    % Guy Y. Cornejo Maceda, 02/15/2021
    %
    % See also clean, replace_individuals.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

%% Bad individuals
  bad_indivs = pop.individuals(idx_bad_indivs);

%% find individuals close to a solution (PINBALL)
  find_wi = zeros(length(bad_indivs));
  for p=1:length(bad_indivs)
      ind=MLC_table.individuals(bad_indivs(p));
      
        % Test the pre-evaluation
      NAN = logical(sum(isnan(ind.control_points)));
      INF = logical(sum(isinf(ind.control_points)));
      if NAN||INF
          find_wi(p)=1;
      end

  end

%% Output
idx = idx_bad_indivs(logical(find_wi));

end
