function complete_evaluation(MLC,Gen,matJ)
    % EXTERNAL_EVALUATION completes the evaluation of the individuals for external evaluations
    % Retrieves the cost information of each control law from GenXpopulation.mat (matJ),
    % X being the generation Gen.
    % For each problem, the path of the cost files should be changed.
    % There should be a file per control law.
    % Thus the file GenXIndY.dat contains two floats (Ja and Jb) corresponding
    % to the cost of individual in line Y in the GenXpopulation.mat and generation X.
    % GenXpopulation.mat: [Ja,Jb,...]
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also external_evaluation, External_evaluation_CONTINUE, External_evaluation_END.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

%% Parameters
    PopSize = MLC.parameters.PopulationSize;
    gamma = MLC.parameters.ProblemParameters.gamma;
    
%% Compute J
    JAll = [matJ(:,1)+sum(gamma.*matJ(:,2:end),2),matJ];

%% Table update
    % Allocation
    MeanCostIndiv = zeros(PopSize,1);
    WorstCostIndiv = zeros(PopSize,1);
    BestCostIndiv = zeros(PopSize,1);
    
    % Loop
    for p=1:PopSize
        idx = MLC.population(Gen).individuals(p);
        MLC_indiv = MLC.table.individuals(idx);
        % update
        if MLC_indiv.cost{1}<0, MLC_indiv.cost={};end
        MLC_indiv.cost = vertcat(MLC_indiv.cost,num2cell(JAll(p,:),[1,size(JAll,2)]));
        MeanCostIndiv(p) = mean(cell2mat(MLC_indiv.cost(:,1)));
        WorstCostIndiv(p) = max(cell2mat(MLC_indiv.cost(:,1)));
        BestCostIndiv(p) = min(cell2mat(MLC_indiv.cost(:,1)));
        MLC_indiv.evaluation_time = 30;
    end

%% Population.cost update
    switch MLC.parameters.ProblemParameters.EstimatePerformance
        case 'mean'     
            MLC.population(Gen).costs = MeanCostIndiv;
            MLC.table.costlist(MLC.population(Gen).individuals) = MeanCostIndiv;
        case 'last'
            MLC.population(Gen).costs = JAll(:,1);
            MLC.table.costlist(MLC.population(Gen).individuals) = JAll(:,1);
        case 'worst'
            MLC.population(Gen).costs = MeanCostIndiv;
            MLC.table.costlist(MLC.population(Gen).individuals) = WorstCostIndiv;
        case 'best'
            MLC.population(Gen).costs = MeanCostIndiv;
            MLC.table.costlist(MLC.population(Gen).individuals) = BestCostIndiv;
    end

%% Remove bad_individuals and evaluate
    if MLC.parameters.RemoveBadIndividuals
        MLC.population(Gen).remove_bad_individuals(MLC.parameters,MLC.table,MLC.population(max(1,Gen-1)));
    end

%% Sorting
    MLC.population(Gen).sort_pop;

%% Rank of individuals
    MLC.population(Gen).evaluation = 'evaluated';
    MLC.generation = MLC.generation+1;

fprintf('Completion done!\n')
fprintf('Ready to evolve!\n')

end
