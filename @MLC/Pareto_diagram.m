function Pareto_diagram(MLC,a_idx,b_idx)
    % PARETO_DIAGRAM Plots the pareto diagram between J_a and J_b.
    % By default, a=1 and b=1.
    %
    % Guy Y. Cornejo Maceda, 2023/09/022
    %
    % See also spectrogram, learning_process, cost_distribution

    % Copyright: 2022 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % The MIT License (MIT)


%% Parameters
    NGen = MLC.generation;
    PopSize = MLC.parameters.PopulationSize;
    NJcomponents = numel(MLC.table.individuals(1).cost(1,:))-1;
% --- Plot the mean (or ...) of the different evaluation of one individual
    EstimatePerformance = MLC.parameters.ProblemParameters.EstimatePerformance;
    if nargin < 3, b_idx=2; end
    if nargin < 2, a_idx=1; end
    BadValue = MLC.parameters.BadValue;

%% Load data

% --- All costs
  J = zeros(PopSize,NGen);
  J_creation_order = zeros(PopSize,NGen); % of creation
  J_components = zeros(NJcomponents,PopSize,NGen);
  ID_Indiv = zeros(PopSize,NGen);

  for p=1:NGen
      for q=1:PopSize
          ind = MLC.population(p).individuals(q);
          ID_Indiv(q,p) = ind;
          % --- Estimation type
          Jind = cell2mat(MLC.table.individuals(ind).cost(:,1));
          switch EstimatePerformance
              case 'mean'
                  J(q,p) = mean(Jind);
                  for k=1:NJcomponents
                      J_components(k,q,p) = mean(cell2mat(MLC.table.individuals(ind).cost(:,k+1)));
                  end
              case 'last'
                  J(q,p) = Jind(end);
                  for k=1:NJcomponents
                      J_components(k,q,p) = MLC.table.individuals(ind).cost{end,k+1};
                  end
              case 'worst'
                  J(q,p) = max(Jind);
                  for k=1:NJcomponents
                      J_components(k,q,p) = max(cell2mat(MLC.table.individuals(ind).cost(:,k+1)));
                  end
              case 'best'
                  J(q,p) = min(Jind);
                  for k=1:NJcomponents
                      J_components(k,q,p) = min(cell2mat(MLC.table.individuals(ind).cost(:,k+1)));
                  end
          end
      end
%       [~,JorderIDX] = sort(MLC.population(p).individuals);
      [~,J_creation_order(:,p)] = sort(MLC.population(p).CreationOrder);
  end
  
 % --- Select bad individuals
    isBad = J>(BadValue/10);

%% Pareto diagram
    cmp=jet(NGen);
    Ja = squeeze(J_components(a_idx,:,:));
    Jb = squeeze(J_components(b_idx,:,:));
    maxJa = max(Ja(not(isBad)));
    maxJb = max(Jb(not(isBad)));

figure('Position',[371,369,408.4,338.8])
    hold on
    for gen=1:NGen
        for q=1:PopSize
            if isBad(q,gen)
                plot(maxJb,maxJa,'r*','MarkerSize',20)
            else
                plot3(Jb(q,gen),Ja(q,gen),ID_Indiv(q,gen),'.','MarkerSize',20,'Color',cmp(gen,:))
            end
        end
    end
    hold off
    Ja_str = sprintf('$J_%s$',char(96+a_idx));
    Jb_str = sprintf('$J_%s$',char(96+b_idx));
    xlabel(Jb_str,'Interpreter','latex')
    ylabel(Ja_str,'Interpreter','latex')
    title('Pareto diagram','Interpreter','latex')
    
    % --- Colorbar
        colorbar
        if NGen==1
            caxis([1,NGen+1])
        else
            caxis([1,NGen])
        end
        colormap(cmp)
    
    % --- Axis
        minJa = min(min(Ja)); dJa = maxJa-minJa; %maxJa = max(max(Ja)); 
        minJb = min(min(Jb)); dJb = maxJb-minJb;maxJb = max(max(Jb)); 
        axis([minJb-0.1*dJb,maxJb+0.1*dJb,minJa-0.1*dJa,maxJa+0.1*dJa])

    % --- Pareto front
        Ja = reshape(Ja,[],1);
        Jb = reshape(Jb,[],1);
        
        Jaless = Ja > transpose(Ja);
        Jbless = Jb > transpose(Jb);
        Jfront = not(logical(sum(Jaless.*Jbless,2)));
    
    % --- Plot
        JaP = Ja(Jfront);
        JbP = Jb(Jfront);
        JP = sortrows([JaP,JbP],[1,2]);
        hold on
        plot(JP(:,2),JP(:,1),'k--','Linewidth',2)
        hold off
        box on
        grid on
        ax=axis;
        set(gca,'DataAspectRatio',[1/(ax(4)-ax(3)),1/(ax(2)-ax(1)),1])
        set(gca,'GridLineStyle','--')

