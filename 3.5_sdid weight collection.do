cls
use "${OUT}/final with 18 random select untreated_clear11_2.dta",clear
	sdid drinking30  dspcode year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp  , projected) method(sc)   
	foreach m in  omega lambda  {
		matrix list e(`m')
		mat `m' = e(`m')
	}	

	sdid drinking30  dspcode year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp  , projected) method(sdid) 	
	foreach m in  omega lambda   {
		matrix list e(`m')
		mat `m' = e(`m')
	}	

use "${OUT}/final with 18 random select untreated_clear12_2.dta",clear
	sdid drinking30  dspcode year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp  , projected) method(sc) 	
	foreach m in  omega  lambda   {
		matrix list e(`m')
		mat `m' = e(`m')
	}

	sdid drinking30  dspcode year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp  , projected) method(sdid) 	

	foreach m in  omega  lambda  {
		matrix list e(`m')
		mat `m' = e(`m')
	}	
	
	
use "${OUT}/final with 18 random select untreated_clear14_2.dta",clear
	sdid drinking30  dspcode year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp  , projected) method(sc) 
	foreach m in  omega  lambda   {
		matrix list e(`m')
		mat `m' = e(`m')
	}	

	sdid drinking30  dspcode year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp  , projected) method(sdid) 
	
	foreach m in  omega  lambda {
		matrix list e(`m')
		mat `m' = e(`m')
	}	

	