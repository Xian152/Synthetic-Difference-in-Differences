
***************************************************************	 
********************* R-Sdid数据准备--亚组 ****************
***************************************************************	
****************** 2011 ******************************	
use "${OUT}/final with 18 random select_fin2.dta",clear
	keep dspcode year drinking30 treated sex prop_65 log_gdp
	order dspcode year drinking30 treated sex prop_65 log_gdp
	ren dspcode id	
save "${OUT}/final with 18 random select untreated_clear_2.dta",replace

use "${OUT}/final with 18 random select_fin2.dta",clear
	keep if treated_g == 0 | treated2011==1 
	keep County dspcode year drinking30 treated sex prop_65 log_gdp
	order County dspcode year drinking30 treated sex prop_65 log_gdp
	ren County id	
save	"${OUT}/final with 18 random select untreated_clear11_2.dta",replace
	drop dspcode
save	"${OUT}/final with 18 random select untreated_clear11simulation_2.dta",replace


****************** 2012 ******************************	
use "${OUT}/final with 18 random select_fin2.dta",clear
	keep if treated_g == 0 | treated2012==1 
	keep dspcode year sex prop_65 log_gdp
	sort year  dspcode 
	order year dspcode
	ren (sex prop_65 log_gdp) (c_1 c_2 c_3)
	reshape long c_ ,i(year dspcode) j(id)
	sort id year dspcode
	keep c_
save	"${INT}/final with 18 random select untreated_covariates12_2.dta",replace

use "${OUT}/final with 18 random select_fin2.dta",clear
	keep if treated_g == 0 | treated2012==1  
	keep County dspcode year drinking30 treated sex prop_65 log_gdp
	order County dspcode year drinking30 treated sex prop_65 log_gdp
	ren County id
	tab id , gen(dsp)
	tab year,gen(time)
	drop dsp1 time1
save	"${OUT}/final with 18 random select untreated_clear12_2.dta",replace
	drop if inlist(year,2013,2015,2017)
save	"${OUT}/final with 18 random select untreated_clear12simulation_2.dta",replace


****************** 2014 ******************************	
use "${OUT}/final with 18 random select_fin2.dta",clear
	keep if treated_g == 0 | treated2014==1 
	keep County dspcode year drinking30 treated sex prop_65 log_gdp
	order County dspcode year drinking30 treated sex prop_65 log_gdp
	ren County id		
	tab id , gen(dsp)
	tab year,gen(time)
	drop dsp1 time1
save	"${OUT}/final with 18 random select untreated_clear14_2.dta",replace
	drop if inlist(year,2015,2017)
save	"${OUT}/final with 18 random select untreated_clear14simulation_2.dta",replace



use "${OUT}/final with 18 random select_fin2.dta",clear
	keep if treated_g == 0 | treated2014==1 
	keep dspcode year sex prop_65 log_gdp
	sort year  dspcode 
	order year dspcode
	ren (sex prop_65 log_gdp) (c_1 c_2 c_3)
	reshape long c_ ,i(year dspcode) j(id)
	sort id year dspcode
	keep c_
save	"${INT}/final with 18 random select untreated_covariates14_2.dta",replace


*******R作图用
use "${OUT}/final with 18 random select_fin2.dta",clear
	keep if treated_g == 0 | treated2011==1 
	keep County year drinking30 
	reshape wide drinking30 ,i(County) j(year)
	ren (drinking302007 drinking302010 drinking302013 drinking302015 drinking302018) (Y2007 Y2010 Y2013 Y2015 Y2018)
save	"${OUT}/final with 18_11_Y.dta",replace

