function sizes()
	srcf = "sizes.m";
	source(srcf);
	i = 0;
	names{++i} = "dev2lim(varargin)";
	names{++i} = "splus(varargin)";
	names{++i} = "tol(s)";
	printf("Functions in file %s:\n", srcf);
	for k = 1 : i
		printf("\t%s\n", names{k});
	end
end

% Создать размер
function s_res = dev2lim(varargin)
	if (nargin == 1 && isvector(varargin{1}))
		devs = varargin{1}(2:3);
		nom = varargin{1}(1);
	elseif (nargin == 3)
		devs = [varargin{2}, varargin{3}];
		nom = varargin{1};
	else
		error("dev2lim");
	end;
	low = min(devs);
	upp = max(devs);
	s_res(1) = nom + low;
	s_res(2) = nom + upp;
end;

% Сумма размеров
function s = splus(varargin)
	lowLim = min(varargin{1});
	uppLim = max(varargin{1});
	for i = 2 : length(varargin)
		lowLim = lowLim + min(varargin{i});
		uppLim = uppLim + max(varargin{i});
	end;
	s = [lowLim uppLim];
end

% Допуск
function t = tol(s)
	t = max(s) - min(s);
end
