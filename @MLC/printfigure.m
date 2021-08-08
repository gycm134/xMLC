function printfigure(MLC,FigureName)
    % PRINT prints the current figure in the right folder if it doesn't
    % exist
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also plot.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA
%% Parameters
    Name = MLC.parameters.Name;
    FigPath = ['save_runs/',Name,'/Figures/',FigureName];
    
%% Test
    if exist([FigPath,'.eps'],'file')
        error('This file name already exist')
    end
    
%% Print
    print([FigPath,'.eps'],'-depsc','-tiff','-r300') 
    print([FigPath,'.png'],'-dpng','-r300','-painters') 
end
