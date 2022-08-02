function IndexIndiv = find_indiv(MLC_table,indiv)
    % FIND_INDIV finds indices of indiv
    % Checks if the individual already exists.
    %
    % Guy Y. Cornejo Maceda, 2022/07/01
    %
    % See also MLC, MLCpop, MLCind.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % The MIT License (MIT)

%% Initialization
  IndexIndiv = [];

%% Find
  idx = find(MLC_table.hashlist==indiv.hash);

%% Get the first individual
if ~isempty(idx)
    for p=1:length(idx)
        if logical(prod(strcmp(MLC_table.individuals(idx(p)).control_law,indiv.control_law)))
            IndexIndiv = idx(p);
            break
        end
    end
end

end
