function plotindiv(MLC,Idx)
    % PLOT plots the individual Idx
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also MLCind, evaluate_indiv.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA
%% Individual and evaluation function
Indiv = MLC.table.individuals(Idx);
    control_law = Indiv.control_law;
    control_law = strrep_cl(MLC.parameters,control_law,2);

eval([MLC.parameters.EvaluationFunction '_problem(control_law,MLC.parameters,1)']);
end