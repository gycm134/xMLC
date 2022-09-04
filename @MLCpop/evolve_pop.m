function new_pop = evolve_pop(pop,MLC_parameters,MLC_table,NbIndividuals)
    % EVOLVE_POP Derives a new population from an other population.
    % The new individuals are generated thanks to the genetic operators and stored
    % in the table
    %
    %
    % See also create_pop, evaluate_pop, MLCpop.

    %   Copyright (C) 2015-2017 Thomas Duriez.
    %   This file is adapted from @MLCpop/evolve.m of the OpenMLC-Matlab-2 Toolbox. Distributed under GPL v3.

%% Arguments
if nargin<4, NbIndividuals=size(pop.individuals,1);end

%% Parameters
PopSize = NbIndividuals;
GeneticProbabilities = [MLC_parameters.CrossoverProb;
                        MLC_parameters.MutationProb;
                        MLC_parameters.ReplicationProb];
                        
%% Initialization of the generation gen+1
new_pop = MLCpop(pop.generation+1,PopSize);
NIndivs = 0;

%% Elitism
if NbIndividuals==MLC_parameters.PopulationSize
  NIndivs = new_pop.elitism(pop,MLC_parameters,MLC_table); %number of individuals already generated
  % Print output
  if MLC_parameters.verbose
      for p=1:NIndivs
        fprintf('    Generating new individual %i/%i %s.\n',p,PopSize,'Elitism')
      end
  end
end

%% Loop to fill the population
while NIndivs < PopSize
    % Choose the operation
    ope = choose_operation(GeneticProbabilities);
    switch ope
        case 'replication'
            new_pop.replication(pop,MLC_parameters,MLC_table,NIndivs);
            if MLC_parameters.verbose
                fprintf('    Generating new individual %i/%i %s.\n',NIndivs+1,PopSize,'Replication')
            end

        case 'mutation'
            new_pop.mutate(pop,MLC_parameters,MLC_table,NIndivs);
            % new_pop size increase
            if MLC_parameters.verbose
                fprintf('    Generating new individual %i/%i %s.\n',NIndivs+1,PopSize,'Mutation')
            end

        case 'crossover'
            if strcmp(MLC_parameters.CrossoverOptions{1},'gives2') %is it an option?
                g2=true;
            else
                g2=false;
            end
            if NIndivs < PopSize-1 % do we have the space ?
                c2=true;
            else
                c2=false;
            end
            N1 = sum(new_pop.chromosome_lengths(:,1)>0);
            new_pop.crossover(pop,MLC_parameters,MLC_table,NIndivs,g2&&c2);
            N2 = sum(new_pop.chromosome_lengths(:,1)>0);
            
            if MLC_parameters.verbose
                fprintf('    Generating new individual %i/%i %s.\n',NIndivs+1,PopSize,'Crossover')
                if N2>(N1+1)
                    fprintf('    Generating new individual %i/%i %s.\n',NIndivs+2,PopSize,'Crossover')
                end
            end
    end
    % new_pop size increase
    NIndivs = sum(new_pop.chromosome_lengths(:,1)>0);
end

%% Update properties
new_pop.evaluation = 'generated';
end
