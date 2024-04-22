import delimited "/Users/x152/Desktop/error.densities_12.csv", varnames(1) clear
	keep x y simulator estimator
	
	keep if inlist(simulator,"no.M","random")
	
	preserve
		keep if simulator == "no.M"
		twoway line  y x if estimator == "did" ,color("green")|| line  y x if estimator == "sc" ,color("blue") ///
		|| line  y x if estimator == "sdid" , color("red") xtitle(Errors) ytitle(Density) title(Nonuniformly Random Assignment) xlabel(-2(0.5)2) ylabel(0(0.5)2) xline(0) legend(off) 
		graph save "${OUT}/simulation_nonrandom.gph",replace
	restore
	
	preserve 
		keep if simulator == "random"
		twoway line  y x if estimator == "did",color("green") || line  y x if estimator == "sc" ,color("blue") ///
		|| line  y x if estimator == "sdid" ,color("red")  xtitle(Errors) ytitle(Density) xlabel(-2(0.5)2)  ylabel(0(0.5)2) title(Random Assignment) xline(0) legend(order(1 "DID" 2 "SC" 3 "SDID" ) ring(0) pos(2)) 
		graph save "${OUT}/simulation_random.gph",replace
	restore

	graph combine  "${OUT}/simulation_nonrandom.gph" "${OUT}/simulation_random.gph", 
	graph export "${OUT}/simulation.png",replace  
	
	
import delimited "/Users/x152/Desktop/estimtes_11.csv", varnames(1) clear
	keep simulation estimator estimate
	keep if inlist(simulation,"no.M","random")
	keep if inlist(estimator,"did","sc","sdid")
	bysort simulation estimator: sum estimate
	gen rmse = estimate * estimate
	bysort simulation estimator: sum rmse
	