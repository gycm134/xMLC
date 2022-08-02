function q=my_log(x)
    % MY_LOG customized version of log
    %
    % Guy Y. Cornejo Maceda, 2022/07/01
    %
    % See also my_div, my_log, opset.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % The MIT License (MIT)

protection = 1e-3;
q=log10(abs(x).*(abs(x)>=protection)+protection*(abs(x)<protection));
end
