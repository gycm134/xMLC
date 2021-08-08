function MLC3 = rename(MLC3,NewName)
% MLC3 class rename method
% Change the name of the run
%
% Guy Y. Cornejo Maceda, 08/27/209
%
% See also MLC3.

% Copyright: 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
% CC-BY-SA

%% Parameters
    Name = MLC3.parameters.Name;
     % Version
    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
    
%% Test
    if exist(['save_runs/',NewName],'dir')
        error('This run already exist')
    end
    
%% Change name
    system(['mv save_runs/',Name,' save_runs/',NewName]);
    MLC3.parameters.Name = NewName;
    % Save
    if isOctave
      MLC3.save_octave;
    else
      MLC3.save_matlab;
    end
    fprintf('%s changed to %s\n',Name,NewName)

%% Update properties

end %method
