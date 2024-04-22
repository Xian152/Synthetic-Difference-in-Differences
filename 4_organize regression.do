cls
use "${OUT}/final with 18 random select untreated_clear11_2.dta",clear
	sdid drinking30  id year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp  , projected) method(did) 
	outreg2 using "${OUT}/Table_main.xls",replace excel stats(coef pval) dec(3) alpha(0.01,0.05,0.1) symbol(***,**,*)   	

use "${OUT}/final with 18 random select untreated_clear12_2.dta",clear
	sdid drinking30  id year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp  , projected) method(did) 	
	outreg2 using "${OUT}/Table_main.xls",append excel stats(coef pval) dec(3) alpha(0.01,0.05,0.1) symbol(***,**,*)   
use "${OUT}/final with 18 random select untreated_clear14_2.dta",clear
	sdid drinking30  id year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp  , projected) method(did) 
	outreg2 using "${OUT}/Table_main.xls",append excel stats(coef pval) dec(3) alpha(0.01,0.05,0.1) symbol(***,**,*)
	
use "${OUT}/final with 18 random select_fin2.dta",clear
ren dsp id
	sdid drinking30  id year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp  , projected) method(did) 	
	outreg2 using "${OUT}/Table_main.xls",append excel stats(coef pval) dec(3) alpha(0.01,0.05,0.1) symbol(***,**,*)   
  
	
use "${OUT}/final with 18 random select untreated_clear11_2.dta",clear
	sdid drinking30  id year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp  , projected) method(sc) 
	outreg2 using "${OUT}/Table_main.xls",append excel stats(coef pval) dec(3) alpha(0.01,0.05,0.1) symbol(***,**,*)   
use "${OUT}/final with 18 random select untreated_clear12_2.dta",clear
	sdid drinking30  id year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp  , projected) method(sc) 
	outreg2 using "${OUT}/Table_main.xls",append excel stats(coef pval) dec(3) alpha(0.01,0.05,0.1) symbol(***,**,*)   
use "${OUT}/final with 18 random select untreated_clear14_2.dta",clear
	sdid drinking30  id year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp  , projected) method(sc) 	
	outreg2 using "${OUT}/Table_main.xls",append excel stats(coef pval) dec(3) alpha(0.01,0.05,0.1) symbol(***,**,*)   

use "${OUT}/final with 18 random select_fin2.dta",clear
ren dsp id
	sdid drinking30  id year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp  , projected) method(sc) 	
	outreg2 using "${OUT}/Table_main.xls",append excel stats(coef pval) dec(3) alpha(0.01,0.05,0.1) symbol(***,**,*)   

	
	
cls	
use "${OUT}/final with 18 random select untreated_clear11_2.dta",clear
	sdid drinking30  id year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp  , projected) method(sdid) 	
	outreg2 using "${OUT}/Table_main.xls",append excel stats(coef pval) dec(3) alpha(0.01,0.05,0.1) symbol(***,**,*)   
use "${OUT}/final with 18 random select untreated_clear12_2.dta",clear
	sdid drinking30  id year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp  , projected) method(sdid) 
	outreg2 using "${OUT}/Table_main.xls",append excel stats(coef pval) dec(3) alpha(0.01,0.05,0.1) symbol(***,**,*)   
use "${OUT}/final with 18 random select untreated_clear14_2.dta",clear
	sdid drinking30  id year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp  , projected) method(sdid)
	outreg2 using "${OUT}/Table_main.xls",append excel stats(coef pval) dec(3) alpha(0.01,0.05,0.1) symbol(***,**,*)

use "${OUT}/final with 18 random select_fin2.dta",clear
ren dsp id
	sdid drinking30  id year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp  , projected) method(sdid) 	
	outreg2 using "${OUT}/Table_main.xls",append excel stats(coef pval) dec(3) alpha(0.01,0.05,0.1) symbol(***,**,*)   

