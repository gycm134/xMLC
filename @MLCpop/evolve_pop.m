function new_pop = evolve_pop(pop,MLC_parameters,MLC_table,NbIndividuals)
    % EVOLVE_POP Derives a new population from an other population.
    % The new individuals are generated thanks to the genetic operators and stored
    % in the table
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also create_pop, evaluate_pop, MLCpop.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

%% Arguments
if nargin<4, NbIndividuals=size(pop.individuals,1);end

%% Parameters
PopSize = NbIndividuals;
GeneticProbabilities = [MLC_parameters.CrossoverProb;
                        MLC_parameters.MutationProb;
                        MLC_parameters.ReplicationProb];
                        
%% Initialization of the generation gen+1
new_pop = MLCpop(pop.generation+1,PopSize);
N_indivs = 0;

%% Elitism
if NbIndividuals==MLC_parameters.PopulationSize
  N_indivs = new_pop.elitism(pop,MLC_parameters,MLC_table); %number of individuals already generated
end

%% Loop to fill the population
while N_indivs < PopSize
    % Choose the operation
    ope = choose_operation(GeneticProbabilities);
    switch ope
        case 'replication'
            new_pop.replication(pop,MLC_parameters,MLC_table,N_indivs);

        case 'mutation'
            new_pop.mutate(pop,MLC_parameters,MLC_table,N_indivs);
            % new_pop size increase

        case 'crossover'
            if strcmp(MLC_parameters.CrossoverOptions{1},'gives2') %is it an option?
                g2=true;
            else
                g2=false;
            end
            if N_indivs < PopSize-1 % do we hace the space ?
                c2=true;
            else
                c2=false;
            end

            new_pop.crossover(pop,MLC_parameters,MLC_table,N_indivs,g2&&c2);
    end
    % new_pop size increase
    N_indivs = sum(new_pop.chromosome_lengths(:,1)>0);
end

%% Update properties
new_pop.evaluation = 'generated';
end
