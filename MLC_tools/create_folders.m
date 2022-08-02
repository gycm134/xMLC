function create_folders(name)
    % Creates the needed folders to save an MLC run.
    %
    % Guy Y. Cornejo Maceda, 2022/07/01
    %
    % See also chromosome, MLCind.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % The MIT License (MIT)

%% Other folders
    dir = ['save_runs/',name];
    % Save folder
    if not(exist(dir,'dir')),mkdir(dir);end
    % Figures
    if not(exist([dir,'/Figures'],'dir')),mkdir([dir,'/Figures']);end

end %method
