function sizes()
	srcf = "sizes.m";
	source(srcf);
	i = 0;
	names{++i} = "sdev2lim(varargin)";
	names{++i} = "splus(varargin)";
	names{++i} = "stol(s)";
	printf("Functions in file %s:\n", srcf);
	for k = 1 : i
		printf("\t%s\n", names{k});
	end
end

function s_res = sdev2lim(varargin)
	## Convert arguments to 2-vector of limiting sizes
	##
	## Usage:
	##     sdev2lim([nom dev1 dev2=0])
	##     sdev2lim(nom, dev1, dev2=0)
	if (nargin == 1 && length(varargin{1}) == 2)
		devs = [varargin{1}(2), 0];
		nom = varargin{1}(1);
	elseif (nargin == 1 && length(varargin{1}) == 3)
		devs = varargin{1}(2:3);
		nom = varargin{1}(1);
	elseif (nargin == 2)
		devs = [varargin{2}, 0];
		nom = varargin{1};
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

function s = splus(varargin)
	## Sum of sizes
	lowLim = min(varargin{1});
	uppLim = max(varargin{1});
	for i = 2 : length(varargin)
		lowLim = lowLim + min(varargin{i});
		uppLim = uppLim + max(varargin{i});
	end;
	s = [lowLim uppLim];
end

function t = stol(s)
	## Calculate tolerance of the size s
	t = max(s) - min(s);
end
