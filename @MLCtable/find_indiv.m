function IndexIndiv = find_indiv(MLC_table,indiv)
    % FIND_INDIV finds indices of indiv
    % Checks if the individual already exists.
    %
    %
    % See also MLC, MLCpop, MLCind.

    % Copyright (C) 2015-2019 Thomas Duriez.
    % This file is adapted from @MLCtable/find_individual.m of the OpenMLC-Matlab-2 Toolbox. Distributed under GPL v3.

%% Initialization
  IndexIndiv = [];


%% Compare the matrices and take the first one
chr_indiv = indiv.chromosome;
idx = [];
MLC_individuals = MLC_table.individuals(1:MLC_table.number);
for p=1:MLC_table.number
    chr_indiv_table = MLC_individuals(p).chromosome;
    if compare_chromosomes(chr_indiv_table,chr_indiv)
        idx = [idx,p];
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
