function circ()
	srcf = "circ.m";
	source(srcf);
	i = 0;
	names{++i} = "cradByPnts(P)";
	names{++i} = "cradius3p(P1, P2, P3)";
	printf("Functions in file %s:\n", srcf);
	for k = 1 : i
		printf("\t%s\n", names{k});
	end
end


function R = cradByPnts(P)
	## Вычисление радиуса окружности по массиву точек
	##
	## Usage:
	##   R = cradByPnts(P)
	##
	## Result:
	##   R - радиус окружности - 2-вектор из минимального и
	##       максимального вычисленного значений
	##
	## Inputs:
	##   P - матрица n*2 из координат (x,y) для n точек (n>=3).
	##

	if ((n=size(P,1)) < 3 || size(P,2) != 2)
		error("Incorrect arguments");
	endif

	# Normal lines
	for i = 1 : n-1
		x1 = P(i,1);
		x2 = P(i+1,1);
		y1 = P(i,2);
		y2 = P(i+1,2);
		k = (y2 - y1)/(x2 - x1);
		lines(i).k = -1/k;
		lines(i).pnt(1) = (x1 + x2)/2;
		lines(i).pnt(2) = (y1 + y2)/2;
	endfor

	# Radius
	for i = 1 : length(lines)-1
		for j = i+1 : length(lines)
			C = clineint(lines(i), lines(j));
			r(j-i) = norm(P(i,:) - C);
		endfor
		Rmin(i) = min(r);
		Rmax(i) = max(r);
		r = [];
	endfor

	R = [min(Rmin) max(Rmax)];
endfunction


function R = cradius3p(P1, P2, P3)
	## Radius calculation by 3 points
	##
	## Usage:
	##     cradius3p(P1, P2, P3)
	##
	## Inputs:
	##     P1, P2, P3 - 2-vectors of point coordinates.
	x1 = P1(1);
	x2 = P2(1);
	x3 = P3(1);
	y1 = P1(2);
	y2 = P2(2);
	y3 = P3(2);
	k1 = (y2 - y1)/(x2 - x1);
	k2 = (y3 - y2)/(x3 - x2);
	# Normal lines
	line1.k = -1/k1;
	line1.pnt(1) = (x1 + x2)/2;
	line1.pnt(2) = (y1 + y2)/2;
	line2.k = -1/k2;
	line2.pnt(1) = (x2 + x3)/2;
	line2.pnt(2) = (y2 + y3)/2;
	C = clineint(line1, line2);
	R = norm(P1 - C);
endfunction


function C = clineint(L1, L2)
	## Intersection point of two lines.
	##
	## Usage:
	##     clineint(L1, L2)
	##
	## Inputs:
	##     L1, L2 - line representive as structure. Fields: L.k - slope
	##              coefficient, L.pnt - 2-vector of point coordinates.
	k1 = L1.k;
	k2 = L2.k;
	x1 = L1.pnt(1);
	x2 = L2.pnt(1);
	y1 = L1.pnt(2);
	y2 = L2.pnt(2);
	x = (y2 - y1 + k1*x1 - k2*x2) / (k1 - k2);
    y = y1 + k1*(x - x1);
	C = [x y];
endfunction

