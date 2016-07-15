function thread()
	srcf = "thread.m";
	source(srcf);
	i = 0;
	names{++i} = "mpitch(d)";
	names{++i} = "grv_wdth(D, D2, p, ang)";
	printf("Functions in file %s:\n", srcf);
	for k = 1 : i
		printf("\t%s\n", names{k});
	end
endfunction


function [p] = mpitch(d)
## Get pitchs for metric thread
##
## Usage:
##   mpitch(d)
##
## Parameters:
##   d    thread diameter
##
	pitchs = struct(
		"0.25", [0.075],
		"0.3",  [0.08],
		"0.35", [0.09],
		"0.4",  [0.1],
		"0.45", [0.1],
		"0.5",  [0.125],
		"0.55", [0.125],
		"0.6",  [0.15],
		"0.7",  [0.175],
		"0.8",  [0.2],
		"0.9",  [0.225],
		"1",    [0.25],
		"1.1",  [0.25],
		"1.2",  [0.25],
		"1.4",  [0.3],
		"1.6",  [0.35],
		"1.8",  [0.35],
		"2",    [0.4],
		"2.2",  [0.45],
		"2.5",  [0.45],
		"3",    [0.5],
		"3.5",  [0.6],
		"4",    [0.7],
		"4.5",  [0.75],
		"5",    [0.8],
		"6",    [1],
		"7",    [1],
		"8",    [1.25],
		"9",    [1.25],
		"10",   [1.5],
		"11",   [1.5],
		"12",   [1.75],
		"14",   [2],
		"16",   [2],
		"18",   [2.5],
		"20",   [2.5],
		"22",   [2.5],
		"24",   [3],
		"27",   [3],
		"30",   [3.5],
		"33",   [3.5],
		"36",   [4],
		"39",   [4],
		"42",   [4.5],
		"45",   [4.5],
		"48",   [5],
		"52",   [5],
		"56",   [5.5],
		"60",   [5.5],
		"64",   [6],
		"68",   [6]);

	p = [];
	if (isfield(pitchs, num2str(d)))
		p = getfield(pitchs, num2str(d));
	endif
endfunction


function w = grv_wdth(D, D2, p, ang)
## Calculate groove width
##
## Usage:
##     w = grv_wdth(D, D2, p, ang)
##
	w = p/2 - (D-D2)*tand(ang/2);
endfunction

