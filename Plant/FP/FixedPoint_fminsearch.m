% fminsearch
%% Parameters
    Problem = 'FixedPointbb';
    InitCond = [1,-1];
%     InitCond = 1;
    eval(['parameters = ',Problem,'_parameters();'])
    % Problem parameters
    parameters.ProblemParameters.gamma=0;
    parameters.ProblemParameters.InitialCondition = [1,0;0,1;-1,0;0,-1];
    
%% Initilization
    % Create problem
    eval(['Plant=@',Problem,'_problem;'])
    % cst
%     funaux = @(x)Plant({[num2str(round(x,3)),'*(a1+a2)']},parameters,0);
%     funplot = @(x)Plant({[num2str(round(x,3)),'*(a1+a2)']},parameters,1);
    % line
    funaux = @(x)Plant({[num2str(round(x(1),3)),'*a1','+',num2str(round(x(2),3)),'*a2']},parameters,0);
    funplot = @(x)Plant({[num2str(round(x(1),3)),'*a1','+',num2str(round(x(2),3)),'*a2']},parameters,1);
    % definition
    cellfirst = @(v)v{1};
    fun = @(x)cellfirst(funaux(x));
%     fun = @(x)100*(x(2) - x(1)^2)^2 + (1 - x(1))^2; % example
    
%% Solve with fminsearch
    % Options
    options = optimset('PlotFcns',@optimplotfval);
    % Solve
    sol=fminsearch(fun,InitCond,options);
    
%% Plot solution
    
% Solutions - 0.1:
% FP_cst   : -0.6180            J=0.2780
% FP_line  = [ 7.7550   -7.8780 ]; %  J=0.0587
% FPbb_cst : -0.9125            J=0.1088
% FPbb_line: 1.08000  -9.178 0  J=0.0581

% Solutions - 1:
% FP_cst   : -0.6180            J=
% FP_line  = [8.2404   -7.1731]; %  J=1.2739
% FPbb_cst : -0.9125            J=
FPbb_line= [4.2424  -16.5037 ]; %J=0.9631


    funplot(FPbb_line)
