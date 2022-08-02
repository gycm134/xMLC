function  J_out = LandauOscillator_problem(Arrayb,parameters,visu)
  % LANDAUOSCILLATOR_PROBLEM stabilization of a fixed point.
  % Several initial conditions can be used.
  %
  % Guy Y. Cornejo Maceda, 2022/07/01
  %
  % See also read, GMFM_problem

  % Copyright: 2022 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
  % The MIT License (MIT)

%% MATLAB options
    % Version
    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
    
%% Parameters
    ActuationLimit = parameters.ProblemParameters.ActuationLimit;
    ActMin = min(ActuationLimit);
    ActMax = max(ActuationLimit);
    gamma = parameters.ProblemParameters.gamma;
    
%% Control law synthesis
% Bound the actuation
BoundArrayb = limit_to(Arrayb,ActuationLimit); 
% Control law
% The i-th control law is the i-th element of Arrayb.
bx=BoundArrayb{1};
% Definition
% Actuation bound is done with the tresh function
eval(['b = @(t,a1,a2)(' bx ');']);

%% Objective
% new objective - stabilization the fixed point

%% Oscillator parameters
    % Initial growth rate
    R2 = 1;
    %Frequency
    omega = 1;

%% Resolution parameters
    % Time discretization
        solver = 'ode5';
        NPointsPeriod = 100;%parameters.ProblemParameters.NPointsPeriod; % 50
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
    Ja(:,p) = cumtrapz(time',ja(:,p))/size(IC,1);
    % Jb
    jb(:,p) = arrayfun(b,time',A(:,1,p),A(:,2,p)).^2;
    Jb(:,p) = cumtrapz(time',jb(:,p))/size(IC,1);
    J(:,p) = Ja(:,p) + gamma.*Jb(:,p);

%catch err
end
    J_out = {parameters.BadValue,parameters.BadValue,parameters.BadValue};
    fprintf(err.message);
    fprintf('\n');
    return
end

%% Output
if isOctave
  RE = parameters.ProblemParameters.RoundEval;
  J_round = round(10^(RE)*sum(J(end,:)))/10^(RE);
  Ja_round = round(10^(RE)*sum(Ja(end,:)))/10^(RE); 
  Jb_round = round(10^(RE)*sum(Jb(end,:)))/10^(RE);
  else
  J_round = round(sum(J(end,:)),parameters.ProblemParameters.RoundEval);
  Ja_round = round(sum(Ja(end,:)),parameters.ProblemParameters.RoundEval);
  Jb_round = round(sum(Jb(end,:)),parameters.ProblemParameters.RoundEval);
end
  J_out = {J_round,Ja_round,Jb_round};

%% Plot
LW=1.25;
FS = 10;
if nargin > 2 && visu
   figure('Position',[487,285,451,420])
   for p=1:size(IC,1)
   subplot(2,2,1) % a1-a2
       hold on
       plot(A(:,1,p),A(:,2,p),[ICC{p} '-'],'LineWidth',LW)
       plot(A(1,1,p),A(1,2,p),[ICC{p} 'o'],'LineWidth',LW);
       plot(A(end,1,p),A(end,2,p),[ICC{p} '.'],'MarkerSize',15);
       hold off
       grid on
       box on
       ylabel('$a_2$','Interpreter','latex');
       xlabel('$a_1$','Interpreter','latex');
       title('Phase space')
       axis(sqrt(R2)*[-1.5 1.5 -1.5 1.5])
       set(gca,'FontSize',FS)
       set(gca,'DataAspectRatio',[1,1,1])
       set(gca,'TickDir','in')
       set(gca,'GridLineStyle','--')
       
   subplot(2,2,2) % b
       hold on
       plot(time,arrayfun(b,time',A(:,1,p),A(:,2,p)),[ICC{p} '-'],'LineWidth',LW)
       hold off
       grid on
       box on
       ylabel ('$b$','Interpreter','latex');
       xlabel ('$t$','Interpreter','latex');
       title('Actuation');
       axis([0,time(end),1.1*ActMin,1.1*ActMax])
%       xticks([0,25,50])
       set(gca,'xtick',[0,25,50])
       set(gca,'FontSize',FS)
       set(gca,'DataAspectRatio',[1/(ActMax-ActMin),1/time(end),1])
       set(gca,'TickDir','in')
       set(gca,'GridLineStyle','--')
       
   subplot(2,2,3) % J
       hold on
       J0 = parameters.ProblemParameters.J0;
       plot(time,sum(J,2)/J0,'k-','LineWidth',LW)
       text(time(end),sum(J(end,:))/J0,num2str(sum(J(end,:))/J0,2))
       hold off
       grid on
       box on
       ylabel ('$j(t)$','Interpreter','latex');
       xlabel ('$t$','Interpreter','latex');
       title('Cost function');
       jmax = 1.25*max(sum(J,2))/J0;
       axis([0,time(end),0,jmax])
       set(gca,'xtick',[0,25,50])
%       xticks([0,25,50])
       set(gca,'FontSize',FS)
       set(gca,'DataAspectRatio',[1/jmax,1/time(end),1])
       set(gca,'TickDir','in')
       set(gca,'GridLineStyle','--')
       
   subplot(2,2,4) % r
       hold on
       plot(time,sqrt(A(:,1,p).^2+A(:,2,p).^2),[ICC{p} '-'],'LineWidth',LW)
       hold off
       grid on
       box on
       ylabel ('$r(t)$','Interpreter','latex');
       xlabel ('$t$','Interpreter','latex');
       title('Radius')
       axis([0 time(end) 0 1])
       set(gca,'xtick',[0,25,50])
%       xticks([0,25,50])
       set(gca,'ytick',[0:0.25:1])
%       yticks([0:0.25:1])
       set(gca,'FontSize',FS)
       set(gca,'DataAspectRatio',[1,1/time(end),1])
       set(gca,'TickDir','in')
       set(gca,'GridLineStyle','--')
   end

   % Control law visualisation
    % Meshgrid
    ra=sqrt(R2)*1.5;
    Aa1=-ra:0.01:ra;
    Aa2=-ra:0.01:ra;
    [aa1,aa2]=meshgrid(Aa1,Aa2);

    % Plot
    figure('Position',[371,369,520,420])
    hold on
    box off
    B=arrayfun(b,0*aa1,aa1,aa2);

    % imagesc(B);
    h = imagesc(Aa1,Aa2,B);
    cb=colorbar;
    if not(isOctave)
      cb.Ticks=[-1:0.5:1];
    end

    % colormap
    zto = linspace(0,1,1024)';
    rwb = [vertcat(ones(1024,1),flip(zto)),vertcat(zto,flip(zto)),vertcat(zto,ones(1024,1))];
    colormap(flipud(rwb))
    caxis([-1 1])

    % labels
    xlabel('$a_1$','Interpreter','latex')
    ylabel('$a_2$','Interpreter','latex')
    axis([-ra ra -ra ra])
    for p=1:4
       plot(A(:,1,p),A(:,2,p),'k-','LineWidth',LW)
       plot(A(1,1,p),A(1,2,p),[ICC{p} 'o'],'LineWidth',LW);
       plot(A(end,1,p),A(end,2,p),[ICC{p} '.'],'MarkerSize',15);
    end
    grid on
    set(gca,'FontSize',FS)
    set(gca,'DataAspectRatio',[1,1,1])
end
end
