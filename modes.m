function modes()
	srcf = "modes.m";
	source(srcf);
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
	printf("Functions in file %s:\n", srcf);
	for k = 1 : i
		printf("\t%s\n", names{k});
	end
end


function S = Scut(Ra, r, Smax=NA)
	%% Вычисление чистовой подачи (по шероховатости)
	%%
	%% Usage:
	%%     S = Scut(Ra, r, Smax=NA)
	%%
	S = 0.14 * sqrt(Ra .* r);	
	if (~isna(Smax))
		S = min(S, Smax);
	end
end


function f = ScutDrill(D, Smax=NA)
	%% Вычисление подачи при сверлении монолитным тв/сплавным сверлом D
	%%
	%% Usage:
	%%     f = ScutDrill(D, Smax=NA)
	%%
	f = 0.015 * D;
	if (~isna(Smax))
		f = min(S, Smax);
	end
end


function v = Vcut(D, n, n_max=NA)
	%% Скорость резания
	%%
	%% Usage:
	%%     v = Vcut(D, n, n_max=NA)
	%%
	if (~isna(n_max))
		n = (n <= n_max).*n  +  (n > n_max).*n_max;
	end
	if (numel(D) ~= numel(n))
		D = mean(D);
	end
	v = pi*D.*n / 1000;
end


function n = ncut(D, V, n_max=NA)
	%% Частота вращения, об/мин
	%%
	%% Usage:
	%%     n = ncut(D, V, n_max=NA)
	%%
	n = 1000 * V / pi ./ D;
	if (~isna(n_max))
		n = min(n,  n_max);
	end
end


function f = Sm(D, S, n_max, V)
	%% Минутная подача, мм/мин
	%%
	%% Usage:
	%%     f = Sm(D, S, n_max, V)
	%%
	f = S * ncut(D,V,n_max);
end


function D = Dcut(V, n, n_max=NA)
	%% Диаметр обработки
	%%
	%% Usage:
	%%     D = Dcut(V, n, n_max=NA)
	%%
	if (~isna(n_max))
		n = (n <= n_max).*n  +  (n > n_max).*n_max
	end
	if (numel(V) ~= numel(V))
		V = mean(V);
	end
	D = 1000*V./n/pi;
end


function L = Lstruc(mainPath, D, pre, pst, jmp);
	%% Создание структуры параметров перемещения
	%%
	%% Usage:
	%%     L = Lstruc(mainPath, D, pre, pst, jmp)
	%%
	%% Arguments:
	%%     mainPath - длина основного хода
	%%     D        - вектор с координатами [Dfrom Dto]
	%%     pre      - недобег
	%%     pst      - перебег
	%%     jmp      - отскок
	%%
	L.main = mainPath;
	L.D0 = min(D);
	L.D1 = max(D);
	L.pre = pre;
	L.pst = pst;
	L.jmp = jmp;
end


function time = longT(D, L, i, S, n_max, V)
	%% Вычисление машинного основного времени при продольном точении
	%%
	%% Usage:
	%%     time = longT(D, L, i, S, n_max, V)
	%%
	if (ismatrix(D))
		if (numel(D) == 2)
			D = idiams(D,i);
		end;
		time = 0;
		path = lngth(L,1);
		time = sum(path ./ Sm(D,S,n_max,V));
	else
		time = lngth(L,i) / Sm(D, S, n_max, V);
	end
end

function time = crossT(D, i, S, n_max, V)
	%% Вычисление машинного основного времени при поперечном точении
	%%
	%% Usage:
	%%     time = crossT(D, i, S, n_max, V)
	%%
	%% Arguments:
	%%     D     - вектор с координатами [Dfrom Dto]
	%%     i     - число проходов
	%%     S     - подача, мм/об
	%%     n_max - максимальная частота вращения шпинделя, об/мин
	%%     V     - скорость резания, м/мин
	%%
	% Вывод формулы:
	%  n(D)  = 1000 * V / pi / D
	%  Sm(D) = n(D) * S
	%  dT = dD / Sm(D)
	%  T  = integral( dD / Sm(D), Dmin, Dmax)
	%  T  = pi / 2000 / S / V * (Dmax^2 - Dmin^2)
	dTD = @(D)           1 ./ Sm(D, S, n_max, V);
	Tm  = @(Dmin, Dmax)  quad( dTD, Dmin, Dmax) / 2;
	time = Tm(min(D), max(D)) * i;
end


function time = longTfast(L, i, Ss)
	%% Вычисление машинного вспомогательного времени при продольном точении
	%%
	%% Usage:
	%%    time = longTfast(L, i, Ss) 
	%%
	%% Arguments:
	%%    L  - структура пути (см. Lstruc)
	%%    i  - число проходов
	%%    Ss - скорость быстрых перемещений, мм/мин
	%%
	time = lngth(L, i) / Ss;
end


function time = crossTfast(L, i, Ss)
	%% Вычисление машинного вспомогательного времени при поперечном точении
	%%
	%% Usage:
	%%     time = crossTfast(L, i, Ss)
	%%
	%% Arguments:
	%%     L  - структура пути (см. Lstruc)
	%%     i  - число проходов
	%%     Ss - скорость быстрых перемещений, мм/мин
	%%
	dmax = max(L.D0, L.D1) + 2*L.pre;
	dmin = min(L.D0, L.D1) - 2*L.pst;
	Lw = (dmax - dmin)/2 * i + 2*L.jmp;
	time = Lw / Ss;
end


function p = lngth(L, i)
	%% Вычисление длины хода (рабочего или вспомогательного)
	%%
	%% Usage:
	%%     p = lngth(L, i)
	%%
	%% Returns:
	%%     L - структура / вектор, содержащая поля:
	%%         pre  - недобег
	%% 	       main - длина рабочего хода
	%%         pst  - перебег
	%%         jmp  - отскок
	%%
	if (isa(L, "numeric"))
		p = L;
	elseif (isstruct(L))
		flds = {"pre", "main", "pst", "jmp"};
		for k = 1 : numel(flds)
			if ( ~isfield(L, flds{k}) )
				L.(flds{k}) = 0;
			end
		end
		p = L.pre + L.main + L.pst + 2*L.jmp;
	elseif (isvector(L))
		if (numel(L) < 4)
			L(end+1:4) = 0;
		end
		p = L(1) + L(2) + L(3) + 2*L(4);
	else
		error("lngth: unsupported data type");
	end
	p *= i;
end


function Ds = tdiams(D, t)
	%% Определение диаметров для многопроходного точения
	%%
	%% Usage:
	%%     Ds = tdiams(D, t)
	%%
	%% Arguments:
	%%     D - вектор с координатами [Dfrom Dto]
	%%     t - глубина точения
	%%
	Ds = [max(D) : -2*t : min(D)];
end


function Ds = idiams(D, i)
	%% Определение диаметров для многопроходного точения
	%%
	%% Usage:
	%%     Ds = idiams(D, i)
	%%
	%% Arguments:
	%%     D - вектор с координатами [Dfrom Dto]
	%%     i - число проходов
	%%
	Ds = linspace(max(D), min(D), i);
end


function t = tmax(insertType, insertLength)
	%% Определение максимальной глубины резания для пластины
	%%
	%% Usage:
	%%     t = tmax(insertType, insertLength)
	%%
	%% Arguments:
	%%     insertType   - тип пластины - символ из V,D,K,T,W,C,S.
	%%     insertLength - типоразмер пластины (длина кромки)
	%%
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

