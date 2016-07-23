function mass()
	srcf = "mass.m";
	source(srcf);
	i = 0;
	names{++i} = "mcyl(l, D)";
	names{++i} = "mbox(l, w, h)";
	printf("Functions in file %s:\n", srcf);
	for k = 1 : i
		printf("\t%s\n", names{k});
	end
end


function m = mcyl(l, varargin)
	%% Calculate mass of steel cylinder
	%%
	%% Usage:
	%%     m = mcyl(l, d)
	%%     m = mcyl(l, [D d])
	%%     m = mbox(l, w, h)
	if (nargin == 2 && isscalar(varargin{1}))
		d1 = varargin{1};
		d2 = 0;
	elseif (nargin == 2 && isvector(varargin{1}))
		d1 = varargin{1}(1);
		d2 = varargin{1}(2);
	elseif (nargin == 3)
		d1 = varargin{1};
		d2 = varargin{2};
	else
		error("mass: invalid args.");
	end
	m = pi/4 * abs(d1^2 - d2^2) * l * 7.85e-6;
end


function m = mbox(l, w, h)
	%% Calculate mass of steel box LxWxH
	%%
	%% Usage:
	%%     m = mbox(l, w, h)
	m = l * w * h * 7.85e-6;
end

