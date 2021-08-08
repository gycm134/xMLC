    % Initialization script.
    % It loads all the useful paths and create and MLC object.
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also External_evaluation_START, External_evaluation_CONTINUE, External_evaluation_END

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

%% Load Paths
% Tools
    addpath('MLC_tools');
% Plant
    addpath(genpath('Plant'));
% ODE_solvers
    addpath('ODE_Solvers')

%% Show more
    more off;

%% MATLAB options
    % Version
    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
    % Save
    if not(isOctave)
      rng('shuffle');
    end

%% Information display
% Header
fprintf('====================== ')
fprintf('xMLC v0.10')
fprintf(' ==================\n')
% Version
disp(' Welcome to the xMLC software to solve non-convex')
disp(' regression problems.')
% Link
    disp(' In case of error please contact the author :')
    X = '  <a href = "https://www.cornejomaceda.com">Guy Y. Cornejo Maceda Website</a>';
    disp(X)
    fprintf('\n')
% Start
disp(' Start by creating a MLC object with : mlc=MLC;')
% Foot
fprintf('===========================')
fprintf('==========================\n')
fprintf('\n')

%% Initialization
%     mlc=MLC;
    
