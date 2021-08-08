function  J_out = FixedPoint_problem(Arrayb,parameters,visu)
  % TOY_PROBLEM stabilization of a fixed point.
  % Several initial conditions can be used.
  %
  % Guy Y. Cornejo Maceda, 03/23/2020
  %
  % See also read, GMFM_problem

  % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
  % CC-BY-SA

%% Parameters
    ActuationLimit = parameters.ProblemParameters.ActuationLimit;
    ActMin = min(ActuationLimit);
    ActMax = max(ActuationLimit);
    gamma = parameters.ProblemParameters.gamma;
    
%% Control law synthesis
% control law
% The i-th control law is the i-th element of Arrayb.
bx=Arrayb{1};
% definition
% actuation bound is done with the tresh function
eval(['b = @(t,a1,a2)(' bx ');']);

%% Objective
% new objective - stabilization the fixed point

%% Oscillator parameters
    % Initial growth rate
    R2 = 1;
%     R2 = 1;
    %Frequency
    omega = 1;

%% Resolution parameters
    % Time discretization
        solver = 'ode5';
        NPointsPeriod = parameters.ProblemParameters.NPointsPeriod; % 50
        NPeriods = parameters.ProblemParameters.NPeriods; % 10
        N = NPointsPeriod*NPeriods;
    % time resolution
        T0 = parameters.ProblemParameters.T0;
        Tmax = parameters.ProblemParameters.Tmax; % frequecy=1
        time = linspace(T0,Tmax,N+1);
        lastperiod = (N+1-NPointsPeriod):(N+1);
    % Initial conditions
        IC = parameters.ProblemParameters.InitialCondition; % [1 0;0 1;-1 0;0 -1]
        ICC = {'g','r','k','b'};

%% Equation resolution
    % Equations
  DynSys = @(t,a)[(R2-a(1).^2-a(2).^2).*a(1)-omega*a(2);...
                  (R2-a(1).^2-a(2).^2).*a(2)+omega*a(1)];
	TmaxEv = parameters.ProblemParameters.TmaxEv;
	% ConDynSys = @(t,a) (DynSys(t,a) + [0;b(t,a(1),a(2))]);
	ConDynSys = @(t,a) (DynSys(t,a) + [0;b(t,a(1),a(2))] + T_maxevaluation(TmaxEv,toc)*[0;0]);

    % Preallocation
    A = zeros(N+1,2,size(IC,1));
    ja = zeros(N+1,size(IC,1));
    jb = zeros(N+1,size(IC,1));
    Ja = zeros(N+1,size(IC,1));
    Jb = zeros(N+1,size(IC,1));
    Jc = zeros(size(IC,1),1);
    J = zeros(N+1,size(IC,1));

%% Time integration
try
for p=1:size(IC,1)
    % Resolution
        % Initial condition
        a0 = IC(p,:);
	      tic
        y = feval(solver,ConDynSys,time,a0);

    % Solution
        A(:,:,p) = y;

%% Cost function
    % Ja
    ja(:,p) = A(:,1,p).^2+A(:,2,p).^2;
    Ja(:,p) = cumtrapz(time,ja(:,p))/size(IC,1);
    % Jb
    jb(:,p) = arrayfun(b,time',A(:,1,p),A(:,2,p)).^2;
    Jb(:,p) = cumtrapz(time,jb(:,p))/size(IC,1);
    J(:,p) = Ja(:,p) + gamma.*Jb(:,p);

% converged or not
Jc(p) = max(A(end-NPointsPeriod:end,1,p).^2+A(end-NPointsPeriod:end,2,p).^2)<10^(-4);

end
catch err
    J_out = {parameters.BadValue,parameters.BadValue,parameters.BadValue};
    fprintf(err.message);
    fprintf('\n');
    return
end

%% Output
J_round = round(sum(J(end,:)),parameters.ProblemParameters.RoundEval);
Ja_round = round(sum(Ja(end,:)),parameters.ProblemParameters.RoundEval);
Jb_round = round(sum(Jb(end,:)),parameters.ProblemParameters.RoundEval);
J_out = {J_round,Ja_round,Jb_round,logical(prod(double(Jc)))};

%% Plot
LW=1.5;
if nargin > 2 && visu
   figure
   for p=1:size(IC,1)
   subplot(2,2,1) % a1-a2
       hold on
       plot(A(:,1,p),A(:,2,p),[ICC{p} '-'],'LineWidth',LW)
       plot(A(1,1,p),A(1,2,p),[ICC{p} 'o'],'LineWidth',LW);
       plot(A(end,1,p),A(end,2,p),[ICC{p} '*'],'LineWidth',LW);
       hold off
       grid on
       box on
       ylabel('$a_2$','Interpreter','latex');
       xlabel('$a_1$','Interpreter','latex');
       title('Phase space')
       axis(sqrt(R2)*[-1.5 1.5 -1.25 1.25])

   subplot(2,2,2) % b
       hold on
       plot(time,arrayfun(b,time',A(:,1,p),A(:,2,p)),[ICC{p} '-'],'LineWidth',LW)
       hold off
       grid on
       box on
       ylabel ('$b$','Interpreter','latex');
       xlabel ('$t$','Interpreter','latex');
       title('Actuation');
       ActLim = parameters.ProblemParameters.ActuationLimit;
       MinAct = ActLim(1);
       MaxAct = ActLim(2);
       axis([0,time(end),MinAct,MaxAct])

   subplot(2,2,3) % J
       hold on
       J0 = parameters.ProblemParameters.J0;
       plot(time,J(:,p)/J0,[ICC{p} '-'],'LineWidth',LW)
       plot(time,sum(J,2)/J0,'k-','LineWidth',LW)
       text(time(end),sum(J(end,:))/J0,num2str(sum(J(end,:))/J0,2))
       hold off
       grid on
       box on
       ylabel ('$j(t)$','Interpreter','latex');
       xlabel ('$t$','Interpreter','latex');
       title('Cost function');
       axis([0,time(end),-0.1*max(sum(J,2))/J0,1.25*max(sum(J,2))/J0])

   subplot(2,2,4) % r
       hold on
       plot(time,sqrt(A(:,1,p).^2+A(:,2,p).^2),[ICC{p} '-'],'LineWidth',LW)
       hold off
       grid on
       box on
       ylabel ('$r(t)$','Interpreter','latex');
       xlabel ('$t$','Interpreter','latex');
       title('Radius')
       axis([0 time(end) -0.1 1.25*sqrt(R2)])
   end

   % control law visualisation
    % Meshgrid
    ra=sqrt(R2)*1.5;
    Aa1=-ra:0.01:ra;
    Aa2=-ra:0.01:ra;
    [aa1,aa2]=meshgrid(Aa1,Aa2);

    % Plot
    figure;
    hold on
    B=arrayfun(b,0*aa1,aa1,aa2);

    % imagesc(B);
    h = imagesc(Aa1,Aa2,B);
    colorbar

    % colormap
    zto = linspace(0,1,1024)';
    rwb = [vertcat(ones(1024,1),flip(zto)),vertcat(zto,flip(zto)),vertcat(zto,ones(1024,1))];
    colormap(flipud(rwb))
    caxis([-1 1])

    % labels
    xlabel('$a_1$','Interpreter','latex')
    ylabel('$a_2$','Interpreter','latex')
    title(Arrayb{1},'Interpreter','latex')
    axis([-ra ra -ra ra])
    for p=1:4
       plot(A(:,1,p),A(:,2,p),'k-')
       plot(A(1,1,p),A(1,2,p),'ko');
    end
end
end
