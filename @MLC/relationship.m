function IndivID=relationship(MLC)
    % relationship computes the relationship matrix
    % Columns : parents
    % Lines : offsprings
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also indivhistory

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

%% Parameters
    NGen = MLC.generation;
    PopSize = MLC.parameters.PopulationSize;
    
%% Initialization
    NIndivs = NGen * PopSize;
    RMat = zeros(NIndivs,NIndivs);
    IndivID = zeros(NGen,PopSize);
    
%% Loop to retrieve data
    % First generation is generated randomly
    RMat(1:PopSize,:) = -1;
    for q=1:PopSize
        IndivID(1,q) = MLC.population(1).individuals(q);
    end
    
    % Second and more
    for p=2:NGen
        IndivID_minusone = IndivID(p-1,:);
        for q=1:PopSize
            IndivID(p,q) = MLC.population(p).individuals(q);
            switch MLC.population(p).operation{q}.type
                case 'random' % -1
                    RMat(q+(p-1)*PopSize,:) = -1;
                case 'Elitism' % 1
                    parent = MLC.population(p).parents(q,1);
                    IDX = find(parent==IndivID_minusone);
                    RMat(q+(p-1)*PopSize,IDX+(p-2)*PopSize) = 1;
                case 'crossover' % 2
                    parents = MLC.population(p).parents(q,:);
                    IDX1 = find(parents(1)==IndivID_minusone);
                    IDX2 = find(parents(2)==IndivID_minusone);
                    RMat(q+(p-1)*PopSize,[IDX1,IDX2]+(p-2)*PopSize) = 2;
                case 'mutation' % 3
                    parent = MLC.population(p).parents(q,1);
                    IDX = find(parent==IndivID_minusone);
                    RMat(q+(p-1)*PopSize,IDX+(p-2)*PopSize) = 3;
                case 'replication' % 4
                    parent = MLC.population(p).parents(q,1);
                    IDX = find(parent==IndivID_minusone);
                    RMat(q+(p-1)*PopSize,IDX+(p-2)*PopSize) = 4;
                otherwise
                    error('Wrong operation')
            end
        end
    end
  

%% Colormap
    cmp = [0,0,1;... % Random
        1,1,1;...    % empty
        1,1,0;...    % Elitism
        1,0,0;...    % Crossover
        0,1,0;...    % Mutation
        0,0,0];      % Replication
    
%% Plot all offsprings / all parents
figure,
set(gcf,'Position',[500,0,500,500])
imagesc(-0.5+[1,NIndivs],-0.5+[1,NIndivs],transpose(RMat))
set(gca,'YDir','normal')
    % colormap
    colormap(cmp)
    grid on
    ax = gca;
    % x
    ax.XAxis.MinorTick = 'on';
    ax.XAxis.MinorTickValues = 0:NIndivs;    
    ax.XMinorGrid = 'on';
    xticks(0:PopSize:NIndivs)
    xticklabels(0:PopSize:NIndivs)
    % y
    ax.YAxis.MinorTick = 'on';
    ax.YAxis.MinorTickValues = 0:NIndivs;    
    ax.YMinorGrid = 'on';
    yticks(0:PopSize:NIndivs)
    yticklabels(0:PopSize:NIndivs)
xlabel('Offspring','Interpreter','Latex')
ylabel('Parent','Interpreter','Latex')
title('Offspring/Parent Relationship','Interpreter','Latex')
    set(gca,'DataAspectRatio',[1,1,1])
    
%% Plot Gen/Gen-1
    % Initialization
        ReducedMat = NaN(NGen*PopSize,PopSize);
    % First generation
        ReducedMat(1:PopSize,:)=-1;
    % Loop over the other generations
        for p=2:NGen
            ReducedMat((1:PopSize)+(p-1)*PopSize,:) = ...
                RMat((1:PopSize)+(p-1)*PopSize,(1:PopSize)+(p-2)*PopSize);
        end
    % Plot
        figure,
        set(gcf,'Position',[0,0,500*sqrt(NGen),500/sqrt(NGen)])
        imagesc(-0.5+[1,NIndivs],-0.5+[1,PopSize],transpose(ReducedMat))
        set(gca,'YDir','normal')
        title('$Gen_{n-1}-Gen_{n}$ relationship','Interpreter','Latex')
    % colormap
        colormap(cmp)
        xlabel('Generation $N$','Interpreter','Latex')
        ylabel('Generation $N-1$','Interpreter','Latex')
        grid on
        ax = gca;
        % x
        ax.XAxis.MinorTick = 'on';
        ax.XAxis.MinorTickValues = 0:NIndivs;    
        ax.XMinorGrid = 'on';
        xticks(0:PopSize:NIndivs)
        xticklabels(0:PopSize:NIndivs)
        % y
        ax.YAxis.MinorTick = 'on';
        ax.YAxis.MinorTickValues = 0:PopSize;    
        ax.YMinorGrid = 'on';
        yticks(0:PopSize:PopSize)
        yticklabels(0:PopSize:PopSize)
        % ratio
        set(gca,'DataAspectRatio',[1,1,1])
        
end
