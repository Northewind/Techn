function facets()
	srcf = "facets.m";
	source(srcf);
	i = 0;
	names{++i} = "facetProc(f, m)";
	names{++i} = "createFacet(L, angle)";
	names{++i} = "createMill(D0, D1, angle)";
	printf("Functions in file %s:\n", srcf);
	for k = 1 : i
		printf("\t%s\n", names{k});
	end
end


function [Z, d] = facetProc(f, m, Zmin=NA)
	## Расчёт смещения по Z фасочной фрезы от верхней плоскости,
	##   а также смещения d центра фрезы от стенки
	##
	## Использование:
	##   facetProc(f,m[,Zmin])
	##
	## Параметры:
	##   f - фаска, созданная createFacet()
	##   m - фреза, созданная createMill()
	##   Zmin - минимальное предельное значение по Z,
	##     ниже которого опускаться нельзя
	##
	if ((f.L > m.L) || (f.ang ~= m.ang))
		error("facetProc: mill is not applicable");
	end
	Z = - f.L/2 - m.L/2;
	d = -f.B/2 + mean(m.D)/2;
	# Проверка по Zmin
	if (~isna(Zmin) && (Z < Zmin))
		dz = Zmin - Z;
		d -= tand(f.ang)*dz;
		if (d < 0)
			error("facetProc: wrong geometry")
		end
		Z += dz;
	end
	printf("Plane offset: %g,  wall offset: %g\n", Z, d);
end


function f = createFacet(L, angle)
	## Создание структуры, описывающей фрезу
	##
	## Параметры:
	##   L - длина фаски (в проекции на ось Z)
	##   angle - угол между фаской и осью Z (град.)
	##
	f.L = L;
	f.ang = angle;
	# Длина фаски (проекция на перпендикуляр к оси Z):
	f.B = L*tand(angle);
end


function m = createMill(D0, D1, angle)
	## Создание структуры, описывающей фрезу
	##
	## Параметры:
	##   D0 - диаметр внутренний
	##   D1 - наружный диаметр
	##   angle - угол между кромкой и осью Z (град.)
	##
	D = abs([D0, D1]);
	m.D = [min(D),  max(D)];
	m.ang = angle;
	m.B = abs(D1 - D0)/2;
	m.L = m.B / tand(angle);
end
