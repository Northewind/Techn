function org()
	srcf = "org.m";
	source(srcf);
	i = 0;
	names{++i} = "org_min(Tprep, Tpc, alp=0.25)";
	printf("Functions in file %s:\n", srcf);
	for k = 1 : i
		printf("\t%s\n", names{k});
	end
end


function res = org_min(Tprep, Tpc, alp=0.25)
	%% Minimal volume of consignment to product
	%%
	%% Usage:
	%%     org_min(Tprep, Tpc, alp)
	%%
	%% Inputs:
	%%     Tprep    preparation time
	%%     Tpc      time for production one piece
	%%     alp      production koefficient
	%%              (0.05 - large consignment,
	%%               0.12 - middle consignment,
	%%               0.25 - small consignment,
	%%               0.45 - one piece production)
	res = ceil(Tprep*(1 - alp)/Tpc/alp);
end

