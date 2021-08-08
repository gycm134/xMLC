function b_output=expe_create_control_solo(MLC,gen,IND)
  % EXPE_CREATE_CONTROL_SOLO creates a control law file for external evaluation.
  % Takes in argument an MLC object, a generation and an indice to create
  % a file containing the corresponding control law.
  % That file (b_solo.m) is to be used in an external evaluation.
  %
  % Guy Y. Cornejo Maceda, 07/18/2020
  %
  % See also expe_create_control_time, expe_create_control_select.

  % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
  % CC-BY-SA

%% Control law
    % Name
    Name = MLC.parameters.Name;
    % Directory
    dir = 'save_runs/tmp';
    % Precision
    Precision = MLC.parameters.ControlLaw.Precision;
    % Others
    OutputNumber = MLC.parameters.ProblemParameters.OutputNumber; 

    ind = MLC.population(gen).individuals(IND(1));
    b_cell = MLC.table.individuals(ind).control_law;
    % remplace variables
    b_cell = strrep_cl(MLC.parameters,b_cell,2); %2: for evaluation

%% File
  fid = fopen(fullfile(dir,'ControlLawSolo.m'),'wt');
    % output string
    OUT = '[';
    for q=1:OutputNumber
        if q>1
            OUT = [OUT,',out',num2str(q)];
        else
            OUT = [OUT,'out',num2str(q)];
        end
    end
    OUT = [OUT,']'];
    fprintf(fid,['function ',OUT,'=ControlLawSolo(s,t)']);
    fprintf(fid,'\n');
        
    % loop
    Allbx = '[';
        for q=1:OutputNumber
            % concatenate the string expressions
            if q>1
                Allbx=[Allbx,';',b_cell{q}];
            else
                Allbx=[Allbx,b_cell{q}]; 
            end
            % outputs
        fprintf(fid,['   out',num2str(q),'=',b_cell{q},';']);
        fprintf(fid,'\n');
        end  
    % definition
    Allbx = [Allbx,']'];
    eval(['bf = @(s)(' Allbx ');']);
    b_output=bf;
    
    fprintf(fid,'\n');
    fprintf(fid,'end');
    fprintf(fid,'\n');
    fprintf(fid,'\n');

    % my_div
    fprintf(fid,'function q=my_div(x,y)');
    fprintf(fid,'\n');
    fprintf(fid,['protection = 1e-',num2str(Precision),';']);
    fprintf(fid,'\n');
    fprintf(fid,'y(y==0)=inf;');
    fprintf(fid,'\n');
    fprintf(fid,'q=x./(y.*(abs(y)>protection)+protection*sign(y).*(abs(y)<=protection));');
    fprintf(fid,'\n');
    fprintf(fid,'end');
  
    fprintf(fid,'\n');
    fprintf(fid,'\n');

    % my_log
    fprintf(fid,'function q=my_log(x)');
    fprintf(fid,'\n');
    fprintf(fid,['protection = 1e-',num2str(Precision),';']);
    fprintf(fid,'\n');
    fprintf(fid,'q=log10(abs(x).*(abs(x)>=protection)+protection*(abs(x)<protection));');
    fprintf(fid,'\n');
    fprintf(fid,'end');

fclose(fid);