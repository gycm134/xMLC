 function expr = read(MLC_parameters,chromosome,to_export)
    % READ translates a chromosome in a string expression.
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also mat2lisp, readmylisp_to_evaluate, simplify_my_LISP.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

%% Arguments
    if nargin<3,to_export=0;end
    
%% Matrix to LISP
  lisp_expr = mat2lisp(MLC_parameters,chromosome);
  MI = MLC_parameters.ProblemParameters.OutputNumber;
  lisp_expr_simplified = cell(MI,1);
  expr=cell(MI,1);

%% Read
try
for p=1:MI
    % LISP simlification
    lisp_expr_simplified{p} = simplify_my_LISP(lisp_expr{p},MLC_parameters);
    % Ouput
    expr{p} = readmylisp_to_evaluate(lisp_expr_simplified{p},MLC_parameters,to_export);
end
catch err
	for p=1:MI
		expr{p} = 'NaN';
	end
	fprintf('Error in readmylisp_to_evaluate');
	fprintf(err.message);
	fprintf('\n')
end

end
