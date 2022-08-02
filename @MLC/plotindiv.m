function plotindiv(MLC,Idx)
    % PLOT plots the individual Idx
    %
    % Guy Y. Cornejo Maceda, 2022/07/01
    %
    % See also MLCind, evaluate_indiv.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % The MIT License (MIT)
%% Individual and evaluation function
Indiv = MLC.table.individuals(Idx);
    control_law = Indiv.control_law;
    control_law = strrep_cl(MLC.parameters,control_law,2);

eval([MLC.parameters.EvaluationFunction '_problem(control_law,MLC.parameters,1)']);
end