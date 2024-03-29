function rep_indiv = replication(indiv)
    % REPLICATION copy/paste one individual
    % Old method. Not used.
    %
    % Guy Y. Cornejo Maceda, 2022/07/01
    %
    % See also crossover, mutate.

    % Copyright: 2022 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % The MIT License (MIT)

rep_indiv = indiv;
rep_indiv.parents = indiv.Rank;
rep_indiv.operation = [];
rep_indiv.operation.type = 'replication';
rep_indiv.Rank = 0;
rep_indiv.copy = indiv.Rank;
end
