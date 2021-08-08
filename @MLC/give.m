function give(MLC,GenList,IndList)
    % GIVE Gives information concerning an individual.
    % Given a list of generations and list of individuals ranks gives some
    % information concerning those individuals.
    % Only on argument can be give, the list of the labels.
    % 1. mlc.give([1,2],[3,4,5])
    % gives informations about the 3rd, 4th and 5th individuals of the 1st and 2nd generations
    % 2. mlc.give(1,20,30)
    % gives information about individual 1, 20 and 30 of the table (database)
    % The cost is given according to the EstimatePerformance parameter.
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also best_individual, best_individuals

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA
%% Parameters
    EstimatePerformance = MLC.parameters.ProblemParameters.EstimatePerformance;
%% Loop over the individuals
for g=1:length(GenList)
    Gen=GenList(g);
    fprintf('\n')
    if nargin <3
        ind =Gen;
        fprintf('%i-th Individual of the database:\n',Gen)
        individual = MLC.table.individuals(ind);
        give_print(EstimatePerformance,individual);
    else
        for ip=1:length(IndList)
            IND=IndList(ip);
            ind = MLC.population(Gen).individuals(IND);
            fprintf('Generation %i - Individual %i (Individual %i):\n',Gen,IND,ind)
            individual = MLC.table.individuals(ind);
            population = MLC.population(Gen);
            give_print(EstimatePerformance,individual,population,IND);
        end %for IND
    end%if nargin
end %for gen
end %function

%% Auxiliary function
function give_print(EstimatePerformance,individual,population,IND)
    all_J = cell2mat(individual.cost(:,1));
    switch EstimatePerformance
        case 'mean'
            J = mean(all_J);
        case 'last'
            J = all_J(end);
        case 'worst'
            J = max(all_J);
        case 'best'
            J = min(all_J);
    end
fprintf('   cost (%s over %i evaluations): %f\n',EstimatePerformance,size(individual.cost,1),J)
ListOrd = {'st','nd','rd','th'};
for p=1:size(all_J,1)
    if p>3,ord=ListOrd{4};else ord=ListOrd{p};end
    fprintf('       %i-%s evaluation cost : %f\n',p,ord,all_J(p))
end
fprintf('   occurences: %i\n',individual.occurences)
fprintf('   control law:')
fprintf('\n')

for q=1:size(individual.control_law,1)
    fprintf('      b%i = ',q)
    fprintf(individual.control_law{q})
    fprintf('\n')
end

if nargin ==4
    fprintf('   operation : %s\n',population.operation{IND}.type)
    fprintf('      parents: %i - %i\n',population.parents(IND,:))
end

fprintf('   ref:%i\n',individual.ref)
fprintf('\n')
end
