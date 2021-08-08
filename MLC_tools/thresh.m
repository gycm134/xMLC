function val_out=thresh(val_in,val_min,val_max)
    % THRESH Limits the action between a minimum and a maximum.
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also strrep_cl, limit_to.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

val_out = val_in;
val_out(val_in>val_max) = val_max;
val_out(val_in<val_min) = val_min;
