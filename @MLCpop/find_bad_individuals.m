function idx=find_bad_individuals(pop,MLC_parameters)
    % FIND_BAD_INDIVIDUALS gives the indices of bad individuals.
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also replace_individuals, clean, remove_bad_individuals.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

idx = find(pop.costs >= MLC_parameters.BadValue);
end
