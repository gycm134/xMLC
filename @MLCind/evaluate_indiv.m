function MLC_ind = evaluate_indiv(MLC_ind,IdxGen,MLC_parameters,visu)
    % EVALUATE_INDIV Evaluates a MLCind object.
    % Evaluates the individual following some properties.
    % If multiple evaluations is set to 1 in the parameters, the individual
    % will be evaluated even if it has already been evaluated and the cost is the mean
    % value of all the costs.
    %
    % Guy Y. Cornejo Maceda, 2022/07/01
    %
    % See also MLCind, evaluate_indiv.

    % Copyright: 2022 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % The MIT License (MIT)

%% Arguments
  if nargin<4
      visu=0;
  end

%% MATLAB options
    % Version
    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
    
%% Parameters
    RoundEval = MLC_parameters.ProblemParameters.RoundEval;
    EvaluationFunction = MLC_parameters.EvaluationFunction;
    ProblemType = MLC_parameters.ProblemType;
    % Define gamma for LabView
    if isOctave
      Prop = fieldnames(MLC_parameters.ProblemParameters);
    else
      Prop = fields(MLC_parameters.ProblemParameters);
    end
    if sum(strcmp(Prop,'gamma'))
        gamma_all = [1,MLC_parameters.ProblemParameters.gamma];
    else
        gamma_all = 1;
    end
    
    
%% Create the control law if needed (Is is useful?)
if strcmp(ProblemType,'MATLAB')
        % Evaluation function
        eval(['Plant=@',EvaluationFunction,'_problem;']);
        % Control : Definition, replacement and limitation
        control_law = MLC_ind.control_law;
        control_law = strrep_cl(MLC_parameters,control_law,2);
end
   
%% Evaluation
if isinf(MLC_ind.cost{1}) || MLC_parameters.MultipleEvaluations>0
    % Number of evaluations: at least 1
    NEvaluations = max([MLC_parameters.MultipleEvaluations,1]);
    % Loop for the number of evaluations
    for p=1:NEvaluations
        % Evaluate
        tic;
        
        switch ProblemType
            case 'Dummy'
                Jrand = rand;
                J = {Jrand,Jrand};
            case 'MATLAB'
                J = Plant(control_law,MLC_parameters,visu);
                % Bad value test
                if isnan(J{1}) || isinf(J{1})
                    J{1} = MLC_parameters.BadValue;
                end
            case 'LabView'
                LabViewPath = MLC_parameters.PathExt;
                % Create control law file
                CreatefunctionLabview(MLC_parameters,MLC_ind,IdxGen);
                fprintf('Waiting for J.txt.\n')
                fprintf(['  ',LabViewPath,'\n'])
                while not(exist([LabViewPath,'J.txt'],'file'))
                    % Waiting for the file
                end
                fprintf(' Here it is!\n')
                % Two solutions to continue:
                % 1. Read and delete J.txt
                Jtab = load([LabViewPath,'J.txt'],'-ascii');
                if numel(Jtab)~=numel(gamma_all)
                    error('Gamma is not defined well')
                end
                J = [sum(gamma_all.*Jtab),num2cell(Jtab)];
                delete([LabViewPath,'J.txt']);
                % 2. Or compute the cost from the time series.
                % To be completed.
        end
        
        % Add value to MLC_indiv
        if isinf(MLC_ind.cost{1}), MLC_ind.cost={};end
        MLC_ind.cost = vertcat(MLC_ind.cost,J);
        MLC_ind.evaluation_time = [MLC_ind.evaluation_time;toc];
        
        % Print
        if MLC_parameters.MultipleEvaluations>1
            fprintf('\n')
            fprintf('      ')
        end
        if MLC_parameters.verbose
            fprintf('  J= %f',round(J{1}*10^(RoundEval))/10^(RoundEval))
        end
    end  
else
    if MLC_parameters.verbose
        J = MLC_ind.cost;
        fprintf(' already done ')
        fprintf('(J= %f)',round(J{1}*10^(RoundEval))/10^(RoundEval))
    end
end
        fprintf('\n')

end
