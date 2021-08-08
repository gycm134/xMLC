function  J_out = tanh_problem(b_cell,parameters,visu)
% try
%% Objective
% new objective - stabilization the fixed point

%% Resolution parameters
    % Time discretization
        time_step = parameters.ProblemParameters.dt;
        t0 = parameters.ProblemParameters.T0;
        tmax = parameters.ProblemParameters.Tmax;
        time = t0:time_step:tmax;
        ONE = ones(1,length(time));

%% Control law synthesis
bx=b_cell{1};
% definition
eval(['b = @(T)(',bx,'.*ONE);']);

%% Equation resolution
    % Equations
    tanh_val = tanh(1.256*time)+1.2;
    b_val = b(time);
    Jval = trapz(time,(tanh_val-b_val).^2);
    J_out = {Jval,Jval};

% catch err
%     J_out = {parameters.BadValue,parameters.BadValue};
%     fprintf(err.message);
%     fprintf('\n');
%     return
% end


%% Plot
% bmin = min(parameters.ProblemParameters.ActuationLimit);
% bmax = max(parameters.ProblemParameters.ActuationLimit);
if (nargin > 2) && visu
   figure
     subplot(2,1,1)
       hold on
       plot(time,tanh_val,'r-')
       plot(time,b_val,'b--')
       hold off
       grid on
       ylabel('$\tanh$','Interpreter','latex');
       title('tanh interpolation','Interpreter','latex')
       legend('tanh','interpolation')
       axis([t0-0.1 tmax+.1 -1 3.5])
     subplot(2,1,2)
       plot(time,abs(b_val-tanh_val),'k-')
       grid on
       xlabel('$x$','Interpreter','latex');
       ylabel('$|\tanh(x)-b(x)|$','Interpreter','latex')
       xlim([t0-0.1 tmax+0.1])
       set(gca,'Yscale','log')
end
end
