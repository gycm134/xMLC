function external_evaluation(MLC,gen)
    % EXTERNAL_EVALUATION creates a file for external evaluaton
    % Generates a file GenXpopulation.mat, with X being the generation GEN.
    % The file is stored in the Populations/ folder.
    % GenXpopulation.mat is cell array containing all the control laws of a generation
    % in MATLAB expression.
    % Each line correspond to one control law and each column to one actuator.
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also complete, External_evaluation_CONTINUE, External_evaluation_END.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA



%% Parameters
  ngen = length(MLC.population);
  actuation_limit = MLC.parameters.ProblemParameters.ActuationLimit;
  OutputNumber = MLC.parameters.ProblemParameters.OutputNumber;
  PopSize = MLC.parameters.PopulationSize;
  Name = MLC.parameters.Name;
  
%% Arguments
  if ~(gen<=0 || gen >ngen)
    ngen=gen;
  end

%% Initialization
  GenPopulation = cell(PopSize,OutputNumber);

%% Actuation limitation
  for p=1:MLC.parameters.PopulationSize
    % index  
    idx = MLC.population(ngen).individuals(p);
    % individual
	indiv = MLC.table.individuals(idx);
    % control law
    control_law = indiv.control_law;
    % replace the control law for evaluation
    control_law = strrep_cl(MLC.parameters,control_law,2);
    % limit the control law
    control_law = limit_to(control_law,actuation_limit);
    % fill the variable
    GenPopulation(p,:) = control_law(:);
  end

%% Save
    dir = ['save_runs/',Name];
    if not(exist([dir,'/Populations'],'dir')),mkdir([dir,'/Populations']);end
        
  save([dir,'/Populations/Gen',num2str(ngen),'population.mat'],'GenPopulation');
end
