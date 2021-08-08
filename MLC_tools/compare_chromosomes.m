function bool = compare_chromosomes(chro1,chro2)
    % COMPARE_CHROMOSOMES compares two set of instructions.
    % if they are the same then returns bool = 1
    % otherwise it returns bool = 0
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also chromosome, MLCind.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

%% Size test
le = size(chro1,1);
if le ~=size(chro2,1)
  bool = 0;
  return
end

%% Comparison
bool = prod(prod(chro1==chro2));
end
