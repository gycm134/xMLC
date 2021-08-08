function matJ = External_build_matJ(MLC_parameters,Gen)
    % EXTERNAL_EVALUATION completes the evaluation of the individuals for external evaluations
    % Retrieves the cost information of each control law from GenXpopulation.mat,
    % X being the generation Gen.
    % There should be a file per control law.
    % Thus the file GenXIndY.dat contains two floats (Ja and Jb) corresponding
    % to the cost of individual in line Y in the GenXpopulation.mat and generation X.
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also external_evaluation, External_evaluation_CONTINUE, External_evaluation_END.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

%% Parameters
    PopSize = MLC_parameters.PopulationSize;
    PathExt = MLC_parameters.ProblemParameters.PathExt;
    gamma = MLC_parameters.ProblemParameters.gamma;
    
%% Allocation
    Jcomponents = NaN(PopSize,numel(gamma)+1);
    
%% Data loading
    for i=1:PopSize
        filename = ['Gen',num2str(Gen),'Ind',num2str(i),'.dat'];
        costfile = fullfile(PathExt,filename);
        if exist(costfile,'file')
            Jcomponents(i,:) = load(costfile,'-ascii');
        else
            Jcomponents(i,:) = MLC_parameters.BadValue*ones(1,numel(gamma)+1); %If the evaluation fails the value of 10+31 is given which a purposely high value
        end

    end
    matJ = Jcomponents;

disp('matJ computed!')

end
