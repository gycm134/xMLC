function new_individual = create_indiv(new_individual,MLC_parameters,first)
    % CREATE_INDIV Fills a MLCind object with a random matrix
    % For a MLCind object, fills the properties by creating a random matrix.
    % The individual is then ready to be evaluated.
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

%% Arguments
if nargin <3
    first=0;
end

%% Create chromosome
	% Create and size
	chromosome = create_chromosome(MLC_parameters);
	Nimin = MLC_parameters.ControlLaw.InstructionSize.InitMin;
	% First individual test
	[~,idx] = exclude_introns(MLC_parameters,chromosome);
	while first&&(~isempty(idx))
	    chromosome(idx,:)=[];
	    if size(chromosome,1)<Nimin
	        chromosome = create_chromosome(MLC_parameters);
	    end
	    [~,idx] = exclude_introns(MLC_parameters,chromosome);
	end


%% Traduction
	control_law = read(MLC_parameters,chromosome);

%% Effective instructions
	% We delete the introns in order to have the effective instructions
	% thus we can avoid redundant evaluation
	[EIC,non_intron_indices] = exclude_introns(MLC_parameters,chromosome);
	EI.chromosome = EIC;
	EI.indices = non_intron_indices;

%% Filling the individual
	new_individual.chromosome = chromosome;
	new_individual.control_law = control_law;
	new_individual.EI = EI;
	new_individual.occurences = 1;
	% hash function
    if isOctave
        hashvalue = hash('MD5',mat2str(new_individual.chromosome)); % Octave
    else
        hashvalue = DataHash(new_individual.chromosome); % Matlab
    end
	new_individual.hash = hex2num(hashvalue(1:16));
	% controller numerical equivalency
	evaluation_time = MLC_parameters.ControlLaw.EvalTimeSample;
	control_points = MLC_parameters.ControlLaw.ControlPoints;
	evap = vertcat(evaluation_time,control_points);
    control_law = strrep_cl(MLC_parameters,control_law,1);
	values = eval_controller_points(control_law,evap,MLC_parameters.ProblemParameters.ActuationLimit,MLC_parameters.ProblemParameters.RoundEval);
	new_individual.control_points = reshape(values,1,[]);
% 	% pretesting % Now in the clean method
% 	NAN = logical(sum(isnan(new_individual.control_points)));
% 	INF = logical(sum(isinf(new_individual.control_points)));
% 	if NAN||INF
% 	    new_individual.cost = num2cell(MLC_parameters.BadValue*ones(1,numel(gamma)+2));
% 	end
end

%% Create chromosome
function chromosome=create_chromosome(MLC_parameters)
	% Choosing the number of intructions
	Nimax = MLC_parameters.ControlLaw.InstructionSize.InitMax;
	Nimin = MLC_parameters.ControlLaw.InstructionSize.InitMin;
	N_inst = round((Nimax-Nimin)*rand+Nimin);

	% Construction of the chromosome
	v1 = randsrc(N_inst,1,1:MLC_parameters.ControlLaw.RegNumber);
	v2 = randsrc(N_inst,1,1:MLC_parameters.ControlLaw.RegNumber);
    v3 = randsrc(N_inst,1,MLC_parameters.ControlLaw.OperatorIndices);
	v4 = randsrc(N_inst,1,1:MLC_parameters.ControlLaw.VarRegNumber);
	chromosome = [v1 v2 v3 v4];
end
