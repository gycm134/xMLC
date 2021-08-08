function [mindiv,instr] = mutate(indiv,MLC_parameters)
    % MUTATE mutates a line in the matrix with the probability pm.
    % Takes one MLCind object as argument and parameters.
    % Gives the new mutated MLCind and the line that mutated.
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also MLCind, evaluate_indiv.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA
    
%% MATLAB options
    % Version
    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
    
%% Parameters
    gamma = MLC_parameters.ProblemParameters.gamma;
    
%% Mutation rate
  mutation_type = MLC_parameters.MutationType;
  switch mutation_type
      case 'classic'
          pm = MLC_parameters.MutationRate;
      case 'at_least_one'
          pm = 1/size(indiv.chromosome,1);
  end

%% Mutated individual (m_individual)
  mindiv = MLCind;
  m_chromosome = indiv.chromosome;

%% Mutation
  cmp   = 1;
  while cmp
      % instruction selection
      ra = rand(size(m_chromosome,1),1);
      mutated_instructions = ra<pm;
      number_mutations=nnz(mutated_instructions);
     % new individual?
      cmp = number_mutations==0;
  end

% mutation
  m_chromosome(mutated_instructions,1) = randsrc(number_mutations,1,1:MLC_parameters.ControlLaw.RegNumber);
  m_chromosome(mutated_instructions,2) = randsrc(number_mutations,1,1:MLC_parameters.ControlLaw.RegNumber);
  m_chromosome(mutated_instructions,3) = randsrc(number_mutations,1,MLC_parameters.ControlLaw.OperatorIndices);
  m_chromosome(mutated_instructions,4) = randsrc(number_mutations,1,1:MLC_parameters.ControlLaw.VarRegNumber);


%% Chromosome
  mindiv.chromosome = m_chromosome;
  [EI_mchro,indices] = exclude_introns(MLC_parameters,m_chromosome);

%% Update mindiv
    mindiv.cost = {-1}; % cost
    mindiv.control_law = read(MLC_parameters,m_chromosome); % control_law
    mindiv.EI.chromosome = EI_mchro; % effective instructions - chromosome
    mindiv.EI.indices = indices; % effective instructions - indices
  % hash function
    if isOctave
        hashvalue = hash('MD5',mat2str(mindiv.chromosome)); % Octave
    else
        hashvalue = DataHash(mindiv.chromosome); % Matlab
    end
    mindiv.hash = hex2num(hashvalue(1:16));
  % controller numerical equivalency
    evaluation_time = MLC_parameters.ControlLaw.EvalTimeSample;
    control_points = MLC_parameters.ControlLaw.ControlPoints;
    evap = vertcat(evaluation_time,control_points);
    control_law = strrep_cl(MLC_parameters,mindiv.control_law,1);
    values = eval_controller_points(control_law,evap,MLC_parameters.ProblemParameters.ActuationLimit,MLC_parameters.ProblemParameters.RoundEval);
    mindiv.control_points = reshape(values,1,[]);
%   % pretesting % Now in the clean method
%     NAN = logical(sum(isnan(mindiv.control_points)));
%     INF = logical(sum(isinf(mindiv.control_points)));
%     if NAN||INF
%         mindiv.cost = num2cell(MLC_parameters.BadValue*ones(1,numel(gamma)+2));
%     end

%% operation
  instr = find(mutated_instructions);

end
