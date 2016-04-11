function mass()
	srcf = "mass.m";
	source(srcf);
	i = 0;
	names{++i} = "mcyl(L, varargin)";
	names{++i} = "mbox(L,W,H)";
	printf("Functions in file %s:\n", srcf);
	for k = 1 : i
		printf("\t%s\n", names{k});
	end
end


function m = mcyl(L, varargin)
	##
	## Calculate mass of steel cylinder
	##
	## Usage:
	##     mcyl(L, Dd)
	##
	## Argumets:
	##     L - cylinder height
	##     Dd - number (outer diameter) or 2-vector of numbers
	##         (outer and inner diameters)
	##
	ro = 7.85e-6;		% Í„/ÏÏ3
	if (nargin == 2 && isscalar(varargin{1}))
		D1 = varargin{1};
		D2 = 0;
	elseif (nargin == 2 && isvector(varargin{1}))
		D1 = varargin{1}(1);
		D2 = varargin{1}(2);
	elseif (nargin == 3)
		D1 = varargin{1};
		D2 = varargin{2};
	else
		error("mass: unknown data type");
	end
	Dmin = min(D1, D2);
	Dmax = max(D1, D2);
	m = pi/4 * (Dmax^2 - Dmin^2) * L * ro;
end

function m = mbox(L,W,H)
	##
	## Calculate mass of steel box LxWxH
	##
	ro = 7.85e-6;  % kg/mm3
	m = L * W * H * ro;
end
