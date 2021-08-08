function J_out=GMFM_problem(Arrayb,parameters,visu)
    % GMFM_noise stabilization
    % The function GMFM_problem computes the cost of the actuation b for the
    % GMFM (Generalized Mean-Field Model)
    % The input is the string expression of the control law in a cell.
    % Examples : Arrayb = {'0'};
    %            Arrayb = {'cos(10*t)'};
    %            Arrayb = {'a1^2'};
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also read, mat2lisp, simplify_my_LISP.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

%% Parameters
    ActuationLimit = parameters.ProblemParameters.ActuationLimit;
    ActMin = min(ActuationLimit);
    ActMax = max(ActuationLimit);
    gamma = parameters.ProblemParameters.gamma; %penalization coefficient
    % Version
    IsOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
    
%% Control law synthesis
% bound the actuation
BoundArrayb = limit_to(Arrayb,ActuationLimit); 
% control law
% The i-th control law is the i-th element of Arrayb.
bx=BoundArrayb{1};
% definition
% actuation bound is done with the tresh function
eval(['b = @(t,a1,a2,a3,a4)(' bx ');']);

%% Objective
% new objective - stabilization the first oscillator at (0,0)

%% Resolution parameters
    % Time discretization
        solver = 'ode5';
        NPointsPeriod = parameters.ProblemParameters.NPointsPeriod;
        NPeriods = parameters.ProblemParameters.NPeriods;
        N = NPointsPeriod*NPeriods;
    % time resolution
        T0 = parameters.ProblemParameters.T0;
        Tmax = parameters.ProblemParameters.Tmax;
        time = linspace(T0,Tmax,N+1);
        lastperiod = (N+1-NPointsPeriod):(N+1);
    % Initial condition
        a0 = parameters.ProblemParameters.InitialCondition; 

%% Equation resolution
    % Equations
        % sigma
    sigma = '(0.1-a(1).^2-a(2).^2-a(3).^2-a(4).^2)';
        % F
    a1_dot = [sigma '.*a(1)-a(2)'];
    a2_dot = [sigma '.*a(2)+a(1)'];
    a3_dot = ['-0.1.*a(3)-10.*a(4)'];
    a4_dot = ['-0.1.*a(4)+10.*a(3)'];
    eval(['GMFM=@(t,a)[',a1_dot,';',a2_dot,';',a3_dot,';',a4_dot,'];']);
    TmaxEv = parameters.ProblemParameters.TmaxEv;
    tic;
    ConGMFM = @(t,a) (GMFM(t,a)+[0;0;0;b(t,a(1),a(2),a(3),a(4))] + T_maxevaluation(TmaxEv,toc)*[0;0;0;0]);

%% Time integration
try
    % Resolution
        sol = feval(solver,ConGMFM,time,a0);

    % Solution
        a1 = sol(:,1);
        a2 = sol(:,2);
        a3 = sol(:,3);
        a4 = sol(:,4);

%% Cost function
    % Ja - Fluctuation level of the first oscillator
    ja = a1.^2 + a2.^2;
    Ja = mean(ja);
    % Jb - Actuation energy
    bf = arrayfun(b,time',a1,a2,a3,a4);
    jb = bf.^2;
    Jb = mean(jb);%./time;
    % J = Ja+gammaJb
    J = Ja + gamma(1)*Jb;

%% Output
    % first cylinder converged to 0 or not (at 10^-2)
    Jc = max(a1(end-NPointsPeriod:end).^2+a2(end-NPointsPeriod:end).^2)<10^(-4);
    J_out = {J,Ja,Jb,Jc};

catch err
    J_out = {parameters.BadValue,parameters.BadValue,parameters.BadValue,0};
    fprintf(err.message);
    fprintf('\n');
    return
end

%% Plot
LW=1.5;
FS = 15;
if nargin > 2 && visu
figure
set(gcf,'position',[0,0,750,550])
    subplot(3,2,1)
        hold on
        plot(time,bf,'k-','LineWidth',LW)
        plot(time(lastperiod),bf(lastperiod),'r-','LineWidth',LW)
        hold off
        if IsOctave
          xlabel('t','Interpreter','latex')
          ylabel('b','Interpreter','latex')
        else
          xlabel('$t$','Interpreter','latex')
          ylabel('$b$','Interpreter','latex')
        end       
        box on
        grid on
        DAct = ActMax-ActMin;
        axis([0,Tmax,ActMin,ActMax])
        set(gca,'xtick',[0,Tmax/2,Tmax])
        set(gca,'xticklabel',{'0',[num2str(NPeriods/2),'T'],[num2str(NPeriods),'T']})
        set(gca,'FontSize',FS)
        
    subplot(3,2,2)
        sigm = 0.1-a1.^2-a2.^2-a3.^2-a4.^2;
        hold on
        plot(time,sigm,'k-','Linewidth',LW)
        plot(time(lastperiod),sigm(lastperiod),'r-','LineWidth',LW)   
        hold off
        if IsOctave
          xlabel('t','Interpreter','latex')
          ylabel('sigma','Interpreter','latex')
        else
          xlabel('$t$','Interpreter','latex')
          ylabel('$\sigma$','Interpreter','latex')
        end
        box on
        grid on
        SigmMax = max(sigm);
        SigmMin = min(sigm);
        DSigm = SigmMax-SigmMin;
        if DSigm < 10^(-5)
            axis([0,Tmax,-1,1])
        else
            axis([0,Tmax,SigmMin-0.05*DSigm,SigmMax+0.05*DSigm])
        end
        set(gca,'xtick',[0,Tmax/2,Tmax])
        set(gca,'xticklabel',{'0',[num2str(NPeriods/2),'T'],[num2str(NPeriods),'T']})
        set(gca,'FontSize',FS)

    subplot(3,2,[3,5])
        hold on
        plot(a1,a2,'k-','Linewidth',LW)
        plot(a1(1),a2(1),'ro','Linewidth',LW)
        plot(a1(lastperiod),a2(lastperiod),'r-','Linewidth',LW)
        plot(a1(end),a2(end),'r.','MarkerSize',20)
        hold off
        if IsOctave
          xlabel('a1','Interpreter','latex')
          ylabel('a2','Interpreter','latex')
        else
          xlabel('$a_1$','Interpreter','latex')
          ylabel('$a_2$','Interpreter','latex')
        end
        xlim([min([-0.4;a1]) max([0.4;a1])])
        ylim([min([-0.4;a2]) max([0.4;a2])])
        box on
        grid on
        set(gca,'DataAspectRatio',[1,1,1])
        %
        AM = 0.5;
        am = max([max(a1),max(a2)]);
        if am>AM, AM=1.2*am;end
        axis(AM*[-1 1 -1 1])
        xt = [-AM -sqrt(0.1) 0 sqrt(0.1) AM];
        yt = [-AM 0 AM];
        set(gca,'xtick',xt);
        set(gca,'ytick',xt);
        set(gca,'xticklabel',{'-0.5','-r_1','0','r_1','0.5'});
        set(gca,'yticklabel',{'-0.5','-r_1','0','r_1','0.5'});
        set(gca,'FontSize',FS)
    
    subplot(3,2,[4,6])
        hold on
        plot(a3,a4,'k-','Linewidth',LW)
        plot(a3(1),a4(1),'ro','Linewidth',LW)
        plot(a3(lastperiod),a4(lastperiod),'r-','Linewidth',LW)
        plot(a3(end),a4(end),'r.','MarkerSize',20)
        hold off
        if IsOctave
          xlabel('a3','Interpreter','latex')
          ylabel('a4','Interpreter','latex')
        else
          xlabel('$a_3$','Interpreter','latex')
          ylabel('$a_4$','Interpreter','latex')
        end
        xlim([min([-0.4;a3]) max([0.4;a3])])
        ylim([min([-0.4;a4]) max([0.4;a4])])
        box on
        grid on
        set(gca,'DataAspectRatio',[1,1,1])
        set(gca,'FontSize',FS)
end

end