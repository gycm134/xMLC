function q=my_log(x)
    % MY_LOG customized version of log
    %
    %
    % See also my_div, my_log, opset.

    % Copyright (C) 2015-2019 Thomas Duriez.
    % This file is part of the OpenMLC-Matlab-2 Toolbox. Distributed under GPL v3.

protection = 1e-3;
q=log10(abs(x).*(abs(x)>=protection)+protection*(abs(x)<protection));
end
