function chromosome(MLC,GenList,IndList)
    % CHROMOSOME gives the matrix of the individual.
    % Gives the matrix of the individual.
    % First argument is a vector of generations.
    % Second argument is a list individuals.
    % To have the chromosome of the 7th individual of the 3rd generation:
    %     mlc.chromosome(2,7);
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also best_individual, give, chromosome.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA
 
%% Test
    % Number of generations
    if sum(GenList>MLC.generation)
        error('Not enough generations, compute more generations.')
    end
    % Population size
    if sum(IndList>MLC.parameters.PopulationSize)
        error('Not enough individuals, check population size.')
    end
    
%% Loop
for gp=1:length(GenList)
    Gen=GenList(gp);
    fprintf('\n')
    if nargin <3
        ind =Gen;
        fprintf('%i-th Individual of the database:\n',Gen)
        individual = MLC.table.individuals(ind);
        give_chromosome(individual);
    else
        for ip=1:length(IndList)
            IND=IndList(ip);
            ind = MLC.population(Gen).individuals(IND);
            fprintf('Generation %i - Individual %i (Individual %i):\n',Gen,IND,ind)
            individual = MLC.table.individuals(ind);
            give_chromosome(individual);
        end %for IND
    end%if nargin
    fprintf('\n')
end %for gen
end %function

%% Auxiliary function
function give_chromosome(individual)
    fprintf('   chromosome:\n')
    disp(individual.chromosome)
    fprintf('   effective instructions:\n')
    EI=individual.EI;
    disp([EI.chromosome,EI.indices'])
end
