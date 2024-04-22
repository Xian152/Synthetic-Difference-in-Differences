
cls

gen treat =""


foreach k in 230103  310117 330103 510105  { //230103 230826 310117 330103 360102 370323 510105
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
		sdid drinking30  dspcode year treated , vce(placebo) seed(1213) covariates(sex prop_65 log_gdp   , projected)  ///
		g2_opt(ytitle("Prevelence of Drinking") xtitle("year")  xlabel(2005(2)2020) title("The First Batch--Total") ) 	

		sdid drinking12  dspcode year treated , vce(placebo) seed(1213) covariates(sex prop_65 log_gdp   , projected)  ///
		g2_opt(ytitle("Prevelence of Drinking") xtitle("year")  xlabel(2005(2)2020) title("The First Batch--Total")) 
restore
}


******************** round 2 
foreach k in 220102 320582 330483 350402 370785 420102 433123 450205 460108 530402 610326 620423 { //220102 330483 350402 433123 450205 460108 530402       620423
preserve
	replace treat = "*********************"+"`k'"
	tab treat
	//drop if dspcode == 230826  //2011
	//drop if dspcode == 420102  //2012
	//drop if dspcode == 341823  //2014
	//drop if dspcode == 330283   //2017
	keep if dsp == `k' | treated_g == 0
		sdid drinking30  dspcode year treated , vce(placebo) seed(1213) covariates(sex prop_65 log_gdp   , projected)  ///
		g2_opt(ytitle("Prevelence of Drinking") xtitle("year")  xlabel(2005(2)2020) title("The First Batch--Total") ) 	

		sdid drinking12  dspcode year treated , vce(placebo) seed(1213) covariates(sex prop_65 log_gdp   , projected)  ///
		g2_opt(ytitle("Prevelence of Drinking") xtitle("year")  xlabel(2005(2)2020) title("The First Batch--Total")) 
restore
}


******************** round 3 
foreach k in  110101 130705 341823 410306 420202 469021 500101{ //469021
preserve
	replace treat = "*********************"+"`k'"
	tab treat
	//drop if dspcode == 230826  //2011
	//drop if dspcode == 420102  //2012
	//drop if dspcode == 341823  //2014
	//drop if dspcode == 330283   //2017
	keep if dsp == `k' | treated_g == 0
		sdid drinking30  dspcode year treated , vce(placebo) seed(1213) covariates(sex prop_65 log_gdp   , projected)  ///
		g2_opt(ytitle("Prevelence of Drinking") xtitle("year")  xlabel(2005(2)2020) title("The First Batch--Total") ) 	

		sdid drinking12  dspcode year treated , vce(placebo) seed(1213) covariates(sex prop_65 log_gdp   , projected)  ///
		g2_opt(ytitle("Prevelence of Drinking") xtitle("year")  xlabel(2005(2)2020) title("The First Batch--Total")) 
restore
}
