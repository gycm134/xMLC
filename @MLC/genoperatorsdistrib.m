function genoperatorsdistrib(MLC)
    % genoperatorsdistrib gives the distribution of the operators across the
    % generations
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
    Nrand = zeros(NGen,1);
    Nelit = zeros(NGen,1);
    Ncross = zeros(NGen,1);
    Nmut = zeros(NGen,1);
    Nrep = zeros(NGen,1);
    Mat = -ones(NGen,PopSize);
    
%% Loop to retrieve data
    for p=1:NGen
        for q=1:PopSize
            switch MLC.population(p).operation{q}.type
                case 'random' % 0
                    Nrand(p) = Nrand(p)+1;
                    Mat(p,q) = 0;
                case 'Elitism' % 1
                    Nelit(p) = Nelit(p)+1;
                    Mat(p,q) = 1;
                case 'crossover' % 2
                    Ncross(p) = Ncross(p)+1;
                    Mat(p,q) = 2;
                case 'mutation' % 3
                    Nmut(p) = Nmut(p)+1;
                    Mat(p,q) = 3;
                case 'replication' % 4
                    Nrep(p) = Nrep(p)+1;
                    Mat(p,q) = 4;
                otherwise
                    error('Wrong operation')
            end
        end
    end
    % Matrix form (Elitism,crossover,mutation,replication)
    MatSum = [Nrand,Nelit,Ncross,Nmut,Nrep];
  
%% Test
if sum(sum(MatSum))~=NGen*PopSize
    error('Wrong number of operations')
end

%% Colormap
    cmp = [0,0,1;... % Random
        1,1,0;...    % Elitism
        1,0,0;...    % Crossover
        0,1,0;...    % Mutation
        0,0,0];      % Replication
    
%% Plot summary
figure,
b=bar(MatSum,1,'stacked');
b(1).FaceColor = cmp(1,:);
b(2).FaceColor = cmp(2,:);
b(3).FaceColor = cmp(3,:);
b(4).FaceColor = cmp(4,:);
b(5).FaceColor = cmp(5,:);
legend('random','Elitism','crossover','mutation','replication')
ylabel('# individuals')
xlabel('generation')
axis tight

%% Plot distribution
figure,
imagesc(transpose(Mat))
set(gca,'YDir','normal')
    % colormap
    colormap(cmp)
    
end
