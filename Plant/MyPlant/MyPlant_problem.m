function  J_out = MyPlant_problem(Arrayb,parameters,visu)
  % MYPLANT_PROBLEM is a template file to define one's own problem file to
  % be solved with MATLAB.
  % The user can also include a calling to his solver in this file.
  % Several initial conditions can be used.
  % To help understand the commands, we illustrate the commands with
  % Arrayb set to {'1.34','a1+a2*sin(2*pi*1.5*t)'}, for example.
  % This example could correspond to the case where the individual is:
  % {'1.34','s(1)+s(2)*h(1)'}.
  % The values of s(1), s(2) and h(1) are replaced before the evaluation by
  % the values set in the parameter file, see MyPlant_parameters.m
  %
  % Guy Y. Cornejo Maceda, 2022/07/01
  %
  % See also LandauOscillator_problem.

  % Copyright: 2022 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
  % The MIT License (MIT)

%% Parameters
    ActuationLimit = parameters.ProblemParameters.ActuationLimit;
    ActMin = ActuationLimit(:,1);
    ActMax = ActuationLimit(:,2);
    gamma = parameters.ProblemParameters.gamma;
    BadValue = parameters.BadValue;
    RoundEval = parameters.ProblemParameters.RoundEval;
    
%% Control law synthesis
    % Bound the actuation with a clip function.
    BoundArrayb = limit_to(Arrayb,ActuationLimit); 
    % The results of this command is then:
    %   2×1 cell array
    % 
    %     'clip(1.34,-2,2)'
    %     'clip(a1+a2*sin(2*pi*1.5*t),-1,1)'
    
    % Control law
    % The i-th control law is the i-th element of Arrayb.
    bx1=BoundArrayb{1};
    bx2=BoundArrayb{2};
    % Definition
    eval(['b = @(t,a1,a2)[',bx1,';',bx2,'];']);

%% Objective
% Stabilization of the fixed point (for example)

%% Some problem parameters
    % Parameter A
    A = 1;
    % Parameter B
    B = 1;
    % Initial conditions
    initial_conditions = [0;0.1];

%% Resolution parameters
    % Solver
        solver = 'ode5';
    % Time discretization
        % Number of time steps
        N = 500;
        T0 = parameters.ProblemParameters.T0;
        Tmax = parameters.ProblemParameters.Tmax; % frequency=1
        time = linspace(T0,Tmax,N+1);
        TmaxEv = parameters.ProblemParameters.TmaxEv;
        
%% Equation resolution
    % Equations
    % Unforced dynamical system (example)
     DynSys = @(t,a)[(A-a(1).^2-a(2).^2).*a(1)-B*a(2);...
                   (A-a(1).^2-a(2).^2).*a(2)+B*a(1)];
	
    % Controlled dynamical system
 	ConDynSys = @(t,a) (DynSys(t,a) + b(t,a(1),a(2)) +...
        T_maxevaluation(TmaxEv,toc)*[0;0]);

%% Time integration
try
    % Resolution
        tic
        y = feval(solver,ConDynSys,time,initial_conditions);

%% Cost function
    % Ja (example)
    ja = y(:,1).^2+y(:,2).^2;
    Ja = mean(ja);
    % Jb (example)
    % Evaluate the control law -> cell structure
    b_cell = arrayfun(b,time',y(:,1),y(:,2),'UniformOutput',false);
    % Convert in matrix
    b_matrix = cell2mat(transpose(b_cell));
    jb = sum(b_matrix.^2,2);
    Jb = mean(jb);
    % Jc (example)
    Jc = rand;
    J = Ja+gamma(1)*Jb+gamma(2)*Jc;

catch err
    J_out = {BadValue,BadValue,BadValue,BadValue};
    fprintf(err.message);
    fprintf('\n');
    return
end

%% Output
    J_round = round(J,RoundEval);
    Ja_round = round(Ja,RoundEval);
    Jb_round = round(Jb,RoundEval);
    Jc_round = round(Jc,RoundEval);
    J_out = {J_round,Ja_round,Jb_round,Jc_round};

%% Plot
if nargin > 2 && visu
   figure
   % Include your figure here.
end
end
