***************************************************************	 
********************* test 完整结果 ****************
***************************************************************	 
use "${OUT}/final with 18.dta",clear
	gen log_gdp=log(gdp_pc)
		
	label variable sex "Sex Ratio" 
	label variable  prop_60 "Propotion of 60+"   
	label variable  log_gdp "log GDP per capital" 
	label variable  gdp_pc "GDP per capital" 
	label variable drinking12 "Prevalence of Drinking in past 12 months" 		
	label variable drinking30 "Prevalence of Drinking in past 30 days" 		
			
			
	
	keep if treated_g == 0 | inlist(dsp,230103, 230826 ,310117, 330103 ,360102 ,370323 ,510105)
	keep dspcode year drinking30 treated sex prop_65 log_gdp
	order dspcode year drinking30 treated sex prop_65 log_gdp
	drop if inlist(year,2015,2018)
	ren dsp id
save	"${OUT}/final with 18_clear11.dta",replace

***************************************************************	 
********************* Simulation ****************
***************************************************************	
use "${OUT}/final with 18.dta",clear

	gen log_gdp=log(gdp_pc)
		
	label variable sex "Sex Ratio" 
	label variable  prop_60 "Propotion of 60+"   
	label variable  log_gdp "log GDP per capital" 
	label variable  gdp_pc "GDP per capital" 
	label variable drinking12 "Prevalence of Drinking in past 12 months" 		
	label variable drinking30 "Prevalence of Drinking in past 30 days" 		
			
	order dspcode year drinking30 treated sex prop_65 log_gdp
	keep dspcode year drinking30 treated sex prop_65 log_gdp

	ren dspcode id	
	drop if inlist(year,2015,2018)
save	"${OUT}/final with 18_simulation1112.dta",replace


use "${OUT}/final with 18.dta",clear

	gen log_gdp=log(gdp_pc)
		
	label variable sex "Sex Ratio" 
	label variable  prop_60 "Propotion of 60+"   
	label variable  log_gdp "log GDP per capital" 
	label variable  gdp_pc "GDP per capital" 
	label variable drinking12 "Prevalence of Drinking in past 12 months" 		
	label variable drinking30 "Prevalence of Drinking in past 30 days" 		
			
	order dspcode year drinking30 treated sex prop_65 log_gdp
	keep dspcode year drinking30 treated sex prop_65 log_gdp

	ren dspcode id	
	foreach k in 220102 230103 230826 310117 320582 330103 330483 350402 360102 370323 370785 420102 433123 450205 460108 510105 530402 610326 620423 {
	drop if id == `k'
}

	drop if inlist(year,2018)
save	"${OUT}/final with 18_simulation14.dta",replace











use "/Volumes/alan/method paper/Data Analysis/final with 18 random select untreated_clear14.dta",clear
merge m:1 dspcode using "/Volumes/alan/method paper/Data Analysis/weight_14.dta"

drop _m

foreach year in 2007 2010 2013 2015 2018{
preserve
	keep if year == `year'
	foreach k in drinking30 sex prop_65 log_gdp{
		gen `k'_weighted_sc = sc_w*`k'
		gen `k'_weighted_sdid = sdid_w*`k'
	}
	drop if inlist(dsp, 999912,469021,500101) 
	collapse *_weighted_sc *_weighted_sdid
	gen year = `year'
	expand 32
	tempfile t`year' 
	save `t`year'',replace
restore		
}	

	append using `t2007' `t2011' `t2013' `t2015' `t2018'
	keep if inlist(dsp, .,469021,500101) 
	replace dsp = 999914 if dsp == .

save "/Volumes/alan/method paper/Data Analysis/final with_weight_14.dta",replace
	
use "/Volumes/alan/method paper/Data Analysis/final with_weight_14.dta",clear
	append using "/Volumes/alan/method paper/Data Analysis/final with_weight_11.dta" "/Volumes/alan/method paper/Data Analysis/final with_weight_12.dta"
	foreach k in drinking30 sex prop_65 log_gdp {
		replace `k'_weighted_sc = `k' if `k' !=.
		replace `k'_weighted_sdid = `k' if `k' !=.
	}
	
	keep dspcode year treated did_w sc_w sdid_w drinking30_weighted_sc sex_weighted_sc prop_65_weighted_sc log_gdp_weighted_sc drinking30_weighted_sdid sex_weighted_sdid prop_65_weighted_sdid log_gdp_weighted_sdid	
	
	gen g = 2011 if inlist(dsp,230103,310117)
	replace g = 2012 if inlist(dsp,220102,330483)
	replace g = 2014 if inlist(dsp,469021,500101)
	replace g = 0 if !inlist(dsp,230103,310117,220102,330483,469021,500101) 
	
save "/Volumes/alan/method paper/Data Analysis/final with_weighted_control.dta",replace
	
