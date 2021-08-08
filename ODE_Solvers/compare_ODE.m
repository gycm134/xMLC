%% Compare ODE

solvers={'ode1','ode2','ode3','ode4','ode5'};
Nsteps = [10,100,1000,5000,10000];

b={'my_div((-16.55),a2)'};
reso_time = zeros(length(solvers),length(Nsteps));
Ja = zeros(length(solvers),length(Nsteps));
Jb = zeros(length(solvers),length(Nsteps));

% J = Plant(b);
Ja0=0.1129;
% Jb0=6.8305e+07;
Jb0=0;
for n=1:length(solvers)
    solver=solvers{n};
    for p=1:length(Nsteps)
        Nstep=Nsteps(p);
        id=tic;
        js=Plant_solver(b,solver,Nstep);
        ja=js{2};
        jb=js{3};
        reso_time(n,p)=toc(id);
        Ja(n,p)=(ja-Ja0);
        Jb(n,p)=(jb-Jb0);
    end
end

figure
plot(reso_time')
legend(solvers{:})
xlabel 'Nstep'
ylabel 's'
title 'time'

figure
plot(Ja')
legend(solvers{:})
xlabel 'Nstep'
ylabel 'diff'
title 'Ja'

figure
plot(Jb')
legend(solvers{:})
xlabel 'Nstep'
ylabel 'diff'
title 'Jb'