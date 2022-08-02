function CreatefunctionLabview(MLC_parameters,MLC_ind,IdxGen)
% gMLC class CreatefonctionLabview function
% Creates the LabViewControlLaw.txt file in Path/
% The control law is post-processed for LabView format
%
% Guy Y. Cornejo Maceda, 2022/07/01
%
% See also SIN, COS, TheOtherFunction.

% Copyright: 2022 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
% The MIT License (MIT)

%% Parameters
    LabViewPath = MLC_parameters.PathExt;
    
%% Print
    fprintf('\nWriting LabViewControlLaw.txt.');
%     fprintf(['  ',LabViewPath,'\n']);
    
%% PostProcessing
    % Index
    IndivIndex = sprintf('gen%02iind%03i_%s',IdxGen(1),IdxGen(2),date);
    % Control law
    control_law = MLC_ind.control_law;
    for p=1:size(control_law,1)
        control_law{p} = changeoperators(control_law{p});
    end
    control_law = strrep_cl(MLC_parameters,control_law,2);

    
%% Create
    % Open
    fid = fopen(fullfile(LabViewPath,'LabViewControlLaw.txt'),'wt');
    % Write
    fprintf(fid,[IndivIndex,';']);
    for p=1:size(control_law,1)
        fprintf(fid,[control_law{p},';']);
    end
    % Close
    fclose(fid);

%% Print
    fprintf(' Done!\n')
end %method


%% Function
function CLout=changeoperators(CLin)

% my_div
CLout = CLin;
% my_div
    CLout = strrep(CLout,'my_div','');
    CLout = strrep(CLout,',',')./(');
 
% my_log
ML = strfind(CLout,'my_log');
while not(isempty(ML))
    % first parenthesis
    FP = CLout((ML(1)+7):end);
    stru1=cumsum(double(FP=='('));
    stru2=cumsum(double(FP==')'));
    diffstr = abs(stru1-stru2);
    LP = find(diffstr==0,1);
    IDX = ML(1)+7+LP;
    CLout = [CLout(1:IDX),')',CLout((IDX+1):end)];
    CLout = strrep(CLout,'my_log','log(abs');
    % New ML
    ML = strfind(CLout,'my_log');
end
end
