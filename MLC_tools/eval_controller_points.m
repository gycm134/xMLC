function values=eval_controller_points(controllaw,evap,actuation_limit,to_round)
    % EVAL_CONTROLLER_POINTS evaluates the (N) control law(s) in b on the (P)
    % evaluation points in evap and gives an nxp matrix of the values of the
    % OutputNumber at those points.
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also MLCtable, find_redundant.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA


%% Initilization
  N = size(controllaw,1);
  P = size(evap,2);
  values = zeros(N,P);

%% Constants
    PHI = 1.61803398875;

%% limitation
    controllaw = limit_to(controllaw,actuation_limit);

%% Evalute
try
for n=1:N
    bx = controllaw{n};
                % definition
    eval(['bf = @(t,s)(' bx ');']);
    for p=1:P
        values(n,p) = round(bf(evap(1,p),evap(2:end,p))*10^to_round)/10^to_round;
    end
end

catch err
    values = NaN(N,P);
    fprintf(err.message);
    fprintf('\n');
end
