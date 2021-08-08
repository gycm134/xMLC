function [new_indiv,indices,submat]=exclude_introns(MLC_parameters,chromosome)
    % EXCLUDE_INTRONS excludes the introns in a matrix
    % Gives the effective matrix, the effective lines and the submatrices
    % for each input.
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also create_indiv, chromosome.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

%% Operators characteristics
  ops = opset(1:max(MLC_parameters.ControlLaw.OperatorIndices));

%% Number of instructions
  N_inst = size(chromosome,1);

%% Output registers
  MI = MLC_parameters.ProblemParameters.OutputNumber;
  output_reg = 1:MI;

%% Initilization
  eff_reg = output_reg;
  new_indiv = chromosome;
  indices = [];

%% Loop over the instructions
    % Starting from the bottom
for p=N_inst:-1:1
    if sum(chromosome(p,4) == eff_reg)
        eff_reg(eff_reg==chromosome(p,4))=[];
        eff_reg = [eff_reg chromosome(p,1)];
        if ops(chromosome(p,3)).nbarg == 2
            eff_reg = [eff_reg chromosome(p,2)];
        end
        indices = [p,indices];
    else
        new_indiv(p,:) =[];
    end
end



%% Submatrices
    submat = cell(MI,2);
    % loop over the OutputNumber register outputs
for output_reg=1:MI

% Initilization
  eff_reg = output_reg;
  new_sub = chromosome;
  subindices = [];

% Loop over the instructions
    % Starting from the bottom
for p=N_inst:-1:1
    if sum(chromosome(p,4) == eff_reg)
        eff_reg(eff_reg==chromosome(p,4))=[];
        eff_reg = [eff_reg chromosome(p,1)];
        if ops(chromosome(p,3)).nbarg == 2
            eff_reg = [eff_reg chromosome(p,2)];
        end
        subindices = [p,subindices];
    else
        new_sub(p,:) =[];
    end
end
submat{output_reg,1} = new_sub;
submat{output_reg,2} = subindices;
end
