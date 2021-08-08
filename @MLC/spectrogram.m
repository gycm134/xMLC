function spectrogram(MLC)
    % SPECTROGRAM Plots spetrogram for MLC
    % Shows the spetrogram of the costs over the generations
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also convergence

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

%% Parameters
    NGen = MLC.generation;
    nbins = 150;
    PopSize = MLC.parameters.PopulationSize;
    Jmin=MLC.parameters.ProblemParameters.Jmin;
    Jmax=MLC.parameters.ProblemParameters.Jmax;
    BadValue = MLC.parameters.BadValue;


%% Preallocation
J_gen = zeros(PopSize,NGen);


for p=1:NGen
    J_gen(:,p)=MLC.population(p).costs;
end
if isinf(Jmax)
    Jmax = max(J_gen(J_gen<BadValue));
end
if Jmin<=1e-10
    Jmin = 0.9*min(J_gen(:));
end

    ymin=0.5*Jmin;
ymax=Jmax;
y=linspace(log10(ymin),log10(ymax),nbins);
x=1:NGen;

bin_edges=10.^(y);
Z = zeros(nbins,NGen);
for p=1:NGen
    Z(:,p)=histc(J_gen(:,p),bin_edges);
end



[X,Y]=meshgrid(x,10.^y);
% Z=X.^2+Y.^2;
Zmax = max(max(Z));
%% Plot
    figure
    surf(X,Y,Z,'edgecolor','none')
    view(2)

    hold on
    plot3(1:NGen,J_gen(1,:),Zmax*ones(1,NGen),'r--','LineWidth',1.5);
    if MLC.parameters.ProblemParameters.Jmin>1e-10
        plot3([1,NGen],Jmin*[1 1],[Zmax Zmax],'b-','LineWidth',1.5);
    end
    hold off
    % legend
        axis([1 NGen Jmin Jmax])
        xlabel('$n$','Interpreter','latex')
        ylabel('$log(J)$','Interpreter','latex')
        grid on
        box on
        axis tight
        set(gca,'Yscale','log')


% color
    wb=linspace(1,0,64);
    cmp=[wb',wb',wb'];
    colormap(cmp);
