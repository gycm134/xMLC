function pop = clean(pop,MLC_parameters,MLC_table,pop_old,idx_bad_values)
    % CLEAN remove individuals after a pre-test
    % Removes non adequate individuals by applying different tests.
    % Those tests are done until the population is filled only with adequate individuals.
    % The indices in idx_bad_values are cleaned.
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also pretesting, find_bad_individuals, replace_individuals.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

%% Initialization
	PopSize = MLC_parameters.PopulationSize;
	pretest = MLC_parameters.Pretesting;

%% idx_bad_values
	if nargin<5
		if MLC_parameters.ExploreIC
			ii = 2;
		else
			ii = 1;
		end
	    idx_bad_values=ii:length(pop.individuals);
    end

%% Remove individuals whos pre-evaluation in the control points
    ContinueCleanPreEval=1;
    
    % Find the problematic individuals 
        idx = find_bad_preeval_individuals(pop,MLC_table,idx_bad_values); %logical
    % If there is no wrong indivuals, there is nothing to replace.
        if not(isempty(idx))
            fprintf('%i pre-evaluated individuals to be removed\n',length(idx))
        else
            ContinueCleanPreEval=0;
            fprintf('No pre-evaluated individuals to be removed')
        end
            
    while ContinueCleanPreEval
        % Replace those individuals with new individuals
            pop.replace_individuals(idx,MLC_parameters,MLC_table,pop_old);

        % Find the problematic individuals 
            idx = find_bad_preeval_individuals(pop,MLC_table,idx_bad_values); %logical
            
        % If there is no wrong indivuals, there is nothing to replace.
            if not(isempty(idx))
                fprintf('%i pre-evaluated individuals to be removed\n',length(idx))
            else
                ContinueCleanPreEval=0;
                fprintf('No pre-evaluated individuals to be removed')
            end
    end

%% Tests
	IND_ref = zeros(length(pop),1);
	IND_ref = pop;
	while pretest
	    IND=pop.pretesting(MLC_parameters,MLC_table,pop_old,idx_bad_values);
	    pretest = sum(IND_ref==IND)~=PopSize; % if there is one different redo the cleaning
	    IND_ref = IND;
	end
