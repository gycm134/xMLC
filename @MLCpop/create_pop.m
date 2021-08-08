function pop=create_pop(pop,MLC_parameters,MLC_table)
  % CREATE_POP Fills a MLCpop object with new individuals.
  % Use the method create_indiv to fill the population with new individuals.
  % It is called by @MLC/generate_population and @MLCpop/replace_individuals
  %
  % Guy Y. Cornejo Maceda, 07/18/2020
  %
  % See also evolve_pop, evolve_pop, MLCpop.

  % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
  % CC-BY-SA


%% Generating a new population
  TIME = tic;

%% MLC parameters
  PopSize = size(pop.individuals,1);
  rmdd = MLC_parameters.RemoveRedundants;

  if MLC_parameters.verbose
      fprintf('Generating new population\n')
      fprintf(['    population size = ',num2str(PopSize),'\n'])
  end

%% Preallocation
  indivs = zeros(PopSize,1);
  chro_lengths = zeros(PopSize,2);

%% Create the population
for p=1:PopSize
    % Print
    if MLC_parameters.verbose
        fprintf('    Generating new individual %i/%i',p,PopSize)
    end
    % First individual
    FI=0;
    if p==1
    	FI = MLC_parameters.ExploreIC;
    end
    % Create new individual
    new_individual=MLCind;
    new_individual.create_indiv(MLC_parameters,FI);
    [idx,already_exist]=MLC_table.add_indiv(MLC_parameters,new_individual,1:MLC_table.number);
      % Test if it already exists
%       already_exist = 1;
        while already_exist&&rmdd
            new_individual=MLCind;
            new_individual.create_indiv(MLC_parameters,FI);
            [idx,already_exist]=MLC_table.add_indiv(MLC_parameters,new_individual,1:MLC_table.number);
        end
    % Population properties filling
    indivs(p) = idx;
    chro_lengths(p,:) = new_individual.chromosome_lengths;
    % Print
    if MLC_parameters.verbose
        fprintf(' Done \n')
    end
end

%% Fill the population
  pop.individuals = indivs;
  pop.chromosome_lengths = chro_lengths;
  pop.evaluation = 'created';

%% Print
    fprintf('End of generation : population generated in %s seconds\n',num2str(toc(TIME)))
end
