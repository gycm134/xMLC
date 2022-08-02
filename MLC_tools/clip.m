function val_out=clip(val_in,val_min,val_max)
    % CLIP Limits the action between a minimum and a maximum.
    %
    % Guy Y. Cornejo Maceda, 2022/07/01
    %
    % See also strrep_cl, limit_to.

    % Copyright: 2022 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % The MIT License (MIT)

val_out = val_in;
val_out(val_in>val_max) = val_max;
val_out(val_in<val_min) = val_min;
