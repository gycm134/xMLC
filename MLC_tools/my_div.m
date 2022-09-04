function q=my_div(x,y)
    % MY_DIV customized version of division
    %
    %
    % See also my_exp, my_log, opset.

    % Copyright (C) 2015-2019 Thomas Duriez.
    % This file is part of the OpenMLC-Matlab-2 Toolbox. Distributed under GPL v3.

protection = 1e-3;

y(y==0)=inf;
q=x./(y.*(abs(y)>protection)+protection*sign(y).*(abs(y)<=protection));
end
