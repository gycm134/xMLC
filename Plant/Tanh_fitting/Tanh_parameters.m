function parameters = Tanh_parameters()
	% Default parameters for the tanh problem.
	%
	% Guy Y. Cornejo Maceda, 2022/07/01
	%
	% See also MLC.

	% Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
	% The MIT License (MIT)

%% Options
	parameters.verbose = 2;
   
%% Problem parameters
% Problem
    parameters.Name = 'Tanh_fitting'; % mlc.save_matlab('GenN'); ,mlc.load_matlab('Toy','GenN_moins_un')
    parameters.EvaluationFunction = 'tanh'; % 'GMFM' or 'FP' or 'none'
    parameters.ProblemType = 'MATLAB'; % 'external' or 'MATLAB' or 'LabView' or 'Dummy'
    % Path for external evaluation
    parameters.PathExt = '/Costs'; % For external evaluations
    
        % Problem variables
        % The inputs and outputs are considered from the controller point
        % of view. Thus ouputs are the controllers (plasma, jets) and
        % inputs are sensors and time dependent functions.
        % Outputs - Number of control laws
        ProblemParameters.OutputNumber = 1; % Number of OutputNumber
        % Intputs - Number of sensors and time dependent functions
            % si(t)
            ProblemParameters.NumberSensors = 0;
            ProblemParameters.Sensors = {}; % name in the problem
            % hi(t)
            ProblemParameters.NumberTimeDependentFunctions = 1; % sin(wt)... multifrequency-forcing
            ProblemParameters.TimeDependentFunctions = {'t'}; % syntax in MATLAB/Octave. 't' is the time variable.
            ProblemParameters.TimeDependentFunctions(2,:) = {'T'}; % syntax in the problem (if null then comment)
        ProblemParameters.InputNumber = ProblemParameters.NumberSensors+ProblemParameters.NumberTimeDependentFunctions; 
        % Control Syntax
        Sensors = cell(1,ProblemParameters.NumberSensors); %*
        TDF = cell(1,ProblemParameters.NumberTimeDependentFunctions); %*
        for p=1:ProblemParameters.NumberSensors,Sensors{p} = ['s(',num2str(p),')'];end %*
        for p=1:ProblemParameters.NumberTimeDependentFunctions,TDF{p} = ['h(',num2str(p),')'];end %*
        ControlSyntax = horzcat(Sensors,TDF); %*
        
        % Essential problem parameters
            ProblemParameters.T0 = -2; % Care control points
            ProblemParameters.Tmax = 2;
            % Actuation limitation : [lower bound,upper bound]
            ProblemParameters.ActuationLimit = [-inf,inf];
            % Actuation limitation : [lower bound,upper bound]
            ProblemParameters.ActuationLimit = [-inf,inf];
        % Evaluation - used in the *_problem.m file
        % Maximum evaluation time otherwise returns an bad value
        ProblemParameters.TmaxEv = 5; % otherwise parameters.BadValue is given
        % Problem definition
        ProblemParameters.T0 = -2; % Care control points
        ProblemParameters.Tmax = 2;
        ProblemParameters.dt = 1e-4;
        % number of initial conditions
        ProblemParameters.InitialCondition = 1;
        % Cost function penalization
%         ProblemParameters.gamma = [];% J = Ja + gamma(1)*Jb + gamma(2)*Jc

        % Round evaluation of control points and J
        ProblemParameters.RoundEval = 6;
        % Costs
        ProblemParameters.J0 = 1; % User defined
        ProblemParameters.Jmin = 0;
        ProblemParameters.Jmax = inf;
        % Estimate performance
        ProblemParameters.EstimatePerformance = 'mean'; % default 'mean', if drift 'last', 'worst', 'best'
        
    % Definition
    parameters.ProblemParameters = ProblemParameters;

 %% Control law parameters
  		% Number of instructions
  		ControlLaw.InstructionSize.InitMax=50;
  		ControlLaw.InstructionSize.InitMin=1;
  		ControlLaw.InstructionSize.Max=50;
        
  		% Operators
  		ControlLaw.OperatorIndices = [1:9];
  			%   implemented:     - 1  addition       (+)
  			%                    - 2  substraction   (-)
  			%                    - 3  multiplication (*)
  			%                    - 4  division       (%)
  			%                    - 5  sinus         (sin)
  			%                    - 6  cosinus       (cos)
  			%                    - 7  logarithm     (log)
  			%                    - 8  exp           (exp)
  			%                    - 9  tanh          (tanh)
  			%                    - 10 square        (.^2)
  			%                    - 11 modulo        (mod)
  			%                    - 12 power         (pow)
  			%
  		ControlLaw.Precision = 6;
        
  		% Registers      
        % Number of variable.ControlLaw.Registers
            VarRegNumberMinimum = ProblemParameters.OutputNumber+ProblemParameters.InputNumber; %*
            ControlLaw.VarRegNumber = VarRegNumberMinimum + 3; % add some memory slots if needed  
            % Number of constant.ControlLaw.Registers
            ControlLaw.CstRegNumber = 4;
            ControlLaw.CstRange = [repmat([-1,1],ControlLaw.CstRegNumber,1)]; % Range of values of the random constants
            % Total number of.ControlLaw.Registers
            ControlLaw.RegNumber = ControlLaw.VarRegNumber + ControlLaw.CstRegNumber;  %* % variable.ControlLaw.Registers and constante.ControlLaw.Registers (operands)

  		% Register initialization
  			NVR = ControlLaw.VarRegNumber;%*
  			RN = ControlLaw.RegNumber;%*
            r{RN}='0';%*
            r(:)={'0'};%*
            % Variable.ControlLaw.Registers
                for p=1:ProblemParameters.InputNumber %*
                    r{p+ProblemParameters.OutputNumber} = ControlSyntax{p}; %*
                end
                % Constant.ControlLaw.Registers
                minC = min(ControlLaw.CstRange,[],2); %*
                maxC = max(ControlLaw.CstRange,[],2); %*
                dC = maxC-minC; %*
                for p=NVR+1:RN %*
                    r{p} = num2str(dC(p-NVR)*rand+minC(p-NVR)); %*
                end %*
            ControlLaw.Registers = r; %*

        % Control law estimation
  		ControlLaw.ControlPointNumber = 1000;%* new Name
  		ControlLaw.SensorRange = [-2,2];%*
  		    Nbpts = ControlLaw.ControlPointNumber;%*
  		    Rmin = min(ControlLaw.SensorRange,[],2);%*
  		    Rmax = max(ControlLaw.SensorRange,[],2);%*
  		    Rmean = mean([Rmin,Rmax]);%*
  		    dR = abs(Rmean-Rmin);%*
  		ControlLaw.EvalTimeSample = rand(1,Nbpts)*(ProblemParameters.Tmax-ProblemParameters.T0)+ProblemParameters.T0;
  		ControlLaw.ControlPoints = 2*rand(ProblemParameters.InputNumber,Nbpts)*dR+Rmin;%*

    % Definition
    parameters.ControlLaw = ControlLaw; %*

%% MLC parameters
    % Population size
    parameters.PopulationSize = 10;
    % Optimization parameters
    parameters.OptiMonteCarlo = 1; % Optimization of the first generation (remove duplicates, redundant..)
    parameters.RemoveBadIndividuals = 1; % Remove indiviuals which evaluation failed
    parameters.RemoveRedundant = 1; % Remove already evaluated individuals
    parameters.CrossGenRemoval = 1; % Remove the individuals if they have already been evaluated in an earlier generation
    parameters.ExploreIC = 1; % Evaluate the initial condition of registers (here:b=0)
    % For remove_duplicates_operators and redundant, maximum number of
    % iterations of the operations when the test is not satisfied.
    parameters.MaxIterations = 10; % better around 100 (-> MaxInterations)
    % Reevaluate individuals (noise and experiment)
    parameters.MultipleEvaluations = 0;
    % Stopping criterion
    parameters.Criterion = 'number of evaluations'; % (not yet)
    % Selection parameters
    parameters.TournamentSize = 7;
    parameters.p_tour = 1;
    % Selection genetic operator parameters
    parameters.Elitism = 1;
    parameters.CrossoverProb = 0.6;
    parameters.MutationProb = 0.3;
    parameters.ReplicationProb = 0.1;
    % Other genetic parameters
    parameters.MutationType = 'at_least_one';
    parameters.MutationRate = 0.05;
    parameters.CrossoverPoints = 1;
    parameters.CrossoverMix = 1;
    parameters.CrossoverOptions = {'gives2'};
    % Other parameters
    parameters.BadValue = 10^36;
    parameters.Pretesting = 0; % (not yet) remove individuals who have no effective instruction

%% Constants
    parameters.PHI = 1.61803398875;

%% Other parameters
    parameters.LastSave = '';

end
