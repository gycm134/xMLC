function b_output=expe_create_control_select(MLC,gen,IND)
  % EXPE_CREATE_CONTROL_SELECT creates a control law file for external evaluation.
  % Takes in argument an MLC object, a generation and a list of indices to create
  % a file containing the corresponding control law.
  % That file (bNn.m) is to be used in an external evaluation.
  % A number is associated to each control law.
  % This number is used to switch from one control law to the other.
  %
  % Guy Y. Cornejo Maceda, 03/18/2020
  %
  % See also expe_create_control_solo, expe_create_control_time.

  % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
  % CC-BY-SA

%% Initilization
  % Name
  Name = MLC.parameters.Name;
  % Directory
  dir = 'save_runs/tmp';
  % Precision
  Precision = MLC.parameters.ControlLaw.Precision;
  % Others
  nind = length(IND);
  b_output = cell(nind,1);
  OutputNumber = MLC.parameters.ProblemParameters.OutputNumber; 
  
%% File
  fid = fopen(fullfile(dir,'ControlLawSelect.m'),'wt');
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
  fprintf(fid,['function ',OUT,'=ControlLawSelect(s,t,n)']);
  fprintf(fid,'\n');
  fprintf(fid,['switch n']);
  fprintf(fid,'\n');

for p=1:nind

    ind = MLC.population(gen).individuals(IND(p));

    b_cell = MLC.table.individuals(ind).control_law;
    
    % remplace variables
    b_cell = strrep_cl(MLC.parameters,b_cell,2); %2: for evaluation
    
    % loop over the number of OutputNumber
    Allbx = '[';
        % put time delay in the control laws HERE!!!!!!!!!!!!!!!!!
    fprintf(fid,['   case ',num2str(p)]);
    fprintf(fid,'\n');
    
        % loop
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
    b_output{p}=bf;
end

fprintf(fid,'   otherwise');
fprintf(fid,'\n');
% loop
    for q=1:OutputNumber
    fprintf(fid,['   out',num2str(q),'=0;']);
    fprintf(fid,'\n');
    end
fprintf(fid,'end');
fprintf(fid,'\n');

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
