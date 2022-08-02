function parameters = default_parameters()
	% Parameters for the stabilization of a limit cycle to its fixed point.
	%
	% Guy Y. Cornejo Maceda, 2022/07/01
	%
	% See also MLC.

	% Copyright: 2022 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
	% The MIT License (MIT)

%% Options
	parameters.verbose = 2;

%% Problem parameters
% Problem
    parameters.Name = 'TestRun';
    parameters.EvaluationFunction = 'LandauOscillator';
    parameters.ProblemType = 'MATLAB'; % 'external' or 'MATLAB' or 'LabView'
    % Path for external evaluation
    parameters.PathExt = '/Costs'; % For external evaluations
    
        % Problem variables
        % The inputs and outputs are considered from the controller point
        % of view. Thus outputs are the controllers (plasma, jets) and
        % inputs are sensors and time dependent functions.
        % Outputs - Number of control laws
        ProblemParameters.OutputNumber = 1; % Number of OutputNumber
        % Inputs - Number of sensors and time dependent functions
            % si(t)
            ProblemParameters.NumberSensors = 2;
            ProblemParameters.Sensors = {'a1','a2'}; % name in the problem
            % hi(t)
            ProblemParameters.NumberTimeDependentFunctions = 0; % sin(wt)... multifrequency-forcing
            ProblemParameters.TimeDependentFunctions = {}; % syntax in MATLAB/Octave
%             ProblemParameters.TimeDependentFunctions(2,:) = {}; % syntax in the problem (if null then comment)
        ProblemParameters.InputNumber = ProblemParameters.NumberSensors+ProblemParameters.NumberTimeDependentFunctions; 
        % Control Syntax
        Sensors = cell(1,ProblemParameters.NumberSensors); %*
        TDF = cell(1,ProblemParameters.NumberTimeDependentFunctions); %*
        for p=1:ProblemParameters.NumberSensors,Sensors{p} = ['s(',num2str(p),')'];end %*
        for p=1:ProblemParameters.NumberTimeDependentFunctions,TDF{p} = ['h(',num2str(p),')'];end %*
        ControlSyntax = horzcat(Sensors,TDF); %*
        
        % Essential problem parameters
            ProblemParameters.NPeriods = 10; % Number of periods
            ProblemParameters.T0 = 0; % Not always used
            ProblemParameters.Tmax = round(2*pi*ProblemParameters.NPeriods/1); % omega=1
            % Actuation limitation : [lower bound,upper bound]
            ProblemParameters.ActuationLimit = [-1,1];
        % Evaluation - used in the *_problem.m file
        % Maximum evaluation time otherwise returns an bad value
        ProblemParameters.TmaxEv = 5; % otherwise bad
        % Problem definition
        ProblemParameters.NPointsPeriod = 51; % Number of points per period
            time = linspace(ProblemParameters.T0,ProblemParameters.Tmax,...
                ProblemParameters.NPointsPeriod*ProblemParameters.NPeriods+1);
        ProblemParameters.dt = time(2)-time(1);
        ProblemParameters.InitialCondition = [1 0;0 1;-1 0;0 -1]; % Four symmetrical
        % Cost function penalization
        ProblemParameters.gamma = [0.01]; % J = Ja + gamma(1)*Jb + gamma(2)*Jc + ...
        
        % Round evaluation of control points and J
        ProblemParameters.RoundEval = 6;
        % Costs
        ProblemParameters.J0 = 1; % User defined
        ProblemParameters.Jmin = 0; % User defined
        ProblemParameters.Jmax = inf; % User defined
        % Estimate performance
        ProblemParameters.EstimatePerformance = 'mean'; % default 'mean', if drift 'last', 'worst', 'best'

    % Definition
    parameters.ProblemParameters = ProblemParameters; %*

%% Control law parameters
        % Number of instructions
        ControlLaw.InstructionSize.InitMax=20;
        ControlLaw.InstructionSize.InitMin=1;
        ControlLaw.InstructionSize.Max=20;
        
        % Operators
        ControlLaw.OperatorIndices = [1:5,7:9];
            %   implemented:     - 1  addition       (+)
            %                    - 2  subtraction    (-)
            %                    - 3  multiplication (*)
            %                    - 4  division       (%)
            %                    - 5  sine          (sin)
            %                    - 6  cosine        (cos)
            %                    - 7  logarithm     (log)
            %                    - 8  exp           (exp)
            %                    - 9  tanh          (tanh)
            %                    - 10 square        (.^2)
            %                    - 11 modulo        (mod)
            %                    - 12 power         (pow)
            %
        ControlLaw.Precision = 6; % Precision of the evaluation of the control law % to change also in my_div and my_log
        % Registers
            % Number of variable registers
            VarRegNumberMinimum = ProblemParameters.OutputNumber+ProblemParameters.InputNumber; %*
            ControlLaw.VarRegNumber = VarRegNumberMinimum + 3; % add some memory slots if needed  
            % Number of constant registers
            ControlLaw.CstRegNumber = 4;
            ControlLaw.CstRange = [repmat([-1,1],ControlLaw.CstRegNumber,1)]; % Range of values of the random constants
            % Total number of registers
            ControlLaw.RegNumber = ControlLaw.VarRegNumber + ControlLaw.CstRegNumber;  %* % variable registers and constante registers (operands)
            
            % Register initialization
                NVR = ControlLaw.VarRegNumber; %*
                RN = ControlLaw.RegNumber; %*
                r{RN}='0'; %*
                r(:) = {'0'}; %*
                % Variable registers
                for p=1:ProblemParameters.InputNumber %*
                    r{p+ProblemParameters.OutputNumber} = ControlSyntax{p}; %*
                end
                % Constant registers
                minC = min(ControlLaw.CstRange,[],2); %*
                maxC = max(ControlLaw.CstRange,[],2); %*
                dC = maxC-minC; %*
                for p=NVR+1:RN %*
                    r{p} = num2str(dC(p-NVR)*rand+minC(p-NVR)); %*
                end %*
            ControlLaw.Registers = r; %*
            
        % Control law estimation
        ControlLaw.ControlPointNumber = 1000;
        ControlLaw.SensorRange = [repmat([-2 2],ProblemParameters.NumberSensors,1)]; % Range for sensors
            Nbpts = ControlLaw.ControlPointNumber; %*
            Rmin = min(ControlLaw.SensorRange,[],2); %*
            Rmax = max(ControlLaw.SensorRange,[],2); %*
            dR = Rmax-Rmin; %*
        ControlLaw.EvalTimeSample = rand(1,Nbpts)*ProblemParameters.Tmax; %*
        ControlLaw.ControlPoints = rand(ProblemParameters.NumberSensors,Nbpts).*dR+Rmin; %*

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
    parameters.MutationType = 'number_per_matrix';
    parameters.MutationNumber = 1;
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
