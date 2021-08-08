function MLC_ind = evaluate_indiv(MLC_ind,MLC_parameters,visu)
    % EVALUATE_INDIV Evaluates a MLCind object.
    % Evaluates the individual following some properties.
    % If multiple evaluations is set to 1 in the parameters, the individual
    % will be evaluated even if it has already been evaluated and the cost is the mean
    % value of all the costs.
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also MLCind, evaluate_indiv.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

%% Arguments
  if nargin<3
      visu=0;
  end

%% Parameters
    actuation_limit = MLC_parameters.ProblemParameters.ActuationLimit;
    RoundEval = MLC_parameters.ProblemParameters.RoundEval;
    EvaluationFunction = MLC_parameters.EvaluationFunction;
  
%% Evaluation function
  eval(['Plant=@',EvaluationFunction,'_problem;']);
  
%% Control : Definition, replacement and limitation
    control_law = MLC_ind.control_law;
    control_law = strrep_cl(MLC_parameters,control_law,2);
%    control_law = limit_to(control_law,actuation_limit);
% Should be done in the plant
   
%% Evaluation
if MLC_ind.cost{1}==-1 || MLC_parameters.MultipleEvaluations>0
    % Number of evaluations: at least 1
    NEvaluations = max([MLC_parameters.MultipleEvaluations,1]);
    % Loop for the number of evaluations
    for p=1:NEvaluations
        % Evaluate
        tic;
        J = Plant(control_law,MLC_parameters,visu);
        
        % Bad value test
        if isnan(J{1}) || isinf(J{1})
            J{1} = MLC_parameters.BadValue;
        end
        
        % Add value to MLC_indiv
        if MLC_ind.cost{1}<0, MLC_ind.cost={};end
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
