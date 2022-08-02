function idx=find_bad_individuals(pop,MLC_parameters)
    % FIND_BAD_INDIVIDUALS gives the indices of bad individuals.
    %
    % Guy Y. Cornejo Maceda, 2022/07/01
    %
    % See also replace_individuals, clean, remove_bad_individuals.

    % Copyright: 2022 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % The MIT License (MIT)

idx = find(pop.costs >= MLC_parameters.BadValue);
end
