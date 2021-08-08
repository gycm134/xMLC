function Jout=best_individual(MLC,GEN,visu)
    % BEST_INDIVIDUAL gives information about the best control law.
    % Gives information of the best control law after GEN generations.
    % The visu option allows visualization of the control law if it is coded for
    % the problem.
    % It gives the expression of the control law, the number of instructions and
    % effective instructions, generation and visualization.
    % It gives the cost and the control law of the best evaluation.
    %
    % A control law can be evaluated several times with different costs in
    % the case of stochastic problems.
    % This method gives back the best evaluation among all the evaluations.
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also best_individuals, give, chromosome.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA
%% Parameters
% Not used here.
%     EstimatePerformance = MLC.parameters.ProblemParameters.EstimatePerformance;

%% Number of generation
    if nargin<2
      Ngen = MLC.generation;
    elseif GEN>length(MLC.population)
      Ngen = MLC.generation;
    else
      Ngen = GEN;
    end

%% Optimization
    if MLC.generation==0
        error('No generation yet')
    end
%% Best cost-gen
    BestCost = MLC.population(1).costs(1);
    BestGen = 1;
    for p=2:Ngen
      cost = MLC.population(p).costs(1);
      if cost < BestCost
          BestCost = cost;
          BestGen = p;
      end
    end

%% Best population/individual
    BestIndNumber = MLC.population(BestGen).individuals(1);
    BestInd = MLC.table.individuals(BestIndNumber);
    BestPop = MLC.population(BestGen);

%% Print
  if MLC.parameters.verbose
      fprintf('\n')
      fprintf('Best individual after %i/%i generations (ID:%i):\n',BestGen,Ngen(end),BestIndNumber)
      fprintf('   Its cost : %.4g\n',BestCost)
      fprintf('   Control law : %s \n',BestInd.control_law{:})
      fprintf('   Number of instructions (effective): %i (%i)\n',BestPop.chromosome_lengths(1,:));
  end

%% Ouput
    Jout = BestInd.cost;

%% Visualisation
    if (nargin<3 || visu ) && not(strcmp(MLC.parameters.EvaluationFunction,'external'))
    eval(['Plant=@' MLC.parameters.EvaluationFunction '_problem;']);

    % Control : Definition, replacement and limitation
        control_law = BestInd.control_law;
        control_law = strrep_cl(MLC.parameters,control_law,2);
        control_law = limit_to(control_law,MLC.parameters.ProblemParameters.ActuationLimit);

    % Evaluation
        Plant(control_law,MLC.parameters,1);
    end
