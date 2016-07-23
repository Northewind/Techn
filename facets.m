function facets()
	srcf = "facets.m";
	source(srcf);
	i = 0;
	names{++i} = "fcirc(dmill, dpre, l, ang, zmax=NA)";
	printf("Functions in file %s:\n", srcf);
	for k = 1 : i
		printf("\t%s\n", names{k});
	end
end


function res = fcirc(dmill, dpre, l, ang, zmax=NA)
	%% CNC code for facet processing in the circular hole.
	%%
	%% Usage:
	%%     fcnc(dmill, dpre, l, ang, zmax=NA)
	%%
	%% Inputs:
	%%     dmill   2-vector - min and max diameters of the mill
	%%     dpre    diameter of predrilled hole
	%%     l       facet length (in Z axis)
	%%     ang     angle of facet
	%%     zmax    maximum offcet in Z
	f = fcreate(l, ang);
	m = fmill(dmill(1), dmill(2), ang);
	[z dx] = fproc(f, m, zmax);
	dx = dpre/2 - dx;
	res = sprintf("\n\
G0 Z...\n\
G1 G91 Z%g F...\n\
X%g\n\
G3 X0 Y0 I%g J0\n\
G1 X%g\n\
G0 G90 Z...\n",
z, dx, -dx, -dx);
end


function [z, d] = fproc(f, m, zmax=NA)
	%% Расчёт смещения по Z фасочной фрезы от верхней плоскости,
	%%   а также смещения d центра фрезы от стенки
	%%
	%% Usage:
	%%     [z, d] = facetProc(f, m, zmax=NA)
	%%
	%% Returns:
	%%     z      plane offset by Z axis
	%%     d      wall offset
	%%
	%% Inputs:
	%%     f      фаска, созданная createFacet()
	%%     m      фреза, созданная createMill()
	%%     zmax   минимальное предельное смещение по Z,
	%%            ниже которого опускаться нельзя
	if ((f.l > m.l) || (f.ang ~= m.ang))
		error("facetProc: mill is not applicable");
	end
	z = - f.l/2 - m.l/2;
	d = -f.b/2 + mean(m.d)/2;
	% Проверка по zmax
	if (~isna(zmax) && (z < zmax))
		dz = zmax - z;
		d -= tand(f.ang)*dz;
		if (d < 0)
			error("facetProc: wrong geometry")
		end
		z += dz;
	end
end


function f = fcreate(l, ang)
	%% Создание структуры, описывающей фрезу
	%%
	%% Inputs:
	%%     l       длина фаски (в проекции на ось Z)
	%%     ang     угол между фаской и осью Z (град.)
	f.l = l;
	f.ang = ang;
	% Длина фаски (проекция на перпендикуляр к оси Z):
	f.b = l*tand(ang);
end


function m = fmill(d0, d1, ang)
	%% Создание структуры, описывающей фрезу
	%%
	%% Inputs:
	%%     d0     диаметр внутренний
	%%     d1     наружный диаметр
	%%     ang    угол между кромкой и осью Z (град.)
	d = abs([d0, d1]);
	m.d = [min(d),  max(d)];
	m.ang = ang;
	m.b = abs(d1 - d0)/2;
	m.l = m.b / tand(ang);
end

