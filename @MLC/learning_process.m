function [x,y] = learning_process(MLC,plt)
    % LEARNING_PROCESS Plots the learning process so far.
    % Shows the evolution of the cost over the generations and the 
    % distribution of the costs for each generation.
    % Gives in return the x and y coordinates of the learning process
    % figure.
    % Each individual is plotted following its estimated performance (mean,
    % last, worst or best).
    %
    % Guy Y. Cornejo Maceda, 2022/07/01
    %
    % See also spectrogram, Pareto_diagram, cost_distribution

    % Copyright: 2022 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % The MIT License (MIT)


%% Parameters
  NGen = MLC.generation;
  PopSize = MLC.parameters.PopulationSize;
  NJcomponents = numel(MLC.table.individuals(1).cost(1,:))-1;
  % Plot the mean (or ...) of the different evaluation of one individual
      EstimatePerformance = MLC.parameters.ProblemParameters.EstimatePerformance;
%   HowToPlot = 1; %1: mean, 2:worst
  if nargin < 2, plt = 1; end
  BadValue = MLC.parameters.BadValue;

%% Load data

% All costs
  J = zeros(PopSize,NGen);
  Jorder = zeros(PopSize,NGen); % of creation
  IndivType = zeros(PopSize,NGen);
  Jcomponents = zeros(NJcomponents,PopSize,NGen);

  for p=1:NGen
      for q=1:PopSize
          ind = MLC.population(p).individuals(q);
          % Estimation type
          Jind = cell2mat(MLC.table.individuals(ind).cost(:,1));
          switch EstimatePerformance
              case 'mean'
                  J(q,p) = mean(Jind);
                  for k=1:NJcomponents
                      Jcomponents(k,q,p) = mean(cell2mat(MLC.table.individuals(ind).cost(:,k+1)));
                  end
              case 'last'
                  J(q,p) = Jind(end);
                  for k=1:NJcomponents
                      Jcomponents(k,q,p) = MLC.table.individuals(ind).cost{end,k+1};
                  end
              case 'worst'
                  J(q,p) = max(Jind);
                  for k=1:NJcomponents
                      Jcomponents(k,q,p) = max(cell2mat(MLC.table.individuals(ind).cost(:,k+1)));
                  end
              case 'best'
                  J(q,p) = min(Jind);
                  for k=1:NJcomponents
                      Jcomponents(k,q,p) = min(cell2mat(MLC.table.individuals(ind).cost(:,k+1)));
                  end
          end
          % Operation         
          IT = MLC.population(p).operation{q}.type;
          switch IT
              case 'random'
                  IndivType(q,p) = 0;
              case 'Elitism'
                  IndivType(q,p) = 1;
              case 'crossover'
                  IndivType(q,p) = 2;
              case 'mutation'
                  IndivType(q,p) = 3;
              case 'replication'
                  IndivType(q,p) = 4;
          end
      end
%       [~,JorderIDX] = sort(MLC.population(p).individuals);
      [~,Jorder(:,p)] = sort(MLC.population(p).CreationOrder);
  end
  
 % Select bad individuals
    isBad = J>(BadValue/10);
    isNotBad = J<(BadValue/10);
 % Max J
    maxJ = max(J(not(isBad)));
    
%% Learning curve
LearningC = J(1,:);
LearningC = reshape([LearningC;LearningC],1,[]);
% Median curve
MedianC = J(ceil(PopSize/2),:);
MedianC = reshape([MedianC;MedianC],1,[]);
% Indices
IdxLearningC = [reshape([0:(NGen-1);1:(NGen)],1,[]),NGen];
IdxLearningC(end) = [];

% Colors
Col = [1,1,0; % Elitism
    0,0,1; % crossover
    0,0,0; % mutation
    0.75,0,0.75];% replication
if plt 
% Learning process
  figure('Position',[371,369,402,420])
  hold on
  % cost
  plot(IdxLearningC,LearningC,'r-','Linewidth',2)
  plot(IdxLearningC,MedianC,'g--','Linewidth',2)
  % Monte Carlo
  for q=1:PopSize
      if isBad(q,1)
              plot((1/PopSize)*q,maxJ,'r*')
          else
              plot((1/PopSize)*q,J(q,1),'bo')
      end
  end
  % Evolution
  for p=2:NGen
      for q=1:PopSize
          if isBad(q,p)
              plot(p+(1/PopSize)*q-1,maxJ,'r*')
          else
              plot(p+(1/PopSize)*q-1,J(q,p),'Marker','o','LineStyle','none','MarkerFaceColor',Col(IndivType(q,p),:),'MarkerEdgeColor','none')
          end
      end
  end
  axis([0 NGen 0.9*min(J(:)) maxJ+1e-3])
  hold off
  % labels
  xlabel('Generation','Interpreter','latex')
  ylabel('$J$','Interpreter','latex')
  % title
  title('Learning process','Interpreter','latex')
  grid on
  box on
    % legend
      hold on
      leg(1)=plot(nan,nan,'bo');
      ca{1}='Monte Carlo';
      leg(2)=plot(nan,nan,'Marker','o','LineStyle','none','MarkerFaceColor',Col(1,:),'MarkerEdgeColor','none');
      ca{2}='Elitism';
      leg(3)=plot(nan,nan,'Marker','o','LineStyle','none','MarkerFaceColor',Col(2,:),'MarkerEdgeColor','none');
      ca{3}='Crossover';
      leg(4)=plot(nan,nan,'Marker','o','LineStyle','none','MarkerFaceColor',Col(3,:),'MarkerEdgeColor','none');
      ca{4}='Mutation';
      leg(5)=plot(nan,nan,'Marker','o','LineStyle','none','MarkerFaceColor',Col(4,:),'MarkerEdgeColor','none');
      ca{5}='Replication';
      leg(6)=plot(nan,nan,'r-','LineWidth',2);
      ca{6}='Best J';
      leg(7)=plot(nan,nan,'g--','LineWidth',2);
      ca{7}='Median J';
      leg(8)=plot(nan,nan,'r*','LineWidth',2);
      ca{8}='Bad';
      legend(leg,ca,'Location','southwest')
      hold off

  %
  set(gca,'Yscale','log')
  set(gca,'xtick',0:NGen)
  set(gca,'XTickLabelRotation',45)
  ax=axis;
  set(gca,'DataAspectRatio',[1/(ax(4)-ax(3)),1/(ax(2)-ax(1)),1])
  set(gca,'GridLineStyle','--')
end
%% J evaluation order
    % Sort following evaluation order
    JEvalOrder = NaN(PopSize,NGen);
    for gen=1:NGen
        JEvalOrder(:,gen) = J(Jorder(:,gen),gen);
    end
    JEvalOrder = reshape(JEvalOrder,[],1);
    
    best_ind = []; %length(labels);
    best_cost = []; %min(Costs);
    eval_num = PopSize*NGen;
    while eval_num>1
        [cmin,eval_num] = min(JEvalOrder(1:eval_num-1));
        best_ind = [best_ind,eval_num];
        best_cost = [best_cost,cmin];
    end
% Data
    x = sort([best_ind,best_ind(1:end-1),PopSize*NGen]);
    y = sort([best_cost,best_cost(1:end-1),best_cost(end)],'descend');

if plt    
  % Plot
  figure('Position',[371,369,402,420])
  hold on
  % Learning curve
  plot(x,y,'r-','Linewidth',2)
  % Monte Carlo
  for q=1:PopSize
      if isBad(Jorder(q,1),1)
          plot(q,maxJ,'r*')
      else
          plot(q,J(Jorder(q,1),1),'bo')
      end
  end
      
  % Evolution
  for p=2:NGen
      for q=1:PopSize
          if isBad(Jorder(q,p),p)
              plot((p-1)*PopSize+q,maxJ,'r*')
          else
              plot((p-1)*PopSize+q,J(Jorder(q,p),p),'Marker','o','LineStyle','none','MarkerFaceColor',Col(IndivType(Jorder(q,p),p),:),'MarkerEdgeColor','none')
          end
      end
  end
  axis([1 PopSize*NGen 0.9*min(J(:)) maxJ+1e-3])
  hold off
  % labels
  xlabel('Evaluation','Interpreter','latex')
  ylabel('$J$','Interpreter','latex')
  % title
  title('Learning process (evaluation order)','Interpreter','latex')
  grid on
  box on
    % legend
      clear leg
      clear ca
      hold on
      leg(1)=plot(nan,nan,'bo');
      ca{1}='Monte Carlo';
      leg(2)=plot(nan,nan,'Marker','o','LineStyle','none','MarkerFaceColor',Col(1,:),'MarkerEdgeColor','none');
      ca{2}='Elitism';
      leg(3)=plot(nan,nan,'Marker','o','LineStyle','none','MarkerFaceColor',Col(2,:),'MarkerEdgeColor','none');
      ca{3}='Crossover';
      leg(4)=plot(nan,nan,'Marker','o','LineStyle','none','MarkerFaceColor',Col(3,:),'MarkerEdgeColor','none');
      ca{4}='Mutation';
      leg(5)=plot(nan,nan,'Marker','o','LineStyle','none','MarkerFaceColor',Col(4,:),'MarkerEdgeColor','none');
      ca{5}='Replication';
      leg(6)=plot(nan,nan,'r-','LineWidth',2);
      ca{6}='Best J';
      leg(6)=plot(nan,nan,'r*','LineWidth',2);
      ca{6}='Bad';
      legend(leg,ca,'Location','southwest')
      hold off

  %
  set(gca,'Yscale','log')
  set(gca,'xtick',1:PopSize:(PopSize*NGen))
  set(gca,'XTickLabelRotation',45)
  ax=axis;
  set(gca,'DataAspectRatio',[1/(ax(4)-ax(3)),1/(ax(2)-ax(1)),1])
  set(gca,'GridLineStyle','--')
end


