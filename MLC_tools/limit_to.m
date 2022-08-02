function boutput=limit_to(b,act_lim,fortran_evaluation)
    % LIMIT_TO Add threshold function to each control law
    % Should be used after the strrep_cl !
    %
    % Guy Y. Cornejo Maceda, 2022/07/01
    %
    % See also MyPlant_problem.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % The MIT License (MIT)

if nargin<3
    fortran_evaluation=0;
end

if fortran_evaluation
    fprintf('not coded yet ...');
end

boutput = cell(size(b,1),1);
for p=1:size(b,1)
    bs = b{p};
    % limits
    val_min = num2str(act_lim(p,1));
    val_max = num2str(act_lim(p,2));
    % fortran syntax
    if fortran_evaluation
        val_min=[val_min,'D0'];
        val_max=[val_max,'D0'];
    end
    boutput{p} = ['clip(',bs,',',val_min,',',val_max,')'];
end
