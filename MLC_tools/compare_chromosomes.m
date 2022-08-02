function bool = compare_chromosomes(chro1,chro2)
    % COMPARE_CHROMOSOMES compares two set of instructions.
    % if they are the same then returns bool = 1
    % otherwise it returns bool = 0
    %
    % Guy Y. Cornejo Maceda, 2022/07/01
    %
    % See also chromosome, MLCind.

    % Copyright: 2022 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % The MIT License (MIT)

%% Size test
le = size(chro1,1);
if le ~=size(chro2,1)
  bool = 0;
  return
end

%% Comparison
bool = prod(prod(chro1==chro2));
end
