function parameters = MyExternalPlant_parameters()
	% Template file to write one's own parameter file.
    % Every instance of "MyPlant" should be replaced by an adequate name.
    % Lines ending with a "*" should not modified.
    % This file is similar to MyPlant_parameters.m except the problem type
    % is set to 'external'.
	%
	% Guy Y. Cornejo Maceda, 2022/07/01
	%
	% See also default_parameters.

	% Copyright: 2022 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
	% The MIT License (MIT)

%% Options
	parameters.verbose = 2;

%% General parameters
    parameters.Name = 'ExternalTestRun'; % Name used to save the MLC object.
    % Name of the problem file. This name corresponds to the first part of
    % the MyPlant_problem.m file.
    % Of course, one can have several parameter files referring to the same
    % problem.
    parameters.EvaluationFunction = 'MyPlant'; 
    % Following if the plant is a MATLAB file or an external
    % solver/experiment:
    %       - 'MATLAB'  : when there is a *_problem.m file.
    %       - 'external': should be used when a numerical solver is
    %       employed.
    %       - 'LabView' : should be used when xMLC is interfaced with an
    %       experiment using LabView.
    % For the last options, the EvaluationFunction parameter does not
    % matter.
    parameters.ProblemType = 'external'; % 'MATLAB', 'external' or 'LabView'
    % Path for external evaluation.
    % When the code is interfaced with an external solver or LabView,
    % files are exchanged via the folder in the PathExt path.
    % For 'MATLAB' type problems, this path is useless.
    parameters.PathExt = '/Costs'; % Folder to exchange information.
    
%% Problem parameters    
    % Inputs and outputs definition
        % The inputs and outputs are considered from the controller point
        % of view. Thus, ouputs corresponds to the actuation commands and 
        % the inputs are the sensors signals or time dependent functions.
        % Outputs---Control laws
        ProblemParameters.OutputNumber = 2; % Number of control laws
        % Intputs---Sensors and time dependent functions
            % si(t)---Sensor signals
            ProblemParameters.NumberSensors = 2;
            % Name of the variables in the solver.
            % Here 'a1' and 'a2' represent state vectors.
            ProblemParameters.Sensors = {'a1','a2'}; 
            % hi(t)---Time dependent functions
            ProblemParameters.NumberTimeDependentFunctions = 2; 
            % Include the list of time dependent functions in the
            % MATLAB/Octave syntax. The time variable should be 't'.
            ProblemParameters.TimeDependentFunctions = ...
                {'sin(2*pi*1.5*t)','sin(2*pi*2.5*t)'}; 
            % Include the list of time dependent functions one more time in
            % the solver's syntax (Fortran, MATLAB, LabView, ...).
            % If no time dependent functions are emmployed then comment.
            ProblemParameters.TimeDependentFunctions(2,:) = ...
                {'sin(2*pi*1.5*t)','sin(2*pi*2.5*t)'};
        % Consistency test.                                              %*
        ProblemParameters.InputNumber = ...                              %*
            ProblemParameters.NumberSensors+...                          %*
            ProblemParameters.NumberTimeDependentFunctions;              %* 
        % Control syntax definition.                                     %*
        Sensors = cell(1,ProblemParameters.NumberSensors);               %*
        TDF = cell(1,ProblemParameters.NumberTimeDependentFunctions);    %*
        for p=1:ProblemParameters.NumberSensors                          %*
            Sensors{p} = ['s(',num2str(p),')'];                          %*
        end                                                              %*
        for p=1:ProblemParameters.NumberTimeDependentFunctions           %*
            TDF{p} = ['h(',num2str(p),')'];                              %*
        end                                                              %*
        ControlSyntax = horzcat(Sensors,TDF);                            %*
        
    % Plant parameters.
        % Essential problem parameters used in the code.
            ProblemParameters.T0 = 0; % Not always used
            ProblemParameters.Tmax = 10; % 
            % Actuation limitation : [lower bound,upper bound]
            ProblemParameters.ActuationLimit = ...
                [-2,2;... % Boundaries for the first actuator.
                -1,1];    % Boundaries for the second actuator.
            % The evaluation of the cost function and the control points
            % will be rounded to the 'RoundEval' parameter.
            ProblemParameters.RoundEval = 6;        
            % Estimate performance
            % When a control law is evaluated several times, its
            % performance can be computed by taking the average of all the
            % evaluations.
            % Other options are also possible if there is a drift, such as:
            %   - 'last' : takes the cost of the evaluation
            %   - 'worst': takes the cost of the worst evaluation
            %   - 'best' : takes the cost of the best evaluation
            ProblemParameters.EstimatePerformance = 'mean'; 

        % Problem parameters used in the *_problem.m file.
            % Maximum evaluation time otherwise returns a bad value
            ProblemParameters.TmaxEv = 5;
            % Penalization parameter
            % It is a vector that multiplies the secondary components of
            % the cost function such as:
            % J = Ja + gamma(1)*Jb + gamma(2)*Jc
            ProblemParameters.gamma = [0.01,10];
            % Other parameters used by the solver or normalization of the
            % cost function.
            ProblemParameters.ReynoldsNumber = 100; % For example.
            ProblemParameters.J0 = 1;               % For example.
            ProblemParameters.Jmin = 0;             % For example.
            ProblemParameters.Jmax = inf;           % For example.
            % ...
        
    % Assignation
    parameters.ProblemParameters = ProblemParameters; %*

%% Control law parameters
    % Number of instructions.
    % InitMin and InitMax define the range of number of instructions when
    % the matrices are generated randomly.
    % The number of instructions for each matrix is then chosen randomly 
    % with an uniform distribution.
    % Max defines the maximum number of instructions during the learning
    % process. This is used during the crossover operation as the number of
    % instructions can grow larger than the initial number.
        ControlLaw.InstructionSize.InitMax=20;
        ControlLaw.InstructionSize.InitMin=1;
        ControlLaw.InstructionSize.Max=20;
        
    % Operators.
        ControlLaw.OperatorIndices = [1:5,7:9];
            %  implemented:  - 1  addition       (+)
            %                - 2  substraction   (-)
            %                - 3  multiplication (*)
            %                - 4  division       (%) - protected (my_div)
            %                - 5  sinus         (sin)
            %                - 6  cosinus       (cos)
            %                - 7  logarithm     (log) - protected (my_log)
            %                - 8  exp           (exp)
            %                - 9  tanh          (tanh)
            %                - 10 square        (.^2)
            %                - 11 modulo        (mod)
            %                - 12 power         (pow)
        % Precision of the evaluation of the control laws.
        % The default value is 6.
        % If this value is changed, one must also update the protected
        % operators: my_div and my_log.
        ControlLaw.Precision = 6; 
        
    % Definition of the registers.
        % Number of variable registers.
        % The miminum number is the sum between the number of inputs and
        % outputs. 
        VarRegNumberMinimum = ProblemParameters.OutputNumber+...         %*
            ProblemParameters.InputNumber;                               %*
        % More variable registers can be added if necessary.
        ControlLaw.VarRegNumber = VarRegNumberMinimum + 3; 
        % Number of constant registers.
        % Here, we only set random constants in the constant registers but 
        % one can also include sensor signals.
        ControlLaw.CstRegNumber = 4;
        % Range of the random constants constants.
        % In this example, the range of the four constants is [-1;1].
        ControlLaw.CstRange = repmat([-1,1],ControlLaw.CstRegNumber,1);
        % Total number of registers.
        ControlLaw.RegNumber = ...         % Total number of operands     *
            ControlLaw.VarRegNumber + ...  % Number of variable registers *
            ControlLaw.CstRegNumber;       % Number of constant registers *   
        % Register initialization (recommended)                                       
            NVR = ControlLaw.VarRegNumber;                               
            RN = ControlLaw.RegNumber;                                   
            r{RN}='0';                                                   
            r(:) = {'0'};                                                
            % Variable registers                                         
            for p=1:ProblemParameters.InputNumber                        
                r{p+ProblemParameters.OutputNumber} = ControlSyntax{p};  
            end                                                          
            % Constant registers                                         
            minC = min(ControlLaw.CstRange,[],2);                        
            maxC = max(ControlLaw.CstRange,[],2);                        
            dC = maxC-minC;                                              
            for p=NVR+1:RN                                               
                r{p} = num2str(dC(p-NVR)*rand+minC(p-NVR));              
            end                                                          
        % Assignation                                                    
        ControlLaw.Registers = r;                                        %*
            
        % Control law estimation.
        ControlLaw.ControlPointNumber = 1000;
        % Sensor range to define the sampling points.
        % In this case, the range of all sensors is [-2,2].
        ControlLaw.SensorRange = repmat([-2 2],...
            ProblemParameters.NumberSensors,1);
        % Definition of random sampling points (ControlPoints) and random
        % time samplings for the control law estimation
            Nbpts = ControlLaw.ControlPointNumber;                       %*
            Rmin = min(ControlLaw.SensorRange,[],2);                     %*
            Rmax = max(ControlLaw.SensorRange,[],2);                     %*
            dR = Rmax-Rmin;                                              %*
        ControlLaw.EvalTimeSample = rand(1,Nbpts)*ProblemParameters.Tmax;%*
        ControlLaw.ControlPoints = ...                                   %*
            rand(ProblemParameters.NumberSensors,Nbpts).*dR+Rmin;        %*

    % Assignation
    parameters.ControlLaw = ControlLaw;                                  %*

%% MLC parameters
    % Population size
    parameters.PopulationSize = 10;
    % Optimization options
        % Optimization of the first generation only (Monte Carlo).
        % It removes the duplicated individuals, redundant, etc.
    parameters.OptiMonteCarlo = 1; 
    % Remove individuals whose evaluation failed (bad)
    parameters.RemoveBadIndividuals = 1; 
    % Remove already evaluated individuals
    parameters.RemoveRedundant = 1; 
    % Remove the individuals if they have already been evaluated in a
    % earlier generations.
    parameters.CrossGenRemoval = 1;
    % Evaluate the initial condition of the registers (here:b=0)
    parameters.ExploreIC = 1; 
    % The crossover and mutaiton operators are until new individuals are
    % generated or MaxIterations iterations is reached.
    parameters.MaxIterations = 100;
    % Reevaluation of the individuals for stochastic problems.
    % This parameter implicitly set to 1 for experiments.
    %   - 0: No revaluation
    %   - 1: Force the reevaluation of the replicated and "elitism" indiv.
    %   - n: Each individual is reevaluated n times.
    parameters.MultipleEvaluations = 0;
    % Selection parameters.
    parameters.TournamentSize = 7;
    parameters.p_tour = 1;
    % Genetic operator parameters
    parameters.Elitism = 1;
    parameters.CrossoverProb = 0.6;
    parameters.MutationProb = 0.3;
    parameters.ReplicationProb = 0.1;
    % Other genetic parameters
        % How mutations per matrix (MutationType)?
        %   - 'classic': depends on the mutation rate. The mutation rate is
        %   the probability that a given line changes.
        %   - 'at_least_one': the mutation rate is set such as there is at
        %   least one mutation per matrix.
        %   - 'number_per_chromosome': the mutation rate is set such as
        %   there is at least MutationNumber mutations per matrix.
        %   least one mutation per matrix.
    parameters.MutationType = 'number_per_matrix';
    parameters.MutationNumber = 1;
    parameters.MutationRate = 0.05;
    % Number of cuts in the matrices for the crossover operation.
    parameters.CrossoverPoints = 1;
    % If CrossoverMix=1, the offsprings are built by alternating their
    % parents sections, if CrossoverMix=0, the sections are selected
    % randomnly.
    parameters.CrossoverMix = 1; 
    % The crossover operation gives two offsprings by crossver operation.
    parameters.CrossoverOptions = {'gives2'};
    % Other parameters
    % Cost value for individuals whose evaluation failed.
    parameters.BadValue = 10^36;
    % Remove the individuals that do not satisfy a given test.
    % The removed individuals are refered as "wrong" individuals.
    parameters.Pretesting = 0;  

%% Constants
    parameters.PHI = 1.61803398875;

%% Other parameters
    % Parameter that stores the list of saving times.
    % Can help to keep track of the latest version.
    parameters.LastSave = '';

end
