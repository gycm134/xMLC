function MLC = load_octave(MLC,Name,AuxName)
    % LOAD Load method for MLC.
    % Loads the MLC object (MLC) from the save_runs folder.
    % To load the MLC object : MLC.load('NameOfMyRun');
    % This method is made for octave only
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also MLC, go, @MLC/save_MLC.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA
%% Load 
    if nargin<3,LoadName='MLC';else,LoadName=AuxName;end
    LoadMLC = ['save_runs/',Name,'/',LoadName,'_Octave.mat'];
    tmp = load(LoadMLC);
    
%% Parameters
    TabNumber = tmp.MLC_Octave.Octable.number;
    NGen = tmp.MLC_Octave.generation;
    PopSize = tmp.MLC_Octave.parameters.PopulationSize;

    % Population
    for p=1:NGen
        pop = MLCpop(1,PopSize);
        pop.individuals = tmp.MLC_Octave.population(p).individuals;
        pop.costs = tmp.MLC_Octave.population(p).costs;
        pop.chromosome_lengths = tmp.MLC_Octave.population(p).chromosome_lengths;
        pop.parents = tmp.MLC_Octave.population(p).parents;
        pop.operation = tmp.MLC_Octave.population(p).operation;
     % Population
        pop.generation = tmp.MLC_Octave.population(p).generation;
        pop.evaluation = tmp.MLC_Octave.population(p).evaluation;
     % Individuals
        pop.CreationOrder = tmp.MLC_Octave.population(p).CreationOrder;
        population(p) = pop;
    end
        MLC.population = population;
     % Parameters
    MLC.parameters = tmp.MLC_Octave.parameters;
    MLC.parameters.Name = Name;
    
    % Table
    for q=1:TabNumber
      indiv = MLCind;
      indiv.chromosome = tmp.MLC_Octave.Octable.individuals(q).chromosome;
      indiv.cost = tmp.MLC_Octave.Octable.individuals(q).cost;
      indiv.control_law = tmp.MLC_Octave.Octable.individuals(q).control_law;
      indiv.EI = tmp.MLC_Octave.Octable.individuals(q).EI;
      indiv.occurences = tmp.MLC_Octave.Octable.individuals(q).occurences;
      indiv.evaluation_time = tmp.MLC_Octave.Octable.individuals(q).evaluation_time;
      indiv.hash = tmp.MLC_Octave.Octable.individuals(q).hash;
      indiv.control_points = tmp.MLC_Octave.Octable.individuals(q).control_points;
      indiv.ref = tmp.MLC_Octave.Octable.individuals(q).ref;
      MLC.table.individuals(q) = indiv;
    end
      MLC.table.non_redundant = tmp.MLC_Octave.Octable.non_redundant;
    % Number
      MLC.table.number = tmp.MLC_Octave.Octable.number;
    % Individual information
      MLC.table.hashlist = tmp.MLC_Octave.Octable.hashlist;
      MLC.table.costlist = tmp.MLC_Octave.Octable.costlist;
      MLC.table.control_points = tmp.MLC_Octave.Octable.control_points;
    % Generation
    MLC.generation = tmp.MLC_Octave.generation;
    % Version
    MLC.version = tmp.MLC_Octave.version;

%% Update properties
    MLC.show_problem;

end
