function save_octave(MLC,AuxName)
    % SAVE save method for MLC.
    % Saves the MLC object (MLC) in the save_runs folder with the its name.
    % To load the MLC object : MLC.load('NameOfMyRun');
    % This method is made for Octave only
    %
    % Guy Y. Cornejo Maceda, 01/31/2020
    %
    % See also MLC, go, @MLC/load_MLC.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

%% Parameters
    Name = MLC.parameters.Name;
    if nargin<2,SaveName='MLC';else,SaveName=AuxName;end
    MLC.parameters.LastSave = [MLC.parameters.LastSave;date];
    NGen = MLC.generation;
    TabNumber = MLC.table.number;
    
%% Folders
    % create them
    create_folders(Name);

%% Save
    % Population
    % Individuals
    for p=1:NGen
        population(p).individuals = MLC.population(p).individuals;
        population(p).costs = MLC.population(p).costs;
        population(p).chromosome_lengths = MLC.population(p).chromosome_lengths;
        population(p).parents = MLC.population(p).parents;
        population(p).operation = MLC.population(p).operation;
     % Population
        population(p).generation = MLC.population(p).generation;
        population(p).evaluation = MLC.population(p).evaluation;
     % Individuals
        population(p).CreationOrder = MLC.population(p).CreationOrder;
    end
    MLC_Octave.population = population;
    
    MLC_Octave.parameters = MLC.parameters;
    MLC_Octave.parameters.LastSave = [MLC.parameters.LastSave;date];

    % Table
    for q=1:TabNumber
    % Individuals
        individuals(q).chromosome = MLC.table.individuals(q).chromosome;
        individuals(q).cost = MLC.table.individuals(q).cost;
        individuals(q).control_law = MLC.table.individuals(q).control_law;
        individuals(q).EI = MLC.table.individuals(q).EI;
        individuals(q).occurences = MLC.table.individuals(q).occurences;
        individuals(q).evaluation_time = MLC.table.individuals(q).evaluation_time;
        individuals(q).hash = MLC.table.individuals(q).hash;
        individuals(q).control_points = MLC.table.individuals(q).control_points;
        individuals(q).ref = MLC.table.individuals(q).ref;
    end
        Octable.individuals = individuals;
        Octable.non_redundant = MLC.table.non_redundant;
    % Number
        Octable.number = MLC.table.number;
    % Individual information
        Octable.hashlist = MLC.table.hashlist;
        Octable.control_points = MLC.table.control_points;
        Octable.costlist = MLC.table.costlist;
    MLC_Octave.Octable = Octable;

          
    MLC_Octave.generation = MLC.generation;
    
    MLC_Octave.version = MLC.version;
    
    % Version
    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;

    % Save
    direc = ['save_runs/',Name];
    SaveMLC = [direc,'/',SaveName,'_Octave.mat'];
    if isOctave
      save(SaveMLC,'MLC_Octave','-mat7-binary')
    else
      save(SaveMLC,'MLC_Octave')
    end
    
end

