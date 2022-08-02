function IndexIndiv = find_indiv(MLC_table,indiv)
    % FIND_INDIV finds indices of indiv
    % Checks if the individual already exists.
    %
    % Guy Y. Cornejo Maceda, 2022/07/01
    %
    % See also MLC, MLCpop, MLCind.

    % Copyright: 2022 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % The MIT License (MIT)

%% Initialization
  IndexIndiv = [];


%% Compare the matrices and take the first one
chr_indiv = indiv.chromosome;
cmpt = 1;
idx = [];
MLC_individuals = MLC_table.individuals(1:MLC_table.number);
for p=1:MLC_table.number
    chr_indiv_table = MLC_individuals(p).chromosome;
    if compare_chromosomes(chr_indiv_table,chr_indiv)
        idx(cmpt) = [idx,p];
        cmpt = cmpt+1;
    end
end

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
