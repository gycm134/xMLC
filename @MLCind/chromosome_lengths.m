function le = chromosome_lengths(indiv)
    % CHROMOSOME_LENGTHS computes the length of the chromosome and EI chromosome.
    % Gives a vector of two components, the length of the chromosomes and the
    % length of the effective matrix.
    %
    % Guy Y. Cornejo Maceda, 2022/07/01
    %
    % See also best_individual, best_individuals

    % Copyright: 2022 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % The MIT License (MIT)

%% Gives back the lengths of chromosome and EIchromosome
    s1 = size(indiv.chromosome,1);
    s2 = size(indiv.EI.chromosome,1);
    le=[s1,s2];
end
