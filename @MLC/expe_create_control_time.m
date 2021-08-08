function b_output=expe_create_control_time(MLC,gen,IND)
  % EXPE_CREATE_CONTROL_TIME creates a control law file for external evaluation.
  % Takes in argument an MLC object, a generation and a list of indices to create
  % a file containing the corresponding control law.
  % That file (bN.m) is to be used in an external evaluation.
  % The control laws are all appended a last a given time.
  % A relaxing time between the control laws is set in T_pause.
  %
  % Guy Y. Cornejo Maceda, 07/18/2020
  %
  % See also expe_create_control_solo, expe_create_control_select.

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
    % Time
    N_periods=10;
    omega=1;
    T_simu = ceil(2*pi*N_periods/omega);
    T_pause=ceil(2*pi*2/omega);

%% File 
  fid = fopen(fullfile(dir,'ControlLawTime.m'),'wt');
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
  fprintf(fid,['function ',OUT,'=ControlLawTime(s,t)']);
  fprintf(fid,'\n');
  fprintf(fid,['if t<',num2str(T_simu)]);

for p=1:nind

    ind = MLC.population(gen).individuals(IND(p));

    b_cell = MLC.table.individuals(ind).control_law;
    
    % remplace variables
    b_cell = strrep_cl(MLC.parameters,b_cell,2); %2: for evaluation
    
    % loop over the number of OutputNumber
    Allbx = '[';
        % put time delay in the control laws HERE!!!!!!!!!!!!!!!!!
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
    % Time
    fprintf(fid,['elseif t<',num2str(p*T_simu+p*T_pause)]);
    fprintf(fid,'\n');
    for q=1:OutputNumber
        fprintf(fid,['   out',num2str(q),'=0;']);
        fprintf(fid,'\n');
    end
    fprintf(fid,'\n');
    fprintf(fid,['elseif t<',num2str((p+1)*T_simu+p*T_pause)]);
    
    % definition
    Allbx = [Allbx,']'];
    eval(['bf = @(s)(' Allbx ');']);
    b_output{p}=bf;
end
fprintf(fid,'\n');
for q=1:OutputNumber
    fprintf(fid,['   out',num2str(q),'=0;']);
    fprintf(fid,'\n');
end
fprintf(fid,'\n');
fprintf(fid,'else');
fprintf(fid,'\n');
for q=1:OutputNumber
    fprintf(fid,['   out',num2str(q),'=0;']);
    fprintf(fid,'\n');
end
fprintf(fid,'\n');
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