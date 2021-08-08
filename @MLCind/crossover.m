function [cindiv1, cindiv2,pp] = crossover(individual_1,individual_2,MLC_parameters)
    % CROSSOVER computes a crossover operation between two given individuals
    % Takes two MLCind objects as first arguments and parameters.
    % Gives two new MLCind objects and a cell array containing where the cuts
    % on the matrices have been made and how the two offsprings have been reconstructed.
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
  cindiv1 = MLCind;
  cindiv2 = MLCind;

%% chromosomes of each individual
  chro1 = individual_1.chromosome;
  chro2 = individual_2.chromosome;

%% number of instructions for each individual
  l1 = size(chro1,1);
  l2 = size(chro2,1);

%% Definition of the number of points for the crossover
  N_points = MLC_parameters.CrossoverPoints;
  l0 = min(l1,12);
  if N_points > l0+1, N_points = l0+1;end

%% Maximum number of instructions
  MaxInst=MLC_parameters.ControlLaw.InstructionSize.Max;

%% Crossover individuals
  cl1 = MaxInst+1;
  cl2 = 0;

%% WHILE LOOP to restrain the number of instructions
while cl1>MaxInst || cl2>MaxInst

  % Definition of the crossover points
  % We add the length of the chromosomes for programmation purposes
  crossover_pts = zeros(2,N_points);
  range1 = 0:l1;
  range2 = 0:l2;
  for i=1:N_points
    crossover_pts(1,i) = randsrc(1,1,range1); % we choose a random number in a range
    range1(range1==crossover_pts(1,i)) = []; % we delete the points already chosen
    crossover_pts(2,i) = randsrc(1,1,range2);
    range2(range2==crossover_pts(2,i)) = [];
  end
  crossover_pts = [sort(crossover_pts,2),[l1;l2]];
  % crossover_pts = [0 l1;l2 l2]; %% FOR TESTs

  % Choice of chromosomes parts from each parent (1 or 2) for the offsprings
  crossover_mix = MLC_parameters.CrossoverMix;
  if crossover_mix
      rchro1 = mod(1+(1:N_points+1),2)+1;
      rchro2 = mod(1:N_points+1,2)+1;
  else
      rchro1 = randsrc(1,N_points+1,[1,2]);
      rchro2 = randsrc(1,N_points+1,[1,2]);
  end

  % Extract the submatrices
  subchro = cell(2,N_points+1);
  subchro{1,1} = chro1(1:crossover_pts(1,1),:);
  subchro{2,1} = chro2(1:crossover_pts(2,1),:);
  for p=1:N_points
      subchro{1,p+1} = chro1(crossover_pts(1,p)+1:crossover_pts(1,p+1),:);
      subchro{2,p+1} = chro2(crossover_pts(2,p)+1:crossover_pts(2,p+1),:);
  end

  % Building the new chromosomes by concatenation
  cchro1 = [];
  cchro2 = [];
  for p=1:N_points+1
      cchro1 = vertcat(cchro1,subchro{rchro1(p),p});
      cchro2 = vertcat(cchro2,subchro{rchro2(p),p});
  end

  % Exception: N_points = 1 && ((1 && end)||(end && 1))
  boo1 = crossover_pts(1,1)==0 && crossover_pts(2,end-1)==l2;
  boo2 = crossover_pts(1,end-1)==l1 && crossover_pts(2,1)==0;
  boo = boo1 || boo2;
  if N_points==1 && boo
      cchro1 = vertcat(chro1,chro2);
      cchro2 = vertcat(chro2,chro1);
  end
  cl1 = size(cchro1,1);
  cl2 = size(cchro2,1);

end
% END WHILE LOOP

%% Evolution
  [EI_cchro_1,indices_1] = exclude_introns(MLC_parameters,cchro1);
  [EI_cchro_2,indices_2] = exclude_introns(MLC_parameters,cchro2);

%% First offspring - CINDIV1
  cindiv1.chromosome = cchro1;
  cindiv1.cost = {-1};
  cindiv1.control_law = read(MLC_parameters,cchro1);
  cindiv1.EI.chromosome = EI_cchro_1;
  cindiv1.EI.indices = indices_1;
  % hash function
  if isOctave
      hashvalue = hash('MD5',mat2str(cindiv1.chromosome)); % Octave
  else
      hashvalue = DataHash(cindiv1.chromosome); % MATLAB
  end
  cindiv1.hash = hex2num(hashvalue(1:16));
  % controller numerical equivalency
  evaluation_time = MLC_parameters.ControlLaw.EvalTimeSample;
  control_points = MLC_parameters.ControlLaw.ControlPoints;
  evap = vertcat(evaluation_time,control_points);
      control_law1 = strrep_cl(MLC_parameters,cindiv1.control_law,1);
  values = eval_controller_points(control_law1,evap,MLC_parameters.ProblemParameters.ActuationLimit,MLC_parameters.ProblemParameters.RoundEval);
  cindiv1.control_points = reshape(values,1,[]);


%% Second offspring - CINDIV2
  cindiv2.chromosome = cchro2;
  cindiv2.cost = {-1};
  cindiv2.control_law = read(MLC_parameters,cchro2);
  cindiv2.EI.chromosome = EI_cchro_2;
  cindiv2.EI.indices = indices_2;
  % hash function
  if isOctave
      hashvalue = hash('MD5',mat2str(cindiv2.chromosome)); % Octave
  else
      hashvalue = DataHash(cindiv2.chromosome); % MATLAB
  end
  cindiv2.hash = hex2num(hashvalue(1:16));
  % controller numerical equivalency
  evaluation_time = MLC_parameters.ControlLaw.EvalTimeSample;
  control_points = MLC_parameters.ControlLaw.ControlPoints;
  evap = vertcat(evaluation_time,control_points);
        control_law2 = strrep_cl(MLC_parameters,cindiv2.control_law,1);
  values = eval_controller_points(control_law2,evap,MLC_parameters.ProblemParameters.ActuationLimit,MLC_parameters.ProblemParameters.RoundEval);
  cindiv2.control_points = reshape(values,1,[]);

%% operation
  pp1 = {crossover_pts(:,end-1)',rchro1};
  pp2 = {crossover_pts(:,end-1)',rchro2};
  pp= {pp1,pp2};


end
