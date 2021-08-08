function create_folders(name)
    % Creates the needed folders to save an MLC run.
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also chromosome, MLCind.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

%% Other folders
    dir = ['save_runs/',name];
    % Save folder
    if not(exist(dir,'dir')),mkdir(dir);end
    % Figures
    if not(exist([dir,'/Figures'],'dir')),mkdir([dir,'/Figures']);end

end %method
