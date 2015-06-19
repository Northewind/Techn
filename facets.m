function facets()
	source facets.m;
	i = 0;
	names{++i} = "facetProc(Z0, f, m)";
	names{++i} = "createFacet(L, angle)";
	names{++i} = "createMill(D0, D1, angle)";
	printf("Functions in file facets.m:\n");
	for k = 1 : i
		printf("\t%s\n", names{k});
	end
end


% Расчёт начальной Z1 и конечной Z2 коориданты фасочной фрезы,
% а также смещения d центра фрезы от стенки
%   Z0 - базовый уровень
%   f - фаска, созданная функцией createFacet
%   m - фреза, созданная функцией createMill
%   Zmin - минимальное предельное значение по Z,
%     ниже которого опускаться нельзя
function [Z1, Z2, d] = facetProc(Z0, f, m, Zmin=NA)
	if ((f.L > m.L) || (f.ang ~= m.ang))
		error("facetProc: mill is not applicable");
	end
	Z2 = Z0 - f.L/2 - m.L/2;
	Z1 = Z2 + f.L;
	d = -f.B/2 + mean(m.D)/2;
	% Проверка по Zmin
	if (~isna(Zmin) && (Z2 < Zmin))
		dz = Zmin - Z2;
		k = tand(f.ang);
		d -= k*dz;
		if (d < 0)
			error("facetProc: wrong geometry")
		end
		Z1 += dz;
		Z2 += dz;
	end
	Z1
	Z2
	d
end


% Создание структуры, описывающей фрезу
%   L - длина фаски (в проекции на ось Z)
%   angle - угол между фаской и осью Z (град.)
function f = createFacet(L, angle)
	f.L = L;
	f.ang = angle;
	% Длина фаски (проекция на перпендикуляр к оси Z):
	f.B = L*tand(angle);
end


% Создание структуры, описывающей фрезу
%   D0 - диаметр внутренний
%   D1 - наружный диаметр
%   angle - угол между кромкой и осью Z (град.)
function m = createMill(D0, D1, angle)
	D = abs([D0, D1]);
	m.D = [min(D),  max(D)];
	m.ang = angle;
	m.B = abs(D1 - D0)/2;
	m.L = m.B / tand(angle);
end
