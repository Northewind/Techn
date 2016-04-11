function facets()
	srcf = "facets.m";
	source(srcf);
	i = 0;
	names{++i} = "fcirc(Dmill, Dpre, L, angle, Zmin=NA)";
	names{++i} = "fproc(f, m, Zmin=NA)";
	names{++i} = "fcreate(L, angle)";
	names{++i} = "fmill(D0, D1, angle)";
	printf("Functions in file %s:\n", srcf);
	for k = 1 : i
		printf("\t%s\n", names{k});
	end
end


function res = fcirc(Dmill, Dpre, L, angle, Zmin=NA)
	## CNC code for facet processing in the circular hole.
	##
	## Usage:
	##     fcnc(Dmill, Dpre, L, angle, Zmin=NA)
	##
	## Inputs:
	##     Dmill - 2-vector - min and max diameters of the mill
	##     Dpre  - diameter of predrilled hole
	##     
	f = fcreate(L, angle);
	m = fmill(Dmill(1), Dmill(2), angle);
	[Z dx] = fproc(f, m, Zmin);
	dx = Dpre/2 - dx;
	res = sprintf("\n\
G0 Z...\n\
G1 G91 Z%g F...\n\
X%g\n\
G3 X0 Y0 I%g J0\n\
G1 X%g\n\
G0 G90 Z...\n",
Z, dx, -dx, -dx);
endfunction


function [Z, d] = fproc(f, m, Zmin=NA)
	## Расчёт смещения по Z фасочной фрезы от верхней плоскости,
	##   а также смещения d центра фрезы от стенки
	##
	## Usage:
	##   [Z, d] = facetProc(f,m[,Zmin])
	##
	## Returns:
	##   Z - plane offset by Z axis
	##   d - wall offset
	##
	## Inputs:
	##   f - фаска, созданная createFacet()
	##   m - фреза, созданная createMill()
	##   Zmin - минимальное предельное смещение по Z,
	##     ниже которого опускаться нельзя
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


function f = fcreate(L, angle)
	## Создание структуры, описывающей фрезу
	##
	## Inputs:
	##   L - длина фаски (в проекции на ось Z)
	##   angle - угол между фаской и осью Z (град.)
	f.L = L;
	f.ang = angle;
	# Длина фаски (проекция на перпендикуляр к оси Z):
	f.B = L*tand(angle);
end


function m = fmill(D0, D1, angle)
	## Создание структуры, описывающей фрезу
	##
	## Inputs:
	##   D0 - диаметр внутренний
	##   D1 - наружный диаметр
	##   angle - угол между кромкой и осью Z (град.)
	D = abs([D0, D1]);
	m.D = [min(D),  max(D)];
	m.ang = angle;
	m.B = abs(D1 - D0)/2;
	m.L = m.B / tand(angle);
end
