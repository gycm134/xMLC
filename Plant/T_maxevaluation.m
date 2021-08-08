function out=T_maxevaluation(Tmax,Tnow)
	% T_MAXEVALUATION function that gives and error if Tnow > Tmax
	%
	% Guy Y. Cornejo Maceda, 07/18/2020
	%
	% See also read, mat2lisp, simplify_my_LISP.

	% Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
	% CC-BY-SA
	% inspired by Thomas Duriez
	
if Tnow>Tmax
	error('Computation took to much time (>%i s).',Tmax)
end
out=0;
