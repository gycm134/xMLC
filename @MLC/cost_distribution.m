function cost_distribution(MLC)
    % COST_DISTRIBUTION Plots the distribution of all the components of the
    % cost function along the generations.
    % The costs are sorted following J.
    %
    % Guy Y. Cornejo Maceda, 2022/07/01
    %
    % See also spectrogram, learning_process, Pareto_diagram

    % Copyright: 2022 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % The MIT License (MIT)


%% Parameters
  NGen = MLC.generation;
  PopSize = MLC.parameters.PopulationSize;
  NJcomponents = numel(MLC.table.individuals(1).cost(1,:))-1;
  % Plot the mean (or ...) of the different evaluation of one individual
  EstimatePerformance = MLC.parameters.ProblemParameters.EstimatePerformance;
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
    
%% J components
MS=50;
cmp = jet(NGen);
figure('Position',[371,369,408.4,338.8])
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
    set(gca,'GridLineStyle','--')
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
    set(gca,'GridLineStyle','--')
    box on
    if min(min(JC))>0
        set(gca,'Yscale','log')
    end
end
    for gen=1:NGen
        text(100*(gen-1)+50,0,sprintf('%i',gen),'VerticalAlignment','top',...
            'HorizontalAlignment','center')
    end
    xlabel('Generation')

