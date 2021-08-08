function best_individuals(MLC,GEN,Nbest)
    % BEST_INDIVIDUALS gives information about the best control laws.
    % Gives information of the Nbest best control law after GEN generations.
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also best_individual, give, chromosome. 

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

%% Arguments
    if nargin < 3
        Nbest=5;
    end

%% Parameters
    PopSize = MLC.parameters.PopulationSize;
    EstimatePerformance = MLC.parameters.ProblemParameters.EstimatePerformance;

%% Extract individuals
    Individuals = zeros(PopSize,GEN);
    for ind=1:PopSize
        for gen=1:GEN
            Individuals(ind,gen) = MLC.population(gen).individuals(ind);
        end
    end
    INDS = reshape(Individuals,[],1);
    [INDS,IDX_INDS] = unique(INDS);
    costs = zeros(length(INDS),1);
    
    % Compute cost of individual
    for q=1:length(INDS)
        switch EstimatePerformance
            case 'mean'
                costs(q) = mean(cell2mat(MLC.table.individuals(INDS(q)).cost(:,1)));
            case 'worst'
                costs(q) = max(cell2mat(MLC.table.individuals(INDS(q)).cost(:,1)));
            case 'last'
                all_J = cell2mat(MLC.table.individuals(INDS(q)).cost(:,1));
                costs(q) = all_J(end);
            case 'best'
                costs(q) = min(cell2mat(MLC.table.individuals(INDS(q)).cost(:,1)));
        end
    end
    [~,IDX] = sort(costs);

%% Print
    fprintf('Best individuals, their costs and control law:\n')
    for p=1:Nbest
        switch p
            case 1
                ord = 'st';
            case 2
                ord = 'nd';
            case 3
                ord = 'rd';
            otherwise
                ord = 'th';
        end
        fprintf(['%i-',ord,' individual:\n'],p)
        fprintf('   generation: %i\n',floor(IDX_INDS(IDX(p))/PopSize)+1)
        fprintf('   individual : %i\n',rem(IDX_INDS(IDX(p)),PopSize))
        fprintf('   index: %i\n',INDS(IDX(p)))
        fprintf('   cost: %f\n',costs(IDX(p)))
        fprintf('   control law:')
        fprintf('\n')
        for q=1:MLC.parameters.ProblemParameters.OutputNumber
            fprintf('      b%i = ',q)
            fprintf(MLC.table.individuals(INDS(IDX(p))).control_law{q})
            fprintf('\n')
        end
        fprintf('\n')
        fprintf('\n')
    end
