function MLC=go(MLC,N_generations)
    % GO Go method for MLC
    % Run
    %   mlc.go(N_generations);
    % to launch the evolution of N_generations.
    % Needs to run the Initialization script before.
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also MLC, @MLC/save, @MLC/load.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

Start_time=tic;
%% Parameters
    Name = MLC.parameters.Name;
    
%% Folders
    % create them
    create_folders(Name);
    
%% First generation test
    if isempty(MLC.population) % Is there any population ?
        Gen_n = 0;
        MLC.generate_population;
        MLC.evaluate_population;
        Gen_nplusone = 1;
    elseif strcmp(MLC.population(1).evaluation,'generated') % Is it evaluated ?
        Gen_n = 0;
        MLC.evaluate_population;
        Gen_nplusone = 1;
    else
        Gen_n = length(MLC.population);
        Gen_nplusone = Gen_n;
    end


%% Loop over the generations
    while MLC.generation<N_generations
        MLC.evolve_population;
        Gen_nplusone = Gen_nplusone+1;
        MLC.evaluate_population;
    end

%% Print
    % Computation time
        fprintf([num2str(Gen_nplusone-Gen_n),' generation(s) calculated in ',num2str(toc(Start_time)),' seconds\n'])
    % Extract best individual informations
        last_gen = length(MLC.population);
        best_cost= MLC.population(last_gen).costs(1);
        best_indiv = MLC.population(last_gen).individuals(1);
    % Print
        fprintf(' Cost of the best individual = %s\n',num2str(best_cost))
        fprintf(' Its expression = \n')
    % The control law
        if MLC.parameters.ProblemParameters.OutputNumber==1
            expr = MLC.table.individuals(best_indiv).control_law{1};
            fprintf('    b = %s\n',expr)
        else
            for p=1:MLC.parameters.ProblemParameters.OutputNumber
                expr = MLC.table.individuals(best_indiv).control_law{p};
                fprintf('    b%i = %s\n',p,expr)
            end
        end

end
