function modes()
	source modes.m;
	i = 0;
	names{++i} = "Scut(Ra, r, Smax=NA)";
	names{++i} = "ScutDrill(D, Smax=NA)";
	names{++i} = "Vcut(D, n, n_max=NA)";
	names{++i} = "ncut(D, V, n_max=NA)";
	names{++i} = "Sm(D, S, n_max, V)";
	names{++i} = "Dcut(V, n, n_max=NA)";
	names{++i} = "Lstruc(mainPath, D, pre, pst, jmp)";
	names{++i} = "longT(D, L, i, S, n_max, V)";
	names{++i} = "crossT(D, i, S, n_max, V)";
	names{++i} = "longTfast(L, i, Ss)";
	names{++i} = "crossTfast(D0, D1, L, i, Ss)";
	names{++i} = "lngth(L, i)";
	names{++i} = "tdiams(D, t)";
	names{++i} = "idiams(D, i)";
	names{++i} = "tmax(insertType, insertLength)";
	printf("Functions in file modes.m:\n");
	for k = 1 : i
		printf("\t%s\n", names{k});
	end
end

% Вычисление чистовой подачи (по шероховатости)
function S = Scut(Ra, r, Smax=NA)
	S = 0.14 * sqrt(Ra .* r);	
	if (~isna(Smax))
		S = min(S, Smax);
	end
end

% Вычисление подачи при сверлении монолитным тв/сплавным сверлом D
function S = ScutDrill(D, Smax=NA)
	S = 0.015 * D;
	if (~isna(Smax))
		S = min(S, Smax);
	end
end

% Скорость резания
function V = Vcut(D, n, n_max=NA)
	if (~isna(n_max))
		n = (n <= n_max).*n  +  (n > n_max).*n_max;
	end
	if (numel(D) ~= numel(n))
		D = mean(D);
	end
	V = pi*D.*n / 1000;
end

% Частота вращения, об/мин
function n = ncut(D, V, n_max=NA)
	n = 1000 * V / pi ./ D;
	if (~isna(n_max))
		n = min(n,  n_max);
	end
end

% Минутная подача, мм/мин
function Sm = Sm(D, S, n_max, V)
	Sm = S * ncut(D,V,n_max);
end

% Диаметр обработки
function D = Dcut(V, n, n_max=NA)
	if (~isna(n_max))
		n = (n <= n_max).*n  +  (n > n_max).*n_max
	end
	if (numel(V) ~= numel(V))
		V = mean(V);
	end
	D = 1000*V./n/pi;
end

% Создание структуры параметров перемещения
%   mainPath - длина основного хода
%   D - вектор с координатами [Dfrom Dto]
%   pre - недобег
%   pst - перебег
%   jmp - отскок
function L = Lstruc(mainPath, D, pre, pst, jmp);
	L.main = mainPath;
	L.D0 = min(D);
	L.D1 = max(D);
	L.pre = pre;
	L.pst = pst;
	L.jmp = jmp;
end

% Вычисление машинного основного времени при продольном точении
function time = longT(D, L, i, S, n_max, V)
	if (ismatrix(D))
		if (numel(D) == 2)
			D = idiams(D,i);
		end;
		time = 0;
		path = lngth(L,1);
		time = sum( path ./ Sm(D,S,n_max,V) );
	else
		time = lngth(L,i)  /  Sm(D, S, n_max, V);
	end
end

% Вычисление машинного основного времени при поперечном точении
% D - вектор с координатами [Dfrom Dto]
function time = crossT(D, i, S, n_max, V)
	% Вывод:
	%  n(D)  = 1000 * V / pi / D
	%  Sm(D) = n(D) * S
	%  dT = dD / Sm(D)
	%  T  = integral( dD / Sm(D), Dmin, Dmax)
	%  T  = pi / 2000 / S / V * (Dmax^2 - Dmin^2)
	dTD = @(D)           1 ./ Sm(D, S, n_max, V);
	Tm  = @(Dmin, Dmax)  quad( dTD, Dmin, Dmax) / 2;
	time = Tm(min(D), max(D)) * i;
end

% Вычисление машинного вспомогательного времени при продольном точении
% L - структура пути (см. Lstruc)
% Ss - скорость быстрых перемещений, мм/мин
function res = longTfast(L, i, Ss)
	res = lngth(L, i) / Ss;
end

% Вычисление машинного вспомогательного времени при поперечном точении
% L - структура пути (см. Lstruc)
% Ss - скорость быстрых перемещений, мм/мин
function res = crossTfast(L, i, Ss)
	dmax = max(L.D0, L.D1) + 2*L.pre;
	dmin = min(L.D0, L.D1) - 2*L.pst;
	Lw = (dmax - dmin)/2 * i + 2*L.jmp;
	res = Lw / Ss;
end

% Вычисление длины хода (рабочего или вспомогательного)
% L - структура / вектор, содержащая поля:
%   pre  - недобег
%   main - длина рабочего хода
%   pst  - перебег
%   jmp  - отскок
function res = lngth(L, i)
	if (isa(L, "numeric"))
		res = L;
	elseif (isstruct(L))
		flds = {"pre", "main", "pst", "jmp"};
		for k = 1 : numel(flds)
			if ( ~isfield(L, flds{k}) )
				L.(flds{k}) = 0;
			end
		end
		res = L.pre + L.main + L.pst + 2*L.jmp;
	elseif (isvector(L))
		if (numel(L) < 4)
			L(end+1:4) = 0;
		end
		res = L(1) + L(2) + L(3) + 2*L(4);
	else
		error("lngth: unsupported data type");
	end
	res *= i;
end

% Определение диаметров для многопроходной обработки
% D - вектор с координатами [Dfrom Dto]
function D = tdiams(D, t)
	D = [max(D) : -2*t : min(D)];
end
function D = idiams(D, i)
	D = linspace(max(D), min(D), i);
end

% Определение максимальной глубины резания для пластины
%	insertType - тип пластины (символ)
%	insertLength - типоразмер пластины (длина кромки)
function t = tmax(insertType, insertLength)
	if (~ischar(insertType) || ~isnumeric(insertLength))
		error("tmax: invalid data type");
	end
	insertType = toupper(insertType);
	k = 0;
	switch insertType
		case {"V" "D" "K"}
			k = 0.25;
		case {"T"}
			k = 0.33;
		case {"W"}
			k = 0.5;
		case {"C" "S"}
			k = 0.66;
		otherwise
			error("tmax: unknown insert type");
	end
	t = k * insertLength;
end
