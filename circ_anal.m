function circ_anal()
	srcf = "circ_anal.m";
	source(srcf);
	i = 0;
	names{++i} = "radByPnt(P)";
	printf("Functions in file %s:\n", srcf);
	for k = 1 : i
		printf("\t%s\n", names{k});
	end
end


function R = radByPnt(P)
	## Вычисление радиуса окружности по массиву точек
	##
	## Использование:
	##
	##   R = circByPnt(P)
	##
	## Результат:
	##
	##   R - радиус окружности - 2-вектор из минимального и
	##       максимального вычисленного значений
	##
	## Входные параметры:
	## 
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
		lines(i).mid(1) = (x1 + x2)/2;
		lines(i).mid(2) = (y1 + y2)/2;
	endfor

	# Radius
	for i = 1 : length(lines)-1
		for j = i+1 : length(lines)
			C = center(lines(i), lines(j));
			r(j-i) = norm(P(i,:) - C);
		endfor
		Rmin(i) = min(r);
		Rmax(i) = max(r);
		r = [];
	endfor

	R = [min(Rmin) max(Rmax)];
endfunction


function C = center(L1, L2)
	## Вычисление точки пересечения двух прямых,
	##   заданных точкой и коэффициентом наклона
	k1 = L1.k;
	k2 = L2.k;
	x1 = L1.mid(1);
	x2 = L2.mid(1);
	y1 = L1.mid(2);
	y2 = L2.mid(2);
	x = (y2 - y1 + k1*x1 - k2*x2) / (k1 - k2);
    y = y1 + k1*(x - x1);
	C = [x y];
endfunction

