function [x,y] = convergence(MLC,Pareto,plt)
    % CONVERGENCE Plots convergence plots for MLC 
    % Shows the evolution of the cost over the generations and the 
    % distribution of the costs for each generation.
    % Gives in return the x and y coordinates of the learning process
    % figure.
    % Each individual is plotted following its estimated performance (mean,
    % last, worst or best).
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also spectrogram, convergence

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA


%% Parameters
  NGen = MLC.generation;
  PopSize = MLC.parameters.PopulationSize;
  gamma = MLC.parameters.ProblemParameters.gamma; NJcomponents = numel(gamma)+1;
  % Plot the mean (or ...) of the different evaluation of one individual
      EstimatePerformance = MLC.parameters.ProblemParameters.EstimatePerformance;
%   HowToPlot = 1; %1: mean, 2:worst
  if nargin < 2, Pareto=0; end
  if nargin < 3, plt = 1; end
  BadValue = MLC.parameters.BadValue;

%% improve plot

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
  figure
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
  title('J distribution and evolution','Interpreter','latex')
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
  figure
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
  title('Learning process','Interpreter','latex')
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
end
%% Pareto front
if (plt && Pareto) || (NJcomponents==2)
figure
cmp=jet(NGen);
    Ja = reshape(Jcomponents(1,:,:),PopSize,NGen);
    Jb = reshape(Jcomponents(2,:,:),PopSize,NGen);
    maxJa = max(Ja(not(isBad)));
    maxJb = max(Jb(not(isBad)));
    hold on
    for gen=1:NGen
        for q=1:PopSize
            if isBad(q,gen)
                plot(maxJb,maxJa,'r*','MarkerSize',20)
            else
                plot(Jb(q,gen),Ja(q,gen),'.','MarkerSize',20,'Color',cmp(gen,:))
            end
        end
    end
    hold off
    xlabel('$J_b$','Interpreter','latex')
    ylabel('$J_a$','Interpreter','latex')
    title('Pareto front')
    
    % colorbar
    colorbar
    if NGen==1
        caxis([1,NGen+1])
    else
        caxis([1,NGen])
    end
    colormap(cmp)
    
    % axis
    minJa = min(min(Ja)); dJa = maxJa-minJa; %maxJa = max(max(Ja)); 
    minJb = min(min(Jb)); dJb = maxJb-minJb;maxJb = max(max(Jb)); 
    axis([minJb-0.1*dJb,maxJb+0.1*dJb,minJa-0.1*dJa,maxJa+0.1*dJa])

    
% Pareto front
Ja = reshape(Ja,[],1);
Jb = reshape(Jb,[],1);

Jaless = Ja > transpose(Ja);
Jbless = Jb > transpose(Jb);
Jfront = not(logical(sum(Jaless.*Jbless,2)));

% plot
JaP = Ja(Jfront);
JbP = Jb(Jfront);
JP = sortrows([JaP,JbP],[1,2]);
hold on
plot(JP(:,2),JP(:,1),'k--','Linewidth',2)
hold off
box on
grid on
end

%% J components
MS=50;
cmp = jet(NGen);
if plt 
figure,
subplot(NJcomponents+1,1,1)
    hold on
    % Plot per generation
    for gen=1:NGen
        PopIdx = PopSize*(gen-1)+(1:PopSize);
        PopGood = PopIdx(isNotBad(:,gen));
        PopBad = PopIdx(isBad(:,gen));
        JGood = J(isNotBad(:,gen),gen); 
%         Jbad = J(isBad(:,gen),gen); % not used
        % Scatter
            scatter(PopBad,maxJ+0*PopBad,MS,'r*')
            scatter(PopGood,JGood,MS,'o','MarkerFaceColor',cmp(gen,:),'MarkerEdgeColor','none')
%         for q=1:PopSize
%             if isBad(q,gen)
%                 scatter(PopSize*(gen-1)+(q),maxJ,MS,'r*')
%             else
%                 scatter(PopSize*(gen-1)+(q),J(q,gen),MS,'o','MarkerFaceColor',cmp(gen,:),'MarkerEdgeColor','none')
%             end
%         end
    end
    
    hold off
    % labels and ticks
    set(gca,'xtick',0:PopSize:(NGen*PopSize))
    set(gca,'XTickLabel',[]);
    ylabel('$J$','Interpreter','latex')
    grid on
    box on
    if min(min(J))>0
        set(gca,'Yscale','log')
    end
    
for NJC=1:NJcomponents
    subplot(NJcomponents+1,1,NJC+1)
    JC = reshape(Jcomponents(NJC,:,:),PopSize,NGen);
    maxJC = max(JC(not(isBad)));
    hold on
    for gen=1:NGen
        PopIdx = PopSize*(gen-1)+(1:PopSize);
        PopGood = PopIdx(isNotBad(:,gen));
        PopBad = PopIdx(isBad(:,gen));
        JGood = JC(isNotBad(:,gen),gen); 
%         Jbad = JC(isBad(:,gen),gen); % not used
        % Scatter
            scatter(PopBad,maxJC+0*PopBad,MS,'r*')
            scatter(PopGood,JGood,MS,'o','MarkerFaceColor',cmp(gen,:),'MarkerEdgeColor','none')
%         for q=1:PopSize
%             if isBad(q,gen)
%                 scatter(PopSize*(gen-1)+(q),maxJC,MS,'r*')
%             else
%                 scatter(PopSize*(gen-1)+(q),JC(q,gen),MS,'o','MarkerFaceColor',cmp(gen,:),'MarkerEdgeColor','none')
%             end
%         end
    end
    hold off
    % labels and ticks
    set(gca,'xtick',0:PopSize:(NGen*PopSize))
    set(gca,'XTickLabel',[]);
    ylabel(['$J_',char(96+NJC),'$'],'Interpreter','latex')
    grid on
    box on
    if min(min(JC))>0
        set(gca,'Yscale','log')
    end
end
end

%% Plot distribution
% % % if plt 
  figure
  Jdistrib=J;
  Jdistrib(isBad)=maxJ;
  imagesc(log(Jdistrib));
  %title
    title(['J distribution (log10)'],'Interpreter','latex')
  %legends
    xlabel('Generation','Interpreter','latex')
    ylabel('Individual','Interpreter','latex')
  %yaxis
    set(gca,'YDir','normal')
  % colors
    cmap = gray(1024);
  % colormap
    colormap(flip(cmap))
    colorbar
% % % end


