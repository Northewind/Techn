function mass()
	source mass.m;
	i = 0;
	names{++i} = "cyl(L, varargin)";
	names{++i} = "box(L,W,H)";
	printf("Functions in file mass.m:\n");
	for k = 1 : i
		printf("\t%s\n", names{k});
	end
end


% Вычисление массы стальной втулки, кг
%   L - длина втулки
%   D0 и D1, или [D0 D1] - наружный и внутренний диаметр
function m = cyl(L, varargin)
	ro = 7.85e-6;		% кг/мм3
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

% Вычисление массы кубика (LxWxH, мм3), кг
function m = box(L,W,H)
	ro = 7.85e-6;  % кг/мм3
	m = L * W * H * ro;
end