/*
import excel "/Users/mac/Downloads/covariateszx.xlsx",  sheet("Sheet1") firstrow clear
	destring gdp_*,replace
	reshape long age_ sex_ gdp_ ,i(dspcode) j(year)
save "/Volumes/alan/method paper/Data Analysis/covariancexz.dta",replace
	
import excel "/Volumes/alan/method paper/Data Analysis/135个县区统计描述/county name.xlsx", sheet("Sheet1") firstrow clear
save "/Volumes/alan/method paper/Data Analysis/county name.dta",replace
*/

别动了

***************************************************************	 
********************* 生成	原始数据随机抽样 ****************
***************************************************************	 
/*net install cleanplots, from("https://tdmize.github.io/data/cleanplots")
set scheme cleanplots, perm
*/
local weight1name 2018weight1 2015weight1 2013weight1 2007weight1
**#
use "${RAW}/2010oweight2.dta",clear
foreach m of local weight1name{
	append using "${RAW}//`m'"
	*merge 1:1 dspcode using "/Volumes/alan/method paper/Data Analysis/county_pch/\`m'"
	*drop _merge
}
destring dspcode, replace
merge m:1 dspcode using "${RAW}/da_code"
drop _merge
gen time0 = 2011 if batch == 1
replace time0 = 2012 if batch == 2
replace time0 = 2014 if batch == 3
replace time0 = 2017 if batch == 4
replace time0 = year if time0 == .

label variable BMI "BMI(kg/m²)" 
label variable  waist "Waist(cm)"   
label variable  obesity "Prevelance of Obesity" 
label variable  overweight "Prevelance of Overweight" 

gen time_window = year - time0 if batch != .

gen treated = 0
replace treated = 1 if time_window > 0 & time_window != .
gen treated_g = 0
replace treated_g = 1 if batch != .

merge 1:1 dspcode year using "${RAW}/covariate.dta"
drop  gdp_pc _m

merge 1:1 dspcode year using "${RAW}/GDP.dta"
drop _m
ren gdp_percapita gdp_pc 
replace BMI = bmi if BMI ==.
save "${OUT}/final with 18.dta",replace


***************************************************************	 
********************* 生成	随机抽样 ****************
***************************************************************	 
use "${OUT}/final with 18.dta",clear
 preserve
		keep if year == 2013 & treated == 1 
		keep dspcode
		duplicates drop
		tempfile t1
		save `t1',replace
	restore
	merge m:1 dspcode using `t1'
	recode _m (1 =0) (3 =1)
	ren _m treated2011

	preserve
		keep if year == 2015 & treated == 1 
		keep dspcode
		duplicates drop
		merge m:1 dspcode using `t1'
		keep if _m ==1
		drop _m
		tempfile t2
		save `t2',replace	
	restore
	merge m:1 dspcode using `t2'
	recode _m (1 =0) (3 =1)
	ren _m treated2014

	preserve
		keep if year == 2018 & treated == 1 
		keep dspcode
		duplicates drop
		merge m:1 dspcode using `t1'
		keep if _m ==1
		drop _m
		merge m:1 dspcode using `t2'
		keep if _m ==1
		drop _m	
		tempfile t3
		save `t3',replace	
	restore
	merge m:1 dspcode using `t3'
	recode _m (1 =0) (3 =1)
	ren _m treated2017

	replace treated2014  = . if treated2014 == 0 &  treated_g == 1 
	replace treated2017  = . if treated2017 == 0 &  treated_g == 1 

	* 保留50%的未处理样本
	preserve 
		keep if treated_g == 0 
		keep dspcode 
		duplicates drop
		sample 50 
		tempfile untreated
		save `untreated' ,replace
	restore
	
			
			
	preserve 
		merge m:1 dspcode using  `untreated'
		keep if _m == 3  //| dsp == 230103  | dsp ==330483  | dsp ==469021
		drop _m 
	save  "${OUT}/final with 18 random select untreated_50.dta",replace 	
	restore 

	preserve 
		use "${OUT}/final with 18 random select untreated_50.dta",clear
		keep dspcode
		duplicates drop
		save  "${OUT}/final with 18 random select untreated_50_list.dta",replace 	
	restore 	
	
	merge m:1 dspcode  using   "${OUT}/final with 18 random select untreated_50_list.dta"
	keep if _m == 3 | inlist(dsp,230103,310117,330103 ,   220102 ,330483 ,350402,530402 , 620423, 460108, 110101,341823,410306,469021  )  
	
//  130705     420202 469021  
	drop _m
	
	drop treated201*
			
	gen treated2011 =  batch == 1
	gen treated2012 =  batch == 2
	gen treated2014 =  batch == 3
	 
	drop if batch>3 & batch !=.
	merge m:1 dsp using "${RAW}/county name.dta"
	keep if _m ==3
	drop _m
	
	
save  "${OUT}/final with 18 random select_fin2.dta",replace 	

use "${OUT}/final with 18.dta",clear
	merge m:1 dspcode  using   "${OUT}/final with 18 random select untreated_50_list.dta"
	keep if _m == 3 | inlist(dsp,230103,310117,330103 ,   220102 ,330483 ,350402,530402 , 620423, 460108, 110101,341823,410306,469021  )  
	gen log_gdp=log(gdp_pc)
	drop _m County	
	label variable sex "Sex Ratio" 
	label variable  prop_60 "Propotion of 60+"   
	label variable  log_gdp "log GDP per capital" 
	label variable  gdp_pc "GDP per capital" 
	label variable drinking12 "Prevalence of Drinking in past 12 months" 		
	label variable drinking30 "Prevalence of Drinking in past 30 days" 		
				
	gen treated2011 =  batch == 1
	gen treated2012 =  batch == 2
	gen treated2014 =  batch == 3
	 
	drop if batch>3 & batch !=.
	merge m:1 dsp using "${RAW}/county name.dta"
	keep if _m ==3
	drop _m
	
	
save  "${OUT}/final with 18 random select_fin2.dta",replace 	
