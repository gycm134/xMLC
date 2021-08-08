function CL_descriptions(MLC,GENS)
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
    NGEN = length(GENS);
    CstRegNumber = MLC.parameters.ControlLaw.CstRegNumber;
    FS = 10;
    LW = 1.5;
    Name = MLC.parameters.Name;
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
cmpt = 1;
for geni = GENS
    SSi = reshape(SensorsTab(cmpt,:,:,:),[],InputNumber);
    MAXSS1_plus1 = max(sum(SSi,1))+1;
    MAXSS2_plus1 = max(sum(SSi,2))+1;

    % Dimensions
%     NColumns = MAXSS2_plus1+InputNumber;
%         C1 = 1:(MAXSS2_plus1);
%         C2 = (MAXSS2_plus1+1):NColumns;
%         R1 = transpose(1:PopSize);
%         R2 = PopSize+1;
%     NRows = PopSize+1;

% Number of sensors per control law
    figure
    set(gcf, 'Position', [500 0 500 750])
    set(gcf,'color','w')
    % Bar
    barb=barh(-0.5+(1:PopSize),sum(SSi,2),1);
    % Colormap and axis
        barb.FaceColor='flat';
%         CMP = flip(hot(MAXSS2_plus1)); % For future versions
        barb.FaceColor = [1,0,0];
        colormap( flip( hot( max(SSi(:))+1 ) ) )
        axis([0,MAXSS2_plus1,0,PopSize])
        grid on
    % Ticks
        ax = gca;
        set(gca,'GridColor','black','GridAlpha',0.5);
        % x
        ax.XAxis.MinorTick = 'on';
        ax.XAxis.MinorTickValues = 0:5*ceil(MAXSS2_plus1/5);    
        ax.XMinorGrid = 'on';
        xticks(0:5:5*ceil(MAXSS2_plus1/5))
        xticklabels(0:5:5*ceil(MAXSS2_plus1/5))
        % y
        ax.YAxis.MinorTick = 'on';
        ax.YAxis.MinorTickValues = 0:PopSize;    
        ax.YMinorGrid = 'on';
        yticks(0:5:PopSize)
        yticklabels(0:5:PopSize)
    % Labels
        xlabel('\#sensor','Interpreter','latex')
        ylabel('Individual','Interpreter','latex')
        set(gca, 'YDir', 'reverse')
        title(['\#sensor per individual - Gen ',num2str(geni)],'Interpreter','latex')
    % Aspect and position
        set(gca,'DataAspectRatio',[MAXSS2_plus1 PopSize/1.5 1]);
        set(gca,'FontSize',FS)
        set(gca,'LineWidth',LW)
    % Export
        % FigName = ['save_runs/',Name,'/Figures/Gen',num2str(geni),'SensorsIndiv'];
        % print(FigName,'-dpng')
        % close
        
%% Matrix
    figure
    set(gcf, 'Position', [1000 0 600 750])
    set(gcf,'color','w')
    % Image
    imagesc(-0.5+[1,InputNumber],-0.5+[1,PopSize],SSi)
    % Colormap and axis
        colormap( flip( hot( max(SSi(:))+1 ) ) )
        colorbar
        axis([0,InputNumber,0,PopSize])
        grid on
        caxis([0,max(max(SSi))])
        colorbar('XTick', 0:(max(max(SSi))));
    % Ticks
        ax = gca;
        set(gca,'GridColor','black','GridAlpha',0.5);
        % x
        ax.XAxis.MinorTick = 'on';
        ax.XAxis.MinorTickValues = 0:InputNumber;    
        ax.XMinorGrid = 'on';
        xticks(0:5:InputNumber)
        xticklabels(0:5:InputNumber)
        % y
        ax.YAxis.MinorTick = 'on';
        ax.YAxis.MinorTickValues = 0:PopSize;    
        ax.YMinorGrid = 'on';
        yticks(0:5:PopSize)
        yticklabels(0:5:PopSize)
    % Labels
        xlabel('Sensor','Interpreter','latex')
        ylabel('Individual','Interpreter','latex')
        title(['Sensor distribution - Gen ',num2str(geni)],'Interpreter','latex')
    % Sensors
    for sp=1:InputNumber
      text(sp-0.5,PopSize,['$s_{',num2str(sp),'}$'],...
          'Interpreter','latex','FontSize',2*FS,...
          'HorizontalAlignment','center',...
          'VerticalAlignment','top')
    end
%      text(sp/2,PopSize*1.1,'sensor',...
%          'Interpreter','latex','FontSize',FS,...
%          'HorizontalAlignment','center',...
%          'VerticalAlignment','cap')
    % Aspect and position
        set(gca,'DataAspectRatio',[InputNumber PopSize/1.5 1]);
        set(gca,'FontSize',FS)
        set(gca,'LineWidth',LW)
    % Export
        % FigName = ['save_runs/',Name,'/Figures/Gen',num2str(geni),'SensorsDistrib'];
        % print(FigName,'-dpng')
        % close
      
%% Number of sensors for each sensor
    figure
    set(gcf, 'Position', [0 0 500 500])
    set(gcf,'color','w')
    % Bar
    barb=bar(-0.5+(1:InputNumber),sum(SSi,1),0.5);
    % Colormap and axis
        barb.FaceColor='flat';
%         CMP = flip(hot(MAXSS1_plus1));
        barb.FaceColor = [0,0,0];
        colormap( flip( hot( max(SSi(:))+1 ) ) )
        axis([0,InputNumber,0,MAXSS1_plus1])
        grid on
    % Ticks
        ax = gca;
        set(gca,'GridColor','black','GridAlpha',0.5);
        % x
        ax.XAxis.MinorTick = 'on';
        ax.XAxis.MinorTickValues = 0:InputNumber;    
        ax.XMinorGrid = 'on';
        xticks(0:5:InputNumber)
        xticklabels(0:5:InputNumber)
        % y
        ax.YAxis.MinorTick = 'on';
        ax.YAxis.MinorTickValues = 0:5*floor(MAXSS1_plus1/5);    
        ax.YMinorGrid = 'on';
        yticks(0:5:5*floor(MAXSS1_plus1/5))
        yticklabels(0:5:5*floor(MAXSS1_plus1/5))
    % Labels
        xlabel('Sensor','Interpreter','latex')
        ylabel('\#use','Interpreter','latex')
        title(['\#use - Gen ',num2str(geni)],'Interpreter','latex')
    % Sensors
    for sp=1:InputNumber
      text(sp-0.5,0,['$s_{',num2str(sp),'}$'],...
          'Interpreter','latex','FontSize',2*FS,...
          'HorizontalAlignment','center',...
          'VerticalAlignment','top')
    end
%      text(sp/2,0,'sensor',...
%          'Interpreter','latex','FontSize',FS,...
%          'HorizontalAlignment','center',...
%          'VerticalAlignment','cap')
    % Aspect and position
    set(gca,'DataAspectRatio',[InputNumber MAXSS1_plus1 1]);
        set(gca,'FontSize',FS)
        set(gca,'LineWidth',LW)
    % Export
        % FigName = ['save_runs/',Name,'/Figures/Gen',num2str(geni),'TotalSensors'];
        % print(FigName,'-dpng')
        % close        
    cmpt = cmpt+1;
end

%% Plot Operators
cmpt = 1;
for geni = GENS
    OTi = reshape(OperatorsTab(cmpt,:,:,:),[],maxOI);
    MAXSS1_plus1 = max(sum(OTi,1))+1;
    MAXSS2_plus1 = max(sum(OTi,2))+1;

    % Dimensions
%     NColumns = MAXSS2_plus1+numel(OperatorIndices);
%         C1 = 1:(MAXSS2_plus1);
%         C2 = (MAXSS2_plus1+1):NColumns;
%         R1 = transpose(1:PopSize);
%         R2 = PopSize+1;
%     NRows = PopSize+1;

%% Number of operators per individual
    figure
    set(gcf, 'Position', [500 0  500 750])
    set(gcf,'color','w')
    % Bar
        barb=barh(-0.5+(1:PopSize),sum(OTi,2),1);
    % Colormap and axis
        barb.FaceColor='flat';
%         CMP = flip(hot(MAXSS2_plus1));
        barb.FaceColor = [1,0,0];   
        colormap( flip( hot( max(OTi(:))+1 ) ) )
        axis([0,MAXSS2_plus1,0,PopSize])
        grid on
    % Ticks
        ax = gca;
        set(gca,'GridColor','black','GridAlpha',0.5);
        % x
        ax.XAxis.MinorTick = 'on';
        ax.XAxis.MinorTickValues = 0:5*ceil(MAXSS2_plus1/5);    
        ax.XMinorGrid = 'on';
        xticks(0:5:5*ceil(MAXSS2_plus1/5))
        xticklabels(0:5:5*ceil(MAXSS2_plus1/5))
        % y
        ax.YAxis.MinorTick = 'on';
        ax.YAxis.MinorTickValues = 0:PopSize;    
        ax.YMinorGrid = 'on';
        yticks(0:5:PopSize)
        yticklabels(0:5:PopSize)
    % Labels
        xlabel('\#operator','Interpreter','latex')
        ylabel('Individual','Interpreter','latex')
        set(gca, 'YDir', 'reverse')
        title(['\#operator per individual - Gen ',num2str(geni)],'Interpreter','latex')
    % Aspect and position
        set(gca,'DataAspectRatio',[MAXSS2_plus1 PopSize/1.5 1]);
        set(gca,'FontSize',FS)
        set(gca,'LineWidth',LW)
    % Export
        % FigName = ['save_runs/',Name,'/Figures/Gen',num2str(geni),'OpeIndiv'];
        % print(FigName,'-dpng')
        % close
        
%% Matrix
    figure
    set(gcf, 'Position', [1000 0  600 750])
    set(gcf,'color','w')
    % Image
    imagesc(-0.5+[1,maxOI],-0.5+[1,PopSize],OTi)    % Colormap and axis
        colormap( flip( hot( max(OTi(:))+1 ) ) )
        colorbar
        axis([0,maxOI,0,PopSize])
        grid on
        caxis([0,max(max(OTi))])
        colorbar('XTick', 0:(max(max(OTi))));
    % Ticks
        ax = gca;
        set(gca,'GridColor','black','GridAlpha',0.5);
        % x
        ax.XAxis.MinorTick = 'on';
        ax.XAxis.MinorTickValues = 0:maxOI;    
        ax.XMinorGrid = 'on';
        xticks(0:maxOI)
        xticklabels('')
        % y
        ax.YAxis.MinorTick = 'on';
        ax.YAxis.MinorTickValues = 0:PopSize;    
        ax.YMinorGrid = 'on';
        yticks(0:5:PopSize)
        yticklabels(0:5:PopSize)
    % Labels
        xlabel('Operator','Interpreter','latex')
        ylabel('Individual','Interpreter','latex')
        title(['Operator distribution - Gen ',num2str(geni)],'Interpreter','latex')
    % Operators
    for sp=1:max(OperatorIndices)
      text(sp-0.5,PopSize,OpMarker{sp},...
          'Interpreter','latex','FontSize',1.5*FS,...
          'HorizontalAlignment','center',...
          'VerticalAlignment','top')
    end
%      text(sp/2,PopSize*1.1,'sensor',...
%          'Interpreter','latex','FontSize',FS,...
%          'HorizontalAlignment','center',...
%          'VerticalAlignment','cap')
    % Aspect and position
        set(gca,'DataAspectRatio',[maxOI PopSize/1.5 1]);
        set(gca,'FontSize',FS)
        set(gca,'LineWidth',LW)        
    % Export
        % FigName = ['save_runs/',Name,'/Figures/Gen',num2str(geni),'OpeDistrib'];
        % print(FigName,'-dpng')
        % close

%% Number of operators for each operator
    figure
    set(gcf, 'Position', [0 0 500 500])
    set(gcf,'color','w')
    % Bar
    barb=bar(-0.5+(1:maxOI),sum(OTi,1),0.5);
    % Colormap and axis
        barb.FaceColor='flat';
%         CMP = flip(hot(MAXSS2_plus1)); % For future versions
        barb.FaceColor = [0,0,0];
        colormap( flip( hot( max(OTi(:))+1 ) ) )
        axis([0,maxOI,0,MAXSS1_plus1])
        grid on
    % Ticks
        ax = gca;
        set(gca,'GridColor','black','GridAlpha',0.5);
        % x
        ax.XAxis.MinorTick = 'on';
        ax.XAxis.MinorTickValues = 0:maxOI;    
        ax.XMinorGrid = 'on';
        xticks(0:10:maxOI)
        xticklabels('')
        % y
        ax.YAxis.MinorTick = 'on';
        ax.YAxis.MinorTickValues = 0:5*floor(MAXSS1_plus1/5);    
        ax.YMinorGrid = 'on';
        yticks(0:5:5*floor(MAXSS1_plus1/5));
        yt = 0:5:5*floor(MAXSS1_plus1/5);
        yticks(yt)
        yt1 = unique([1,5*floor(1:length(yt)/5),length(yt)]);
        yt2 = ones(length(yt),1); yt2(yt1) = 0; yt2=logical(yt2);
        ytl = num2cell(yt(:)); ytl(yt2) = {''};
        yticklabels(ytl)
    % Labels
        xlabel('Operator','Interpreter','latex')
        ylabel('\#use','Interpreter','latex')
        title(['\#use - Gen ',num2str(geni)],'Interpreter','latex')
    % Operators
        for sp=1:max(OperatorIndices)
          text(sp-0.5,0,OpMarker{sp},...
              'Interpreter','latex','FontSize',1.5*FS,...
              'HorizontalAlignment','center',...
              'VerticalAlignment','top')
        end
%          text(sp/2,-0.5,'operator',...
%              'Interpreter','latex','FontSize',FS,...
%              'HorizontalAlignment','center',...
%              'VerticalAlignment','cap')
     % Aspect and position
        set(gca,'DataAspectRatio',[maxOI MAXSS1_plus1 1]);
        set(gca,'FontSize',FS)
        set(gca,'LineWidth',LW)
    % Export
        % FigName = ['save_runs/',Name,'/Figures/Gen',num2str(geni),'TotalOpe'];
        % print(FigName,'-dpng')
        % close
cmpt = cmpt + 1;
end

%% Plot constants
cmpt = 1;
for geni = GENS
    CTi = reshape(ConstantsTab(cmpt,:,:),PopSize,CstRegNumber);
    MAXSS1_plus1 = max(sum(CTi,1))+1;
    MAXSS2_plus1 = max(sum(CTi,2))+1;

    % Dimensions
%     NColumns = MAXSS2_plus1+CstRegNumber;
%         C1 = 1:(MAXSS2_plus1);
%         C2 = (MAXSS2_plus1+1):NColumns;
%         R1 = transpose(1:PopSize);
%         R2 = PopSize+1;
%     NRows = PopSize+1;

%% Number of constants per individual
    figure(7)
    set(gcf, 'Position', [500 0  500 750])
    set(gcf,'color','w')
    % Bar
        barb=barh(-0.5+(1:PopSize),sum(CTi,2),1);
    % Colormap and axis
        barb.FaceColor='flat';
%         CMP = flip(hot(MAXSS2_plus1));
        barb.FaceColor = [1,0,0];   
        colormap( flip( hot( max(CTi(:))+1 ) ) )
        axis([0,MAXSS2_plus1,0,PopSize])
        grid on
    % Ticks
        ax = gca;
        set(gca,'GridColor','black','GridAlpha',0.5);
        % x
        ax.XAxis.MinorTick = 'on';
        ax.XAxis.MinorTickValues = 0:5*ceil(MAXSS2_plus1/5);    
        ax.XMinorGrid = 'on';
        xticks(0:5:5*ceil(MAXSS2_plus1/5))
        xticklabels(0:5:5*ceil(MAXSS2_plus1/5))
        % y
        ax.YAxis.MinorTick = 'on';
        ax.YAxis.MinorTickValues = 0:PopSize;    
        ax.YMinorGrid = 'on';
        yticks(0:5:PopSize)
        yticklabels(0:5:PopSize)
    % Labels
        xlabel('\#constant','Interpreter','latex')
        ylabel('Individual','Interpreter','latex')
        set(gca, 'YDir', 'reverse')
        title(['\#constant per individual - Gen ',num2str(geni)],'Interpreter','latex')
    % Aspect and position
        set(gca,'DataAspectRatio',[MAXSS2_plus1 PopSize/1.5 1]);
        set(gca,'FontSize',FS)
        set(gca,'LineWidth',LW)
    % Export
        % FigName = ['save_runs/',Name,'/Figures/Gen',num2str(geni),'CstIndiv'];
        % print(FigName,'-dpng')
        % close
        
 %% Matrix
    figure
    set(gcf, 'Position', [1000 0  600 750])
    set(gcf,'color','w')
    % Image
    imagesc(-0.5+[1,CstRegNumber],-0.5+[1,PopSize],CTi)
        colormap( flip( hot( max(CTi(:))+1 ) ) )
        colorbar
        axis([0,CstRegNumber,0,PopSize])
        ax1.YMinorGrid = 'on';
        ax1.XGrid = 'on';
        caxis([0,max(max(CTi))])
        colorbar('XTick', 0:(max(max(CTi))));
        grid on
    % Ticks
        ax = gca;
        set(gca,'GridColor','black','GridAlpha',0.5);
        % x
        ax.XAxis.MinorTick = 'on';
        ax.XAxis.MinorTickValues = 0:CstRegNumber;    
        ax.XMinorGrid = 'on';
        xticks(0:5:CstRegNumber)
        xticklabels(0:5:CstRegNumber)
        % y
        ax.YAxis.MinorTick = 'on';
        ax.YAxis.MinorTickValues = 0:PopSize;    
        ax.YMinorGrid = 'on';
        yticks(0:5:PopSize)
        yticklabels(0:5:PopSize)
    % Labels
        xlabel('Constant','Interpreter','latex')
        ylabel('Individual','Interpreter','latex')
        title(['Constant distribution - Gen ',num2str(geni)],'Interpreter','latex')
    % Operators
    for sp=1:CstRegNumber
      text(sp-0.5,PopSize,['$c_',num2str(sp),'$'],...
          'Interpreter','latex','FontSize',1.5*FS,...
          'HorizontalAlignment','center',...
          'VerticalAlignment','top')
    end
%      text(sp/2,PopSize*1.1,'constant',...
%          'Interpreter','latex','FontSize',FS,...
%          'HorizontalAlignment','center',...
%          'VerticalAlignment','cap')
    % Aspect and position
        set(gca,'DataAspectRatio',[CstRegNumber PopSize/1.5 1]);
        set(gca,'FontSize',FS)
        set(gca,'LineWidth',LW)            
    % Export
        % FigName = ['save_runs/',Name,'/Figures/Gen',num2str(geni),'CstDistrib'];
        % print(FigName,'-dpng')
        % close

%% Number of constans for each constant
    figure
    set(gcf, 'Position', [0 0 500 500])
    set(gcf,'color','w')
    % Bar
    barb=bar(-0.5+(1:CstRegNumber),sum(CTi,1),0.5);
    % Colormap and axis
        barb.FaceColor='flat';
%         CMP = flip(hot(MAXSS2_plus1)); % For future versions
        barb.FaceColor = [0,0,0];
        colormap( flip( hot( max(CTi(:))+1 ) ) )
        axis([0,CstRegNumber,0,MAXSS1_plus1])
        grid on
    % Ticks
        ax = gca;
        set(gca,'GridColor','black','GridAlpha',0.5);
        % x
        ax.XAxis.MinorTick = 'on';
        ax.XAxis.MinorTickValues = 0:CstRegNumber;    
        ax.XMinorGrid = 'on';
        xticks(0:5:CstRegNumber)
        xticklabels(0:5:CstRegNumber)
        % y
        ax.YAxis.MinorTick = 'on';
        ax.YAxis.MinorTickValues = 0:5*floor(MAXSS1_plus1/5);    
        ax.YMinorGrid = 'on';
        yticks(0:5:5*floor(MAXSS1_plus1/5))
        yticklabels(0:5:5*floor(MAXSS1_plus1/5))
    % Labels
        xlabel('Constant','Interpreter','latex')
        ylabel('\#use','Interpreter','latex')
        title(['\#use - Gen ',num2str(geni)],'Interpreter','latex')
    % Operators
    for sp=1:CstRegNumber
      text(sp-0.5,0,['$c_',num2str(sp),'$'],...
          'Interpreter','latex','FontSize',1.5*FS,...
          'HorizontalAlignment','center',...
          'VerticalAlignment','top')
    end
%      text(sp/2,-0.5,'constant',...
%          'Interpreter','latex','FontSize',FS,...
%          'HorizontalAlignment','center',...
%          'VerticalAlignment','cap')
     % Aspect and position
        set(gca,'DataAspectRatio',[CstRegNumber MAXSS1_plus1 1]);
        set(gca,'FontSize',FS)
        set(gca,'LineWidth',LW)
% Export
    % FigName = ['save_runs/',Name,'/Figures/Gen',num2str(geni),'TotalCsts'];
    % print(FigName,'-dpng')
    % close
    
cmpt = cmpt + 1;
end

%% Yes figures
%    set(0,'DefaultFigureVisible','on');
    
%fprintf(['Figures exported in ./save_runs/',Name,'/Figures\n'])
