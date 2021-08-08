function NewSyntaxCL = strrep_cl(MLC_parameters,ControlLaw,TypeOfReplacement)
    % STRREP_PRETESTING Changes the inputs of the control laws for pretesting
    %
    %
    % Guy Y. Cornejo Maceda, 03/03/2020
    %
    % See also tresh, limit.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

%% Parameters
    NI = MLC_parameters.ProblemParameters.OutputNumber;
    NO = MLC_parameters.ProblemParameters.InputNumber;
    NS = MLC_parameters.ProblemParameters.NumberSensors;
    NTDF = MLC_parameters.ProblemParameters.NumberTimeDependentFunctions;
    
%% Initialization
    Sensors = cell(1,NS);
    TDF = cell(1,NTDF);
        for p=1:NS,Sensors{p} = ['s(',num2str(p),')'];end
        for p=1:NTDF,TDF{p} = ['h(',num2str(p),')'];end
    OldSyntax = horzcat(Sensors,TDF);

%% Change syntax            
    NewSyntaxCL = cell(NI,1);
    if TypeOfReplacement==1 % MATLAB/Octave syntax
        if NTDF > 0
            TDF = MLC_parameters.ProblemParameters.TimeDependentFunctions(1,:);
        end
    elseif TypeOfReplacement==2 % Problem syntax
        if NS > 0
            Sensors = MLC_parameters.ProblemParameters.Sensors;
        end
        if NTDF > 0
            TDF = MLC_parameters.ProblemParameters.TimeDependentFunctions(2,:);
        end
    end
    NewSyntax = horzcat(Sensors,TDF);

%% Test
    if numel(OldSyntax) ~= numel(NewSyntax),error('Number functions not consistent.'),end
    if numel(OldSyntax) ~= NO,error('Number functions not consistent!'),end
    
%% Loop for replacement
  for Controlleri=1:NI
      ControlStringExpr = ControlLaw{Controlleri};
      for p=1:NO
          ControlStringExpr=strrep(ControlStringExpr,OldSyntax{p},NewSyntax{p});
      end
      NewSyntaxCL{Controlleri} = ControlStringExpr;
  end


end
