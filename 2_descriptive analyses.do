***************************************************************	 
********************* 描述性	抽样 1****************
***************************************************************	 
use "${OUT}/final with 18 random select_fin2.dta",clear

gen group1 = 1 if inrange(year, 2007,2010) & treated2011 ==1
replace group1 = 2 if inrange(year, 2007,2010) & treated2011 ==0
gen group2 = 1 if inrange(year, 2013,2018) & treated2011 ==1
replace group2 = 2 if inrange(year, 2013,2018) & treated2011 ==0

gen group3 = 1 if inrange(year, 2007,2010) & treated2012 ==1
replace group3 = 2 if inrange(year, 2007,2010) & treated2012 ==0
gen group4 = 1 if inrange(year, 2013,2018) & treated2012 ==1
replace group4 = 2 if inrange(year, 2013,2018) & treated2012 ==0

gen group5 = 1 if inrange(year, 2007,2013) & treated2014 ==1
replace group5 = 2 if inrange(year, 2007,2013) & treated2014 ==0
gen group6 = 1 if inrange(year, 2015,2018) & treated2014 ==1
replace group6 = 2 if inrange(year, 2015,2018) & treated2014 ==0
/*
gen group7 = 1 if inrange(year,2007,2015) & treated2017 ==1
replace group7 = 2 if inrange(year, 2007,2015) & treated2017 ==0
gen group8 = 1 if inlist(year,2018) & treated2017 ==1
replace group8 = 2 if inlist(year, 2018) & treated2017 ==0
*/
	table1 , by(group1) vars(drinking30 contn\  sex contn\ gdp_pc contn\ prop_65 contn\  ) format(%2.3f) one mis saving("${Result}/Select_DS1_treat_rawgroup1.xls", replace) 
	table1, by(group2) vars(drinking30 contn\   sex contn\  gdp_pc contn\ prop_65 contn\  ) format(%2.3f) one mis saving("${Result}/Select_DS1_treat_rawgroup2.xls", replace) 

	table1, by(group3) vars(drinking30 contn\   sex contn\ gdp_pc contn\  prop_65 contn\  ) format(%2.3f) one mis saving("${Result}/Select_DS1_treat_rawgroup3.xls", replace) 
	table1, by(group4) vars(drinking30 contn\   sex contn\ gdp_pc contn\  prop_65 contn\  ) format(%2.3f) one mis saving("${Result}/Select_DS1_treat_rawgroup4.xls", replace) 

	table1, by(group5) vars(drinking30 contn\  sex contn\ gdp_pc contn\  prop_65 contn\  ) format(%2.3f) one mis saving("${Result}/Select_DS1_treat_rawgroup5.xls", replace) 
	table1, by(group6) vars(drinking30 contn\   sex contn\ gdp_pc contn\  prop_65 contn\  ) format(%2.3f) one mis saving("${Result}/Select_DS1_treat_rawgroup6.xls", replace) 
	
***************************************************************	 
********************* 描述性	抽样 2 ****************
***************************************************************	 (%12.0g
use "${OUT}/final with 18 random select_fin2.dta",clear
replace prop_65 = prop_65*100

gen group1 = 1 if inrange(year, 2007,2010) & treated2011 ==1
replace group1 = 2 if inrange(year, 2007,2010) & treated2011 ==0
gen group2 = 1 if inrange(year, 2013,2018) & treated2011 ==1
replace group2 = 2 if inrange(year, 2013,2018) & treated2011 ==0

gen group3 = 1 if inrange(year, 2007,2010) & treated2012 ==1
replace group3 = 2 if inrange(year, 2007,2010) & treated2012 ==0
gen group4 = 1 if inrange(year, 2013,2018) & treated2012 ==1
replace group4 = 2 if inrange(year, 2013,2018) & treated2012 ==0

gen group5 = 1 if inrange(year, 2007,2013) & treated2014 ==1
replace group5 = 2 if inrange(year, 2007,2013) & treated2014 ==0
gen group6 = 1 if inrange(year, 2015,2018) & treated2014 ==1
replace group6 = 2 if inrange(year, 2015,2018) & treated2014 ==0

	table1 , by(group1) vars(drinking30 contn\  sex contn\ gdp_pc contn\ prop_65 contn\  ) format(%12.0g) one mis saving("${Result}/Select_DS1_treat_rawgroup1.xls", replace) 
	table1, by(group2) vars(drinking30 contn\   sex contn\  gdp_pc contn\ prop_65 contn\  ) format(%12.0g) one mis saving("${Result}/Select_DS1_treat_rawgroup2.xls", replace) 

	table1, by(group3) vars(drinking30 contn\   sex contn\ gdp_pc contn\  prop_65 contn\  ) format(%12.0g) one mis saving("${Result}/Select_DS1_treat_rawgroup3.xls", replace) 
	table1, by(group4) vars(drinking30 contn\   sex contn\ gdp_pc contn\  prop_65 contn\  ) format(%12.0g) one mis saving("${Result}/Select_DS1_treat_rawgroup4.xls", replace) 

	table1, by(group5) vars(drinking30 contn\  sex contn\ gdp_pc contn\  prop_65 contn\  ) format(%12.0g) one mis saving("${Result}/Select_DS1_treat_rawgroup5.xls", replace) 
	table1, by(group6) vars(drinking30 contn\   sex contn\ gdp_pc contn\  prop_65 contn\  ) format(%12.0g) one mis saving("${Result}/Select_DS1_treat_rawgroup6.xls", replace) 

***************************************************************	 
********************* 和控制变量之间的关系	 ****************
***************************************************************	 	
use "${OUT}/final with 18 random select_fin2.dta",clear
xtset dspcode year    
	xtreg drinking30 sex prop_65 log_gdp, r fe
	outreg2 using "${Result}/Select_correlation_drinking.doc",replace word stats(coef ci) dec(3) alpha(0.01,0.05,0.1,0.15) symbol(***,**,*,+)
	
***************************************************************	 
********************* 描述性作图	PTA ****************
***************************************************************	 	
*simple did
/*ssc install cnssc,replace
cnssc install lxhget, replace
ssc install schemepack, replace

lxhget tsg_schemes.pkg, des
set scheme neon, perm
net install cleanplots, from("https://tdmize.github.io/data/cleanplots")
*/
use "${OUT}/final with 18 random select_fin2.dta",clear

set scheme cleanplots, perm
	sort treated_g year
preserve	
	keep if treated == 0 |  treated2011== 1 
	egen av_dk = mean(drinking30), by (treated_g year)
	*gen av_dk1 = av_dk if treated_g == 1
	*gen av_dk2 = av_dk if treated_g == 0
	duplicates drop treated_g year, force
	keep av_dk treated_g year
	reshape wide av_dk, i(year) j(treated_g)
	ren (av_dk1 av_dk0) (Treated Controled )
	label variable Treated "NIDAs"
	label variable Controled  "Non-NIDAs"
	
	
	twoway connected Treated  Controled year, title("Panel A: The First Batch(2011)") ytitle("Past-month drinking rate" ) xtitle(Year) xline(2011) legend(ring(0) pos(2)) ylabel(20(4)35,nogrid) xlabel(2006(2)2018,nogrid) ylabel(,nogrid)
	
	graph save "Graph_drinking30_11.gph",   replace	
restore

preserve	
	keep if treated == 0 |   treated2012== 1 
	egen av_dk = mean(drinking30), by (treated_g year)
	*gen av_dk1 = av_dk if treated_g == 1
	*gen av_dk2 = av_dk if treated_g == 0
	duplicates drop treated_g year, force
	keep av_dk treated_g year
	reshape wide av_dk, i(year) j(treated_g)
	ren (av_dk1 av_dk0) (Treated Controled )
	label variable Treated "NIDAs"
	label variable Controled  "Non-NIDAs"
	
	
	twoway connected Treated  Controled year, title("Panel B: The Second Batch(2012)") ytitle("Past-month drinking rate" ) xtitle(Year)  xline(2012)   legend(ring(0) pos(2)) ylabel(20(4)35,nogrid)  xlabel(2006(2)2018,nogrid) ylabel(,nogrid)
	
	graph save "Graph_drinking30_12.gph",  replace	
restore
	
preserve	
	keep if treated == 0 |   treated2014== 1 
	egen av_dk = mean(drinking30), by (treated_g year)
	*gen av_dk1 = av_dk if treated_g == 1
	*gen av_dk2 = av_dk if treated_g == 0
	duplicates drop treated_g year, force
	keep av_dk treated_g year
	reshape wide av_dk, i(year) j(treated_g)
	ren (av_dk1 av_dk0) (Treated Controled )
	label variable Treated "NIDA Areas"
	label variable Controled  "Non-NIDA Areas"
	
	twoway connected Treated  Controled year, title("Panel C: The Third Batch(2014)") ytitle("Past-month drinking rate" ) xtitle(Year)  xline(2014) legend(ring(0) pos(2)) ylabel(20(4)35,nogrid) xlabel(2006(2)2018,nogrid) ylabel(,nogrid)
	
	graph save "Graph_drinking30_14.gph",   replace	
restore	

	//twoway connected reated  Controled year, title("Panel D: The Total ") ytitle("Past-month drinking rate" ) xtitle(Year)  legend(ring(0) pos(2))  xlabel(2006(2)2018,nogrid) ylabel(,nogrid)
	
	graph save "Graph_drinking30_14.gph",    replace	


	graph combine "Graph_drinking30_11.gph" "Graph_drinking30_12.gph" "Graph_drinking30_14.gph",title("Trend of past-month drinking rate") rows(3)  cols(1) iscale(.7273) ysize(12)  graphregion(margin(zero))
	*coefplot dynamic, vertical recast(connect) yline(0) xline() ciopts(recast( > rline) lpattern(dash))
	
***************************************************************	 
********************* SC 描述性作图	CHC ****************
***************************************************************	 
use "${OUT}/final with 18 random select_fin2.dta",clear
	gen g = 2011 if  inlist(dsp,230103,310117,330103) 
	replace g = 2012 if  inlist(dsp,220102 ,330483 ,350402,530402 , 620423, 460108) 
	replace g = 2014 if  inlist(dsp,110101,341823,410306,469021) 
	recode g (.=0)
	drop treated
	gen treated =1 if g !=0
	keep dspcode year drinking30 treated sex prop_65 log_gdp g
save	"${OUT}/final with 18 random select untreated_clear_did.dta",replace


	
use "${OUT}/final with 18 random select_fin2.dta",clear
ren (treated treated_g) (post treat)
	
	ren  time_window  yr
	xtset dspcode year
	tab yr,gen(eventt) // 年度虚拟变量	
	
	//drop eventt1
	cls	
	*政策随时间变化
	preserve
	xtreg drinking30   eventt1 eventt2 eventt3 eventt4 eventt6 eventt7 eventt8 eventt9  eventt10 eventt11 i.year i.dspcode, r fe	
	outreg2 using "${OUT}/Table_dynamic.xls",replace excel stats(coef pval) dec(3) alpha(0.01,0.05,0.1) symbol(***,**,*)   	

	coefplot, ///
	   keep(eventt*)  ///
	   coeflabels(eventt1 = "-7 years"   		///
	   eventt2 = "-5 years"   		///
	   eventt3 = "-4 years"             ///
	   eventt4 = "-2 years"             ///
	   eventt6  = "1 years"             ///
	   eventt7  = "2 years"             ///
	   eventt8  = "3 years"             ///
	   eventt9  = "4 years"             ///
	   eventt10 = "6 years"				///
	   eventt11 = "7 years" )         	 ///
	   vertical                       ///
	   yline(0)                       ///
	   xline(4.66, lp(dash) )  			///	   
	   ytitle("Difference in Past-month Drinking Rate")                ///
	   xtitle("Years Relative to Intervention")                ///
	   addplot(line @b @at)                 ///
	   ciopts(recast(rcap))                 ///
	   scheme(cleanplots)
	graph save "${Result}/TW30.gph", replace
	graph export  "${Result}/TW30.png",replace
	restore 	

