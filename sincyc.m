function sincyc()
	srcf = "sincyc.m";
	source(srcf);
	i = 0;
	names{++i} = "cyc83()";
	names{++i} = "cyc840()";
	printf("Functions in file %s:\n", srcf);
	for k = 1 : i
		printf("\t%s\n", names{k});
	end
end


function cyc83()
	## Sinumerik CYCLE83 cycle - interactive CNC-block generation
	##   for deep drilling
	##
	## Usage:
	##   cyc83()
	##
	rtp = input("Safety level: ");
	rfp = input("Hole start level: ");
	sdis = input("Safety dis from start level (w/o sign): ");
	endhol = menu("End of hole level:",
			"absolute",
			"relational");
	switch (endhol)
		case 1
			dp = input("End of hole level (abs): ");
			dpr = 0;
		case 2
			dp = 0;
			dpr = input("End of hole level (rel, w/o sign): ");
	endswitch
	firdep = menu("First drilling depth:",
			"absolute",
			"relational");
	switch (firdep)
		case 1
			fdep = input("First drilling depth (abs): ");
			fdpr = 0;
		case 2
			fdep = 0;
			fdpr = input("First drilling depth (rel, w/o sign): ");
	endswitch
	dam = input("Decrement (mm, w/o sign): ");	
	dtb = input("Time to wait at the end point (sec): ");
	dts = input("Time to wait at the start point (sec): ");
	frf = input("Coefficient feed for first drill iteration (0.001...1): ");
	vari = uint32(menu("Drilling mode:",
			"chip break",
			"chip evacuation"));
	printf("CYCLE83(%g,%g,%g,%g,%g,%g, %g,%g,%g,%g,%g,%d)\n",
		rtp, rfp, sdis, dp, dpr, fdep,
		fdpr, dam, dtb, dts, frf, vari);
end


function cyc840()
	## Sinumerik CYCLE840 cycle - interactive CNC-block generation
	##   for tapping
	##
	## Usage:
	##   cyc840()
	##
	rtp = input("Safety level: ");
	rfp = input("Hole start level: ");
	sdis = input("Safety dis from start level (w/o sign): ");
	endhol = menu("End of hole level:",
			"absolute",
			"relational");
	switch (endhol)
		case 1
			dp = input("End of hole level (abs): ");
			dpr = 0;
		case 2
			dp = 0;
			dpr = input("End of hole level (rel, w/o sign): ");
	endswitch
	dtb = input("Time to wait at the end point (sec): ");
	sdr = uint32(4);
	sdac = uint32(3);
	enc = uint32(1);
	mpit = input("Thread diameter: ");
	pit = input(["Thread pitch (", num2str(max(mpitch(mpit))), "): "]);
	printf("CYCLE840(%g,%g,%g,%g,%g,%g,%d,%d,%d,%g,%g)\n",
		rtp, rfp, sdis, dp, dpr, dtb,
		sdr, sdac, enc, mpit, pit);
end

