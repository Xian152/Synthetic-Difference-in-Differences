
cls

gen treat =""


foreach k in 230103 230826 310117 330103 360102 370323 510105  { //230103 230826 310117 330103 360102 370323 510105 select:230103 510105 310117 330103
preserve
	replace treat = "*********************"+"`k'"
	tab treat
	//drop if dspcode == 230826  //2011
	//drop if dspcode == 420102  //2012
	//drop if dspcode == 341823  //2014
	//drop if dspcode == 330283   //2017
	keep if dsp == `k' | treated_g == 0
	drop if treated2014 == 1 
	drop if treated2012 == 1 
	//keep if inlist(dspcode,230103,510105,310117,330103) | treated_g == 0
		sdid drinking30  dspcode year treated , vce(placebo) seed(1213) covariates(sex prop_65 log_gdp   , projected) 
restore
}


******************** round 2
cls 
foreach k in 220102 320582 330483 350402 370785 420102 433123 450205 460108 530402 610326 620423 { //220102 330483 350402 433123 450205 460108 530402       620423 select: 330483 220102 620423 530402
preserve
	replace treat = "*********************"+"`k'"
	tab treat
	//drop if dspcode == 230826  //2011
	//drop if dspcode == 420102  //2012
	//drop if dspcode == 341823  //2014
	//drop if dspcode == 330283   //2017
	keep if dsp == `k' | treated_g == 0
	drop if treated2014 == 1 
	drop if treated2011 == 1 	
	sdid drinking30  dspcode year treated , vce(placebo) seed(1213) covariates(sex prop_65 log_gdp   , projected) 
restore
}


******************** round 3 
cls
foreach k in  110101 130705 341823 410306 420202 469021 500101{ //select: 110101   341823 410306 420202 469021
preserve
	replace treat = "*********************"+"`k'"
	tab treat
	//drop if dspcode == 230826  //2011
	//drop if dspcode == 420102  //2012
	//drop if dspcode == 341823  //2014
	//drop if dspcode == 330283   //2017
	keep if dsp == `k' | treated_g == 0
		sdid drinking30  dspcode year treated , vce(placebo) seed(1213) covariates(sex prop_65 log_gdp   , projected) 
	
	restore
}
