function expr_lisp = mat2lisp(MLC_parameters,chromosome)
    % MAT2LISP translates the matrix expression to LISP.
    % Traduction of the j-th individual of the ngen-th generation
    % The matrice expression becomes a "lisp" expression, that will
    % be useful for simplication
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also read, readmylisp_to_evaluate.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

%% initialization
r = MLC_parameters.ControlLaw.Registers;

ops = opset(1:max(MLC_parameters.ControlLaw.OperatorIndices));

for i=1:size(chromosome,1)
    g1 = chromosome(i,1);
    g2 = chromosome(i,2);
    g3 = chromosome(i,3);
    g4 = chromosome(i,4);

    if ops(g3).nbarg == 1
        r{g4} = ['(' ops(g3).op ' ' r{g1} ')'];
    else
        r{g4} = ['(' ops(g3).op ' ' r{g1} ' ' r{g2} ')'];
    end
end

%% Several OutputNumber
MI = MLC_parameters.ProblemParameters.OutputNumber;

expr_lisp = r(1:MI);
end
