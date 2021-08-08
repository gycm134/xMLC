function q=my_div(x,y)
    % MY_DIV customized version of division
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also my_exp, my_log, opset.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

protection = 1e-3;

y(y==0)=inf;
q=x./(y.*(abs(y)>protection)+protection*sign(y).*(abs(y)<=protection));
end
