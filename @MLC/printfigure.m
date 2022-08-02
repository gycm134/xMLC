function printfigure(MLC,FigureName,Rewrite)
    % PRINT prints the current figure in the right folder if it doesn't
    % exist
    %
    % Guy Y. Cornejo Maceda, 2022/07/01
    %
    % See also plot.

    % Copyright: 2022 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % The MIT License (MIT)
%% Parameters
    Name = MLC.parameters.Name;
    FigPath = ['save_runs/',Name,'/Figures/',FigureName];
    if nargin<3
        Rewrite=0;
    end
        
%% Test
    if exist([FigPath,'.eps'],'file') && not(Rewrite)
        error('This file name already exist. To overwrite add 1 as extra argument.')
    end
    
%% Print
    print([FigPath,'.eps'],'-depsc','-tiff','-r300') 
    print([FigPath,'.png'],'-dpng','-r300','-painters') 
end
