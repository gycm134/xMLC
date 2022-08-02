function spectrogram(MLC)
    % SPECTROGRAM Plots the distribution of the costs for each generation.
    %
    % Guy Y. Cornejo Maceda, 2022/07/01
    %
    % See also Pareto_diagram, learning_process, cost_distribution

    % Copyright: 2022 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % The MIT License (MIT)

%% Parameters
  NGen = MLC.generation;
  PopSize = MLC.parameters.PopulationSize;
  NJcomponents = numel(MLC.table.individuals(1).cost(1,:))-1;
  % Plot the mean (or ...) of the different evaluation of one individual
  EstimatePerformance = MLC.parameters.ProblemParameters.EstimatePerformance;
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

%% Plot spectrogram
figure('Position',[371,369,408.4,338.8])
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
    ax=axis;
    set(gca,'DataAspectRatio',[1/(ax(4)-ax(3)),1/(ax(2)-ax(1)),1])


