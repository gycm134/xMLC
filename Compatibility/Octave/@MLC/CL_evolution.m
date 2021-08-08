function CL_evolution(MLC,SensorsRange)
    % Sensors, operations and constants distribution through the population and
    % the generations
    %
    % Guy Y. Cornejo Maceda, 01/24/2020


    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

%% Parameters
    PopSize = MLC.parameters.PopulationSize;
    InputNumber = MLC.parameters.ProblemParameters.InputNumber;
    VarRegNumber = MLC.parameters.ControlLaw.VarRegNumber;
    OperatorIndices = MLC.parameters.ControlLaw.OperatorIndices;
        maxOI = max(OperatorIndices);
    OutputNumber = MLC.parameters.ProblemParameters.OutputNumber;
    GENS = 1:MLC.generation;
    NGEN = numel(GENS);
    CstRegNumber = MLC.parameters.ControlLaw.CstRegNumber;
    FS = 10;
    LW = 1.5;
    % Sensors range
    if nargin<2,SensorsRange=1:InputNumber;end
    NSensors = numel(SensorsRange);
    % Operator marker
    OpMarker = {'+','-','x','/','sin','cos','ln','e','tanh'};
    % No figures
%    set(0,'DefaultFigureVisible','off');
    % close all
%% Extract data
    % Initialization
        SensorsTab = zeros(NGEN,PopSize,OutputNumber,InputNumber);
        OperatorsTab = zeros(NGEN,PopSize,OutputNumber,maxOI);
        ConstantsTab = zeros(NGEN,PopSize,CstRegNumber);

cmpt = 1;
for gen = GENS
    for ind=1:PopSize
        label = MLC.population(gen).individuals(ind);
        control_law = MLC.table.individuals(label).control_law;
        chromosome = MLC.table.individuals(label).chromosome;
        [~,~,submat] = exclude_introns(MLC.parameters,chromosome);
        % Sensors
        for p=1:InputNumber
            NS = strfind(control_law,['s(',num2str(p),')']);
            for c=1:OutputNumber
                SensorsTab(cmpt,ind,c,p) = size(NS{c},2);
            end
        end
        % Operators
        for p=OperatorIndices
            for c=1:OutputNumber
                SM = submat{c};
                OperatorsTab(cmpt,ind,c,p) = sum(SM(:,1)==p);
            end
        end
        % Constant
        for p=1:CstRegNumber
            for c=1:OutputNumber
                SM = submat{c};
                ConstantsTab(cmpt,ind,p) = sum(sum(SM(:,3:4)==VarRegNumber+p));
            end
        end
    end
    cmpt = cmpt+1;
end

%% Plot Sensors
    ST = SensorsTab;
    % Sum over the inputs
    ST = sum(ST,3);
    % Select only the ones needed
    STPart = ST(:,:,:,SensorsRange);
    % Reshape
    SSGenPart = transpose(reshape(STPart,NGEN,[]));

%% Matrix Sensor-Generation
    figure
    set(gcf, 'Position', [1000 0 600 750])
    set(gcf,'color','w')
    % Image
    imagesc(-0.5+[1,NGEN],[0.05*10/PopSize,NSensors-0.05*10/PopSize],SSGenPart)
    % Colormap and axis
        colormap( flip( hot( max(SSGenPart(:))+1 ) ) )
        colorbar
        axis([0,NGEN,0,NSensors])
        grid on
        caxis([0,max(max(SSGenPart))])
        colorbar('XTick', 0:(max(max(SSGenPart))));
%     Ticks
        ax = gca;
        set(gca,'GridColor','black','GridAlpha',0.5);
        % x
%         ax.XAxis.MinorTick = 'on';
%         ax.XAxis.MinorTickValues = 0:NGEN;    
%         ax.XMinorGrid = 'on';
        set(gca,'xtick',0:NGEN)
        set(gca,'xticklabel',0:NGEN)
        % y
%         ax.YAxis.MinorTick = 'on';
%         ax.YAxis.MinorTickValues = 0:NSensors;    
%         ax.YMinorGrid = 'on';
        set(gca,'ytick',0:NSensors)
        set(gca,'xticklabel',[])
    % Labels
        xlabel('Generation','Interpreter','latex')
        ylabel('Sensor','Interpreter','latex')
        title('Sensors/Generations','Interpreter','latex')
    % Sensors
    for sp=1:NSensors
      text(-.5,sp-0.5,['s',num2str(SensorsRange(sp))],...
          'Interpreter','latex','FontSize',2*FS,...
          'HorizontalAlignment','center',...
          'VerticalAlignment','top')
    end
    % Aspect and position
        set(gca,'DataAspectRatio',[NGEN NSensors/1.5 1]);
        set(gca,'FontSize',FS)
        set(gca,'LineWidth',LW)
    % Export
        % FigName = ['save_runs/',Name,'/Figures/Gen',num2str(geni),'SensorsDistrib'];
        % print(FigName,'-dpng')
        % close
      