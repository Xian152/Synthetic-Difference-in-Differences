***************************************************************	 
********************* 描述性	完整数据 ****************
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


gen group1 = 1 if inrange(year, 2007,2010) & treated2011 ==1
replace group1 = 2 if inrange(year, 2007,2010) & treated2011 ==0
gen group2 = 1 if inrange(year, 2013,2018) & treated2011 ==1
replace group2 = 2 if inrange(year, 2013,2018) & treated2011 ==0
gen group3 = 1 if inrange(year, 2007,2013) & treated2014 ==1
replace group3 = 2 if inrange(year, 2007,2013) & treated2014 ==0
gen group4 = 1 if inrange(year, 2015,2018) & treated2014 ==1
replace group4 = 2 if inrange(year, 2015,2018) & treated2014 ==0

gen group5 = 1 if inrange(year,2007,2015) & treated2017 ==1
replace group5 = 2 if inrange(year, 2007,2015) & treated2017 ==0
gen group6 = 1 if inlist(year,2018) & treated2017 ==1
replace group6 = 2 if inlist(year, 2018) & treated2017 ==0

	table1 , by(group1) vars(drinking12 contn\ drinking30  contn\  sex contn\ gdp_pc contn\ prop_60 contn\ prop_65 contn\  ) format(%2.1f) one mis saving("${Result}/DS1_treat_rawgroup1.xls", replace) 
	table1, by(group2) vars(drinking12 contn\ drinking30  contn\   sex contn\  gdp_pc contn\ prop_60 contn\ prop_65 contn\  ) format(%2.1f) one mis saving("${Result}/DS1_treat_rawgroup2.xls", replace) 

	table1, by(group3) vars(drinking12 contn\ drinking30  contn\  sex contn\ gdp_pc contn\ prop_60 contn\ prop_65 contn\  ) format(%2.1f) one mis saving("${Result}/DS1_treat_rawgroup3.xls", replace) 
	table1, by(group4) vars(drinking12 contn\ drinking30  contn\  sex contn\ gdp_pc contn\ prop_60 contn\ prop_65 contn\  ) format(%2.1f) one mis saving("${Result}/DS1_treat_rawgroup4.xls", replace) 

	table1, by(group5) vars(drinking12 contn\ drinking30  contn\   sex contn\ gdp_pc contn\ prop_60 contn\ prop_65 contn\  ) format(%2.1f) one mis saving("${Result}/DS1_treat_rawgroup5.xls", replace) 
	table1, by(group6) vars(drinking12 contn\ drinking30  contn\   overweight  contn\  obesity  contn\ sex contn\ gdp_pc contn\ prop_60 contn\ prop_65 contn\  ) format(%2.1f) one mis saving("${Result}/DS1_treat_rawgroup6.xls", replace) 


* 转向R——did package
**#
***************************************************************	 
********************* DID 基本回归	 ****************
***************************************************************	 
*simple did
/*ssc install cnssc,replace
cnssc install lxhget, replace
lxhget tsg_schemes.pkg, des
set scheme neon, perm
net install cleanplots, from("https://tdmize.github.io/data/cleanplots")
*/
use "/Volumes/alan/method paper/Data Analysis/final with 18 random select untreated.dta",clear
set scheme cleanplots, perm

	preserve
	sort treated_g year
	egen av_dk = mean(drinking12), by (treated_g year)
	*gen av_dk1 = av_dk if treated_g == 1
	*gen av_dk2 = av_dk if treated_g == 0
	duplicates drop treated_g year, force
	keep av_dk* treated_g year
	reshape wide av_dk*, i(year) j(treated_g)
	label var av_dk1  "Treated"
	label var av_dk0  "Controled"
	twoway (line av_dk1 av_dk0 year,sort)  , title("Prevalence of Drinking in the past 12 months") legend(ring(0) pos(5)) ytitle("Prevalence of Drinking") xlabel(2006(2)2018)  xtitle("year") ylabel(,nogrid)
	graph save "/Volumes/alan/method paper/Data Analysis/Graph_12.gph", replace	
	graph export "/Volumes/alan/method paper/Data Analysis/Graph_12.png",replace width(3000) height(2000)	
	restore
	
	preserve
	sort treated_g year
	egen av_dk = mean(drinking30), by (treated_g year)
	*gen av_dk1 = av_dk if treated_g == 1
	*gen av_dk2 = av_dk if treated_g == 0
	duplicates drop treated_g year, force
	keep av_dk treated_g year
	reshape wide av_dk, i(year) j(treated_g)
	ren (av_dk1 av_dk0) (Treated Controled)
	label var Treated "Treated"
	label var Controled "Controled"
	twoway line Treated Controled  year, title("Prevalence of Drinking in the past 30 months")  legend(ring(0) pos(5)) ytitle("Prevalence of Drinking") xlabel(2006(2)2018) 
	graph save "/Volumes/alan/method paper/Data Analysis/Graph_30.gph", replace	
	graph export "/Volumes/alan/method paper/Data Analysis/Graph_30.png",replace width(3000) height(2000)	
	restore

	
	//coefplot dynamic, vertical recast(connect) yline(0) xline() ciopts(recast( > rline) lpattern(dash))

graph combine   "/Volumes/alan/method paper/Data Analysis/Graph_12.gph" "/Volumes/alan/method paper/Data Analysis/Graph_30.gph" , row(2) title("Prevalence of Drinking") 
graph export "/Volumes/alan/method paper/Data Analysis/Select_Fig 1 Prevalence of Drinking.png",replace width(3000) height(2000)

***************************************************************	 
********************* TWFX	no adjustment ****************
***************************************************************	 
**#
use "/Volumes/alan/method paper/Data Analysis/final with 18 random select untreated.dta",clear
ren (treated treated_g) (post treat)
	
	ren  time_window  yr
	xtset dspcode year
	tab yr,gen(eventt) // 年度虚拟变量	
	
	drop eventt5
	cls	
	*政策随时间变化
	preserve
	xtreg drinking30  eventt1 eventt2 eventt3 eventt4  eventt6 eventt7 eventt8 eventt9  eventt10 i.year i.dspcode, r fe	
	coefplot, ///
	   keep(eventt*)  ///
	   coeflabels(eventt1 = "-7 years" ///
	   eventt2 = "-5 years"   		///
	   eventt3 = "-4 years"             ///
	   eventt4 = "-2 years"             ///
	   eventt6  = "1 year"             ///
	   eventt7  = "2 years"             ///
	   eventt8  = "3 years"             ///
	   eventt9  = "4 years"             ///
	   eventt10 = "6 years"				///
	   eventt11 = "7 years" )         	 ///
	   vertical                       ///
	   yline(0)                       ///
	   xline(4.66, lp(dash) )  			///	   
	   ytitle("Effect of Implementation")               ///	   
	   title("Time passage relative to year of implementation") ///
	   addplot(line @b @at)                 ///
	   ciopts(recast(rcap))                 ///
	   scheme(cleanplots)
	graph save "/Volumes/alan/method paper/Data Analysis/TW30.gph", replace
	graph export "/Volumes/alan/method paper/Data Analysis/TW30.png",replace
	restore 	


	preserve
	xtreg drinking12  eventt* i.year i.dspcode, r fe	
	coefplot, ///
	   keep(eventt*)  ///
	   coeflabels( eventt1 = "-7 years" ///
	   eventt2 = "-5 years"  			 ///
	   eventt3 = "-4 years"             ///
	   eventt4 = "-2 years"             ///
	   eventt6  = "1 year"             ///
	   eventt7  = "2 years"             ///
	   eventt8  = "3 years"             ///
	   eventt9  = "4 years"             ///
	   eventt10 = "6 years"        		 ///
	   eventt11 = "7 years" )         	 ///
	   vertical                       ///
	   yline(0)                       ///
	   xline(4.66, lp(dash) )  ///	 
	   ytitle("Effect of Implementation")               ///	   
	   title("Time passage relative to year of implementation") ///
	   addplot(line @b @at)                 ///
	   ciopts(recast(rcap))                 ///
	   scheme(cleanplots)
	graph save "/Volumes/alan/method paper/Data Analysis/TW12.gph", replace
	graph export "/Volumes/alan/method paper/Data Analysis/TW12.png",replace
	restore 	

	
graph combine  "/Volumes/alan/method paper/Data Analysis/TW30.gph" "/Volumes/alan/method paper/Data Analysis/TW12.gph" ,row(2) title("Time passage relative to year of implementation") 
graph export "/Volumes/alan/method paper/Data Analysis/Select_Time passage drinking.png",replace width(3000) height(2000)	
	
	xtreg drinking30  eventt* i.year i.dspcode, r fe
	outreg2 using "/Volumes/alan/method paper/Data Analysis/Select_TWFE_drinking.doc",replace word stats(coef ci) dec(3) alpha(0.01,0.05,0.1,0.15) symbol(***,**,*,+) 
	xtreg drinking12  eventt* i.year i.dspcode, r fe
	outreg2 using "/Volumes/alan/method paper/Data Analysis/Select_TWFE_drinking.doc",replace word stats(coef ci) dec(3) alpha(0.01,0.05,0.1,0.15) symbol(***,**,*,+)

preserve
	//drop if treated2011 == 1 //2011
	drop if treated2012 == 1 //2011
	drop if treated2014 == 1 //2011
	xtreg drinking30  post i.year i.dspcode, r fe
	outreg2 using "/Volumes/alan/method paper/Data Analysis/Select_ATE_drinking.doc",replace word stats(coef ci) dec(3) alpha(0.01,0.05,0.1,0.15) symbol(***,**,*,+) 
	xtreg drinking12  post i.year i.dspcode, r fe
restore	

preserve
	drop if treated2011 == 1 //2011
	//drop if treated2012 == 1 //2011
	drop if treated2014 == 1 //2011
	xtreg drinking30  post i.year i.dspcode, r fe
	outreg2 using "/Volumes/alan/method paper/Data Analysis/Select_ATE_drinking.doc",append word stats(coef ci) dec(3) alpha(0.01,0.05,0.1,0.15) symbol(***,**,*,+) 
restore
	
preserve
	drop if treated2011 == 1 //2011
	drop if treated2012 == 1 //2011
	//drop if treated2014 == 1 //2011
	xtreg drinking30  post i.year i.dspcode, r fe
	outreg2 using "/Volumes/alan/method paper/Data Analysis/Select_ATE_drinking.doc",append word stats(coef ci) dec(3) alpha(0.01,0.05,0.1,0.15) symbol(***,**,*,+) 
restore	
	
preserve
	xtreg drinking30  post i.year i.dspcode, r fe
	outreg2 using "/Volumes/alan/method paper/Data Analysis/Select_ATE_drinking.doc",append word stats(coef ci) dec(3) alpha(0.01,0.05,0.1,0.15) symbol(***,**,*,+) 
restore		



preserve
	//drop if treated2011 == 1 //2011
	drop if treated2012 == 1 //2011
	drop if treated2014 == 1 //2011
	xtreg drinking30  post i.year i.dspcode, r fe
	outreg2 using "/Volumes/alan/method paper/Data Analysis/Select_ATE_drinking.doc",replace word stats(coef ci) dec(3) alpha(0.01,0.05,0.1,0.15) symbol(***,**,*,+) 
	xtreg drinking12  post i.year i.dspcode, r fe
restore	

preserve
	drop if treated2011 == 1 //2011
	//drop if treated2012 == 1 //2011
	drop if treated2014 == 1 //2011
	xtreg drinking30  post i.year i.dspcode, r fe
	outreg2 using "/Volumes/alan/method paper/Data Analysis/Select_ATE_drinking.doc",append word stats(coef ci) dec(3) alpha(0.01,0.05,0.1,0.15) symbol(***,**,*,+) 
restore
	
preserve
	drop if treated2011 == 1 //2011
	drop if treated2012 == 1 //2011
	//drop if treated2014 == 1 //2011
	xtreg drinking30  post i.year i.dspcode, r fe
	outreg2 using "/Volumes/alan/method paper/Data Analysis/Select_ATE_drinking.doc",append word stats(coef ci) dec(3) alpha(0.01,0.05,0.1,0.15) symbol(***,**,*,+) 
restore	
	
preserve
	xtreg drinking30  post i.year i.dspcode, r fe
	outreg2 using "/Volumes/alan/method paper/Data Analysis/Select_ATE_drinking.doc",append word stats(coef ci) dec(3) alpha(0.01,0.05,0.1,0.15) symbol(***,**,*,+) 
restore		



***************************************************************	 
********************* 合成控制法	多个 ****************
***************************************************************	 	
use "/Volumes/alan/method paper/Data Analysis/final with 18 random select untreated.dta",clear

** 全部
preserve
	//drop if treated2011 == 1 //2011
	//drop if treated2012 == 1 //2011
	//drop if treated2014 == 1 //2011
	ren (treated treated_g) (post treat)

	xtset dspcode year    
	tab year,gen(timeto)

	drop timeto2 
	//set trace on

	destring timeto*  ,replace

cls
foreach k in drinking30  drinking12 {  
	synth_runner `k' sex prop_65 log_gdp second_ind ,d(post) pre_rmspe post_rmspe  
	 effect_graphs , trlinediff(-10) effect_gname(`k'_effect) tc_gname(`k'_tc) tc_options(xtitle("Period"))
	graph save "`k'_effect" "/Volumes/alan/method paper/Data Analysis/`k'_effect_1.gph",replace
	qui pval_graphs , pvals_gname(`k'_pval) pvals_std_gname(`k'_pval_t)  xtitle("Periods after Implementation (Leads)--First Batch") ytitle("P-Values")
	//pvals_options(title("Lead Specific Significance Level (P-Values) for `k'")) 
	graph save "`k'_pval" "/Volumes/alan/method paper/Data Analysis/graph_`k'_pvals.gph",replace
	graph save "`k'_pval_t" "/Volumes/alan/method paper/Data Analysis/graph_`k'_pvals_t.gph",replace
	
	foreach  g in n_pl  pval_joint_post pval_joint_post_t avg_pre_rmspe_p avg_val_rmspe_p{
		local `g' = e(`g')
		dis ``g''
	}
	foreach m in treat_control b pvals pvals_std{
		matrix list e(`m')
		mat `m' = e(`m')
	}
}
restore

** 第一部分
preserve
	//drop if treated2011 == 1 //2011
	drop if treated2012 == 1 //2011
	drop if treated2014 == 1 //2011
	ren (treated treated_g) (post treat)

	xtset dspcode year    
	tab year,gen(timeto)

	drop timeto2 
	//set trace on

	destring timeto*  ,replace

cls
foreach k in drinking30  {  
	synth_runner `k' sex prop_65 log_gdp second_ind ,d(post) pre_rmspe post_rmspe  
	 effect_graphs , trlinediff(-10) effect_gname(`k'_effect) tc_gname(`k'_tc) tc_options(xtitle("Period"))
	graph save "`k'_effect" "/Volumes/alan/method paper/Data Analysis/`k'_effect_1.gph",replace
	qui pval_graphs , pvals_gname(`k'_pval) pvals_std_gname(`k'_pval_t)  xtitle("Periods after Implementation (Leads)--First Batch") ytitle("P-Values")
	//pvals_options(title("Lead Specific Significance Level (P-Values) for `k'")) 
	graph save "`k'_pval" "/Volumes/alan/method paper/Data Analysis/graph_`k'_pvals_round1.gph",replace
	graph save "`k'_pval_t" "/Volumes/alan/method paper/Data Analysis/graph_`k'_pvals_t_round1.gph",replace
	
	foreach  g in n_pl  pval_joint_post pval_joint_post_t avg_pre_rmspe_p avg_val_rmspe_p{
		local `g' = e(`g')
		dis ``g''
	}
	foreach m in treat_control b pvals pvals_std{
		matrix list e(`m')
		mat `m' = e(`m')
	}
}
restore
** 第二部分
preserve
	drop if treated2011 == 1 //2011
	//drop if treated2012 == 1 //2011
	drop if treated2014 == 1 //2011
	ren (treated treated_g) (post treat)

	xtset dspcode year    
	tab year,gen(timeto)

	drop timeto2 
	//set trace on

	destring timeto*  ,replace

foreach k in drinking30   {  
	synth_runner `k' sex prop_65 log_gdp second_ind ,d(post) pre_rmspe post_rmspe  
	 effect_graphs , trlinediff(-10) effect_gname(`k'_effect) tc_gname(`k'_tc) tc_options(xtitle("Period"))
	graph save "`k'_effect" "/Volumes/alan/method paper/Data Analysis/`k'_effect_2.gph",replace
	qui pval_graphs , pvals_gname(`k'_pval) pvals_std_gname(`k'_pval_t)  xtitle("Periods after Implementation (Leads)--Second Batch") ytitle("P-Values")
	//pvals_options(title("Lead Specific Significance Level (P-Values) for `k'")) 
	graph save "`k'_pval" "/Volumes/alan/method paper/Data Analysis/graph_`k'_pvals_round2.gph",replace
	graph save "`k'_pval_t" "/Volumes/alan/method paper/Data Analysis/graph_`k'_pvals_t_round2.gph",replace
	
	foreach  g in n_pl  pval_joint_post pval_joint_post_t avg_pre_rmspe_p avg_val_rmspe_p{
		local `g' = e(`g')
		dis ``g''
	}
	foreach m in treat_control b pvals pvals_std{
		matrix list e(`m')
		mat `m' = e(`m')
	}
}
restore

** 第三部分
preserve
	drop if treated2011 == 1 //2011
	drop if treated2012 == 1 //2011
	//drop if treated2014 == 1 //2011

	ren (treated treated_g) (post treat)

	xtset dspcode year    
	tab year,gen(timeto)

	drop timeto2 
	//set trace on

	destring timeto*  ,replace

foreach k in drinking30   {  
	synth_runner `k' sex prop_65 log_gdp second_ind ,d(post) pre_rmspe post_rmspe  
	 effect_graphs , trlinediff(-10) effect_gname(`k'_effect) tc_gname(`k'_tc) tc_options(xtitle("Period"))
	graph save "`k'_effect" "/Volumes/alan/method paper/Data Analysis/`k'_effect_3.gph",replace
	qui pval_graphs , pvals_gname(`k'_pval) pvals_std_gname(`k'_pval_t)  xtitle("Periods after Implementation (Leads)--Third Batch") ytitle("P-Values")
	//pvals_options(title("Lead Specific Significance Level (P-Values) for `k'")) 
	graph save "`k'_pval" "/Volumes/alan/method paper/Data Analysis/graph_`k'_pvals_round3.gph",replace
	graph save "`k'_pval_t" "/Volumes/alan/method paper/Data Analysis/graph_`k'_pvals_t_round3.gph",replace
	
	foreach  g in n_pl  pval_joint_post pval_joint_post_t avg_pre_rmspe_p avg_val_rmspe_p{
		local `g' = e(`g')
		dis ``g''
	}
	foreach m in treat_control b pvals pvals_std{
		matrix list e(`m')
		mat `m' = e(`m')
	}
}
restore

preserve
	ren (treated treated_g) (post treat)

	xtset dspcode year    
	tab year,gen(timeto)

	drop timeto2 
	//set trace on

	destring timeto*  ,replace

foreach k in drinking30  drinking12 {  
	synth_runner `k' sex prop_65 log_gdp second_ind ,d(post) pre_rmspe post_rmspe  
	 effect_graphs , trlinediff(-10) effect_gname(`k'_effect) tc_gname(`k'_tc) tc_options(xtitle("Period"))
	graph save "`k'_effect" "/Volumes/alan/method paper/Data Analysis/`k'_effect.gph",replace
	qui pval_graphs , pvals_gname(`k'_pval) pvals_std_gname(`k'_pval_t)  xtitle("Periods after Implementation (Leads)--Total") ytitle("P-Values")
	//pvals_options(title("Lead Specific Significance Level (P-Values) for `k'")) 
	graph save "`k'_pval" "/Volumes/alan/method paper/Data Analysis/graph_`k'_pvals.gph",replace
	graph save "`k'_pval_t" "/Volumes/alan/method paper/Data Analysis/graph_`k'_pvals_t.gph",replace
	
	foreach  g in n_pl  pval_joint_post pval_joint_post_t avg_pre_rmspe_p avg_val_rmspe_p{
		local `g' = e(`g')
		dis ``g''
	}
	foreach m in treat_control b pvals pvals_std{
		matrix list e(`m')
		mat `m' = e(`m')
	}
}
restore
	
	

***************************************************************	 
********************* sdid	 ****************
***************************************************************	 
use "/Volumes/alan/method paper/Data Analysis/final with 18 random select untreated",clear

label variable BMI "BMI(kg/m²)" 
label variable  waist "Waist(cm)"   
label variable  obesity "Prevelance of Obesity" 
label variable  overweight "Prevelance of Overweight" 

label values dsp county 

xtset dsp year    

cls
** 第1部分--综合
preserve
	//drop if treated2011 == 1 //2011
	drop if treated2012 == 1 //2011
	drop if treated2014 == 1 //2011

		sdid drinking30  dsp year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp   , projected) method(did) ///
		graph g1on  ///
		g1_opt(ytitle("Differences") xtitle("Counties") title("Difference-in-Difference") legend(ring(0) pos(5)))  ///
		g2_opt(ytitle("Prevelence of Drinking") xtitle("year")  xlabel(2005(2)2020) title("Difference-in-Difference") ) 	
		graph save "g2_2013" "/Volumes/alan/method paper/Data Analysis/drinking30_did—ATE—1.gph",replace
		graph save "g1_2013" "/Volumes/alan/method paper/Data Analysis/drinking30_did—weight—1.gph",replace
		outreg2 using "/Volumes/alan/method paper/Data Analysis/Select_allresults——1.doc",replace word stats(coef ci) dec(3) alpha(0.01,0.05,0.1,0.15) symbol(***,**,*,+)

		sdid drinking30  dsp year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp   , projected) method(sc) ///
		graph g1on  ///
		g1_opt(ytitle("Differences") xtitle("Counties") title("Synthetic Control") legend(ring(0) pos(5)))  ///
		g2_opt(ytitle("Prevelence of Drinking") xtitle("year")  xlabel(2005(2)2020) title("Synthetic Control") ) 	
		graph save "g2_2013" "/Volumes/alan/method paper/Data Analysis/drinking30_sc—ATE—1.gph",replace
		graph save "g1_2013" "/Volumes/alan/method paper/Data Analysis/drinking30_sc—weight—1.gph",replace
		outreg2 using "/Volumes/alan/method paper/Data Analysis/Select_allresults——1.doc",append word stats(coef ci) dec(3) alpha(0.01,0.05,0.1,0.15) symbol(***,**,*,+)


		sdid drinking30  dsp year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp   , projected) method(sdid) ///
		graph g1on  ///
		g1_opt(ytitle("Differences") xtitle("Counties") title("Synthetic DID") legend(ring(0) pos(5)))  ///
		g2_opt(ytitle("Prevelence of Drinking") xtitle("year")  xlabel(2005(2)2020) title("Synthetic DID") ) 	
		graph save "g2_2013" "/Volumes/alan/method paper/Data Analysis/drinking30_sdid—ATE—1.gph",replace
		graph save "g1_2013" "/Volumes/alan/method paper/Data Analysis/drinking30_sdid—weight—1.gph",replace
		outreg2 using "/Volumes/alan/method paper/Data Analysis/Select_allresults——1.doc",append word stats(coef ci) dec(3) alpha(0.01,0.05,0.1,0.15) symbol(***,**,*,+)

restore

** 第2 部分
preserve

	drop if treated2011 == 1 //2011
	//drop if treated2012 == 1 //2011
	drop if treated2014 == 1 //2011
	
		sdid drinking30  dsp year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp   , projected) method(did) ///
		graph g1on  ///
		g1_opt(ytitle("Differences") xtitle("Counties") title("Difference-in-Difference") legend(ring(0) pos(5)))  ///
		g2_opt(ytitle("Prevelence of Drinking") xtitle("year")  xlabel(2005(2)2020) title("Difference-in-Difference") ) 	
		graph save "g2_2013" "/Volumes/alan/method paper/Data Analysis/drinking30_did—ATE—2.gph",replace
		graph save "g1_2013" "/Volumes/alan/method paper/Data Analysis/drinking30_did—weight—2.gph",replace
		outreg2 using "/Volumes/alan/method paper/Data Analysis/Select_allresults——2.doc",replace word stats(coef ci) dec(3) alpha(0.01,0.05,0.1,0.15) symbol(***,**,*,+)

		sdid drinking30  dsp year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp   , projected) method(sc) ///
		graph g1on  ///
		g1_opt(ytitle("Differences") xtitle("Counties") title("Synthetic Control") legend(ring(0) pos(5)))  ///
		g2_opt(ytitle("Prevelence of Drinking") xtitle("year")  xlabel(2005(2)2020) title("Synthetic Control") ) 	
		graph save "g2_2013" "/Volumes/alan/method paper/Data Analysis/drinking30_sc—ATE—2.gph",replace
		graph save "g1_2013" "/Volumes/alan/method paper/Data Analysis/drinking30_sc—weight—2.gph",replace
		outreg2 using "/Volumes/alan/method paper/Data Analysis/Select_allresults——2.doc",append word stats(coef ci) dec(3) alpha(0.01,0.05,0.1,0.15) symbol(***,**,*,+)


		sdid drinking30  dsp year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp   , projected) method(sdid) ///
		graph g1on  ///
		g1_opt(ytitle("Differences") xtitle("Counties") title("Synthetic DID") legend(ring(0) pos(5)))  ///
		g2_opt(ytitle("Prevelence of Drinking") xtitle("year")  xlabel(2005(2)2020) title("Synthetic DID") ) 	
		graph save "g2_2013" "/Volumes/alan/method paper/Data Analysis/drinking30_sdid—ATE—2.gph",replace
		graph save "g1_2013" "/Volumes/alan/method paper/Data Analysis/drinking30_sdid—weight—2.gph",replace
		outreg2 using "/Volumes/alan/method paper/Data Analysis/Select_allresults——2.doc",append word stats(coef ci) dec(3) alpha(0.01,0.05,0.1,0.15) symbol(***,**,*,+)

restore

** 第3部分--综合
preserve
	drop if treated2011 == 1 //2011
	drop if treated2012 == 1 //2011
	//drop if treated2014 == 1 //2011
 
		sdid drinking30  dsp year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp   , projected) method(did) ///
		graph g1on  ///
		g1_opt(ytitle("Differences") xtitle("Counties") title("Difference-in-Difference") legend(ring(0) pos(5)))  ///
		g2_opt(ytitle("Prevelence of Drinking") xtitle("year")  xlabel(2005(2)2020) title("Difference-in-Difference") ) 	
		graph save "g2_2015" "/Volumes/alan/method paper/Data Analysis/drinking30_did—ATE—3.gph",replace
		graph save "g1_2015" "/Volumes/alan/method paper/Data Analysis/drinking30_did—weight—3.gph",replace
		outreg2 using "/Volumes/alan/method paper/Data Analysis/Select_allresults——3.doc",replace word stats(coef ci) dec(3) alpha(0.01,0.05,0.1,0.15) symbol(***,**,*,+)

		sdid drinking30  dsp year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp   , projected) method(sc) ///
		graph g1on  ///
		g1_opt(ytitle("Differences") xtitle("Counties") title("Synthetic Control") legend(ring(0) pos(5)))  ///
		g2_opt(ytitle("Prevelence of Drinking") xtitle("year")  xlabel(2005(2)2020) title("Synthetic Control") ) 	
		graph save "g2_2015" "/Volumes/alan/method paper/Data Analysis/drinking30_sc—ATE—3.gph",replace
		graph save "g1_2015" "/Volumes/alan/method paper/Data Analysis/drinking30_sc—weight—3.gph",replace
		outreg2 using "/Volumes/alan/method paper/Data Analysis/Select_allresults——3.doc",append word stats(coef ci) dec(3) alpha(0.01,0.05,0.1,0.15) symbol(***,**,*,+)


		sdid drinking30  dsp year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp   , projected) method(sdid) ///
		graph g1on  ///
		g1_opt(ytitle("Differences") xtitle("Counties") title("Synthetic DID") legend(ring(0) pos(5)))  ///
		g2_opt(ytitle("Prevelence of Drinking") xtitle("year")  xlabel(2005(2)2020) title("Synthetic DID") ) 	
		graph save "g2_2015" "/Volumes/alan/method paper/Data Analysis/drinking30_sdid—ATE—3.gph",replace
		graph save "g1_2015" "/Volumes/alan/method paper/Data Analysis/drinking30_sdid—weight—3.gph",replace
		outreg2 using "/Volumes/alan/method paper/Data Analysis/Select_allresults——3.doc",append word stats(coef ci) dec(3) alpha(0.01,0.05,0.1,0.15) symbol(***,**,*,+)		
restore



* In details combine placeto results

graph combine "/Volumes/alan/method paper/Data Analysis/drinking30_did—ATE—1.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sc—ATE—1.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sdid—ATE—1.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_did—ATE—2.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sc—ATE—2.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sdid—ATE—2.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_did—ATE—3.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sc—ATE—3.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sdid—ATE—3.gph", rows(3) 
graph export "/Volumes/alan/method paper/Data Analysis/all-ATE.png",replace width(4000)  height(4000)

graph combine "/Volumes/alan/method paper/Data Analysis/drinking30_did—ATE—2.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sc—ATE—2.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sdid—ATE—2.gph" , rows(1)  title("The Third Batch") 
graph export "/Volumes/alan/method paper/Data Analysis/2-ATE.png",replace 

graph combine "/Volumes/alan/method paper/Data Analysis/drinking30_did—ATE—3.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sc—ATE—3.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sdid—ATE—3.gph" , rows(1)  title("The Third Batch") 
graph export "/Volumes/alan/method paper/Data Analysis/3-ATE.png",replace 


graph combine "/Volumes/alan/method paper/Data Analysis/drinking30_did—weight—1.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sc—weight—1.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sdid—weight—1.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_did—weight—2.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sc—weight—2.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sdid—weight—2.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_did—weight—3.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sc—weight—3.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sdid—weight—3.gph", rows(3)  
graph export "/Volumes/alan/method paper/Data Analysis/all-weight.png",replace  width(4000)  height(4000)

graph combine "/Volumes/alan/method paper/Data Analysis/drinking30_did—weight—2.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sc—weight—2.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sdid—weight—2.gph" , rows(1)  title("The Third Batch") 
graph export "/Volumes/alan/method paper/Data Analysis/2-weight.png",replace 

graph combine "/Volumes/alan/method paper/Data Analysis/drinking30_did—weight—3.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sc—weight—3.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sdid—weight—3.gph" , rows(1)  title("The Third Batch") 
graph export "/Volumes/alan/method paper/Data Analysis/3-weight.png",replace 




graph combine "/Volumes/alan/method paper/Data Analysis/drinking30_sdid—ATE—3.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sdid—ATE—3.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sdid—ATE—3.gph" , rows(1)  title("Sdid--Unit Weight") hole(12) imargin(0 0 0 0) 
graph export "/Volumes/alan/method paper/Data Analysis/Sdid--Unit Weight.png",replace width(3000) height(3000)





******in details
graph combine "/Volumes/alan/method paper/Data Analysis/drinking30_sdid_effect_1.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sdid_effect_1_short.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sdid_effect_1_mid.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sdid_effect_1_Long.gph" ///
"/Volumes/alan/method paper/Data Analysis/drinking30_sdid_effect_2.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sdid_effect_2_short.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sdid_effect_2_mid.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sdid_effect_2_Long.gph" ///
"/Volumes/alan/method paper/Data Analysis/drinking30_sdid_effect_3.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sdid_effect_3_short.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sdid_effect_3_mid.gph" ///
 "/Volumes/alan/method paper/Data Analysis/drinking30_sdid_effect_4.gph"  "/Volumes/alan/method paper/Data Analysis/drinking30_sdid_effect_4_short.gph"  , rows(4) cols(4) title("Prevalence of Drinking(30 days)") hole(12) imargin(0 0 0 0) 
graph export "/Volumes/alan/method paper/Data Analysis/sdid drinking30 effect with 18.png",replace width(3000) height(3000)

graph combine "/Volumes/alan/method paper/Data Analysis/drinking12_sdid_effect_1.gph" "/Volumes/alan/method paper/Data Analysis/drinking12_sdid_effect_1_short.gph" "/Volumes/alan/method paper/Data Analysis/drinking12_sdid_effect_1_mid.gph" "/Volumes/alan/method paper/Data Analysis/drinking12_sdid_effect_1_Long.gph" ///
"/Volumes/alan/method paper/Data Analysis/drinking12_sdid_effect_2.gph"  "/Volumes/alan/method paper/Data Analysis/drinking12_sdid_effect_2_short.gph" "/Volumes/alan/method paper/Data Analysis/drinking12_sdid_effect_2_mid.gph" "/Volumes/alan/method paper/Data Analysis/drinking12_sdid_effect_2_Long.gph" ///
"/Volumes/alan/method paper/Data Analysis/drinking12_sdid_effect_3_short.gph" "/Volumes/alan/method paper/Data Analysis/drinking12_sdid_effect_3_short.gph" "/Volumes/alan/method paper/Data Analysis/drinking12_sdid_effect_3_mid.gph" ///
 "/Volumes/alan/method paper/Data Analysis/drinking12_sdid_effect_4.gph" "/Volumes/alan/method paper/Data Analysis/drinking12_sdid_effect_4_short.gph"   , rows(4) cols(4) title("Prevalence of Drinking(12 months)") hole(12) imargin(0 0 0 0) 
graph export "/Volumes/alan/method paper/Data Analysis/sdid drinking12 effect with 18.png",replace width(3000) height(3000) 


graph combine "/Volumes/alan/method paper/Data Analysis/drinking12_sdid_difference_1.gph"  "/Volumes/alan/method paper/Data Analysis/drinking12_sdid_effect_1_difference.gph" "/Volumes/alan/method paper/Data Analysis/drinking12_sdid_difference_1_mid.gph" "/Volumes/alan/method paper/Data Analysis/drinking12_sdid_difference_1_Long.gph" ///
"/Volumes/alan/method paper/Data Analysis/drinking30_sdid_difference_2.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sdid_difference_2_short.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sdid_difference_2_mid.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sdid_difference_2_Long.gph" ///
"/Volumes/alan/method paper/Data Analysis/drinking30_sdid_difference_3.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sdid_difference_3_short.gph" "/Volumes/alan/method paper/Data Analysis/drinking30_sdid_difference_3_mid.gph" ///
 "/Volumes/alan/method paper/Data Analysis/drinking30_sdid_difference_4.gph"   "/Volumes/alan/method paper/Data Analysis/drinking30_sdid_difference_4_short.gph"   , rows(4) cols(4) title("Prevalence of Drinking(30 days)") hole(12) imargin(0 0 0 0) 
graph export "/Volumes/alan/method paper/Data Analysis/sdid drinking30 difference with 18.png",replace width(3000) height(3000)

graph combine "/Volumes/alan/method paper/Data Analysis/drinking12_sdid_difference_1.gph" "/Volumes/alan/method paper/Data Analysis/drinking12_sdid_difference_1_short.gph" "/Volumes/alan/method paper/Data Analysis/drinking12_sdid_difference_1_mid.gph" "/Volumes/alan/method paper/Data Analysis/drinking12_sdid_difference_1_Long.gph" ///
 "/Volumes/alan/method paper/Data Analysis/drinking12_sdid_difference_2.gph"  "/Volumes/alan/method paper/Data Analysis/drinking12_sdid_difference_2_short.gph" "/Volumes/alan/method paper/Data Analysis/drinking12_sdid_difference_2_mid.gph" "/Volumes/alan/method paper/Data Analysis/drinking12_sdid_difference_2_Long.gph" ///
"/Volumes/alan/method paper/Data Analysis/drinking12_sdid_difference_3.gph"  "/Volumes/alan/method paper/Data Analysis/drinking12_sdid_difference_3_short.gph" "/Volumes/alan/method paper/Data Analysis/drinking12_sdid_difference_3_mid.gph" ///
 "/Volumes/alan/method paper/Data Analysis/drinking12_sdid_difference_4.gph"   "/Volumes/alan/method paper/Data Analysis/drinking12_sdid_difference_4_short.gph" , rows(4) cols(4) title("Prevalence of Drinking(12 months)") hole(12) imargin(0 0 0 0) 
graph export "/Volumes/alan/method paper/Data Analysis/sdid drinking12 difference with 18.png",replace width(3000) height(3000)



******in details
graph combine "/Volumes/alan/method paper/Data Analysis/drinking30_sdid_effect_1.gph"  ///
"/Volumes/alan/method paper/Data Analysis/drinking30_sdid_effect_2.gph"  ///
"/Volumes/alan/method paper/Data Analysis/drinking30_sdid_effect_3.gph"  ///
 "/Volumes/alan/method paper/Data Analysis/drinking30_sdid_effect_4.gph"    , rows(2) cols(2) title("Prevalence of Drinking(30 days)") imargin(0 0 0 0) 
graph export "/Volumes/alan/method paper/Data Analysis/sdid drinking30 effect with 18_rough.png",replace width(3000) height(3000)

graph combine "/Volumes/alan/method paper/Data Analysis/drinking12_sdid_effect_1.gph"  ///
"/Volumes/alan/method paper/Data Analysis/drinking12_sdid_effect_2.gph"   ///
"/Volumes/alan/method paper/Data Analysis/drinking12_sdid_effect_3.gph"  ///
 "/Volumes/alan/method paper/Data Analysis/drinking12_sdid_effect_4.gph"  , rows(2) cols(2) title("Prevalence of Drinking(12 months)") imargin(0 0 0 0) 
graph export "/Volumes/alan/method paper/Data Analysis/sdid drinking12 effect with 18_rough.png",replace width(3000) height(3000) 


graph combine "/Volumes/alan/method paper/Data Analysis/drinking12_sdid_difference_1.gph"   ///
"/Volumes/alan/method paper/Data Analysis/drinking30_sdid_difference_2.gph"  ///
"/Volumes/alan/method paper/Data Analysis/drinking30_sdid_difference_3.gph" ///
 "/Volumes/alan/method paper/Data Analysis/drinking30_sdid_difference_4.gph"    , rows(2) cols(2) title("Prevalence of Drinking(30 days)") imargin(0 0 0 0) 
graph export "/Volumes/alan/method paper/Data Analysis/sdid drinking30 difference with 18_rough.png",replace width(3000) height(3000)

graph combine "/Volumes/alan/method paper/Data Analysis/drinking12_sdid_difference_1.gph"  ///
 "/Volumes/alan/method paper/Data Analysis/drinking12_sdid_difference_2.gph"   ///
"/Volumes/alan/method paper/Data Analysis/drinking12_sdid_difference_3.gph"  ///
 "/Volumes/alan/method paper/Data Analysis/drinking12_sdid_difference_4.gph"   , rows(2) cols(2) title("Prevalence of Drinking(12 months)") imargin(0 0 0 0) 
graph export "/Volumes/alan/method paper/Data Analysis/sdid drinking12 difference with 18_rough.png",replace width(3000) height(3000)



********************* sdid	 ****************
***************************************************************	 
use "/Volumes/alan/method paper/Data Analysis/final with 18 random select untreated",clear

label variable BMI "BMI(kg/m²)" 
label variable  waist "Waist(cm)"   
label variable  obesity "Prevelance of Obesity" 
label variable  overweight "Prevelance of Overweight" 

label values dsp county 

xtset dsp year    

net install sdid, from("https://raw.githubusercontent.com/daniel-pailanir/sdid/master") replace


		sdid drinking30  dsp year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp   , projected) method(did) ///
		graph g1on  ///
		g1_opt(ytitle("Differences") xtitle("Counties") title("Difference-in-Difference") legend(ring(0) pos(5)))  ///
		g2_opt(ytitle("Prevelence of Drinking") xtitle("year")  xlabel(2005(2)2020) title("Difference-in-Difference") ) 	
		graph save "g2_DID" "/Volumes/alan/method paper/Data Analysis/drinking30_did.gph",replace
		graph save "g1_DID" "/Volumes/alan/method paper/Data Analysis/drinking30_did.gph",replace
		outreg2 using "/Volumes/alan/method paper/Data Analysis/Select_allresults.doc",replace word stats(coef ci) dec(3) alpha(0.01,0.05,0.1,0.15) symbol(***,**,*,+)

		sdid drinking30  dsp year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp   , projected) method(sc) ///
		graph g1on  ///
		g1_opt(ytitle("Differences") xtitle("Counties") title("Synthetic Control") legend(ring(0) pos(5)))  ///
		g2_opt(ytitle("Prevelence of Drinking") xtitle("year")  xlabel(2005(2)2020) title("Synthetic Control") ) 	
		graph save "g2_SC" "/Volumes/alan/method paper/Data Analysis/drinking30_sc.gph",replace
		graph save "g1_SC" "/Volumes/alan/method paper/Data Analysis/drinking30_sc.gph",replace
		outreg2 using "/Volumes/alan/method paper/Data Analysis/Select_allresults.doc",append word stats(coef ci) dec(3) alpha(0.01,0.05,0.1,0.15) symbol(***,**,*,+)


		sdid drinking30  dsp year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp   , projected) method(sdid) ///
		graph g1on  ///
		g1_opt(ytitle("Differences") xtitle("Counties") title("Synthetic DID") legend(ring(0) pos(5)))  ///
		g2_opt(ytitle("Prevelence of Drinking") xtitle("year")  xlabel(2005(2)2020) title("SDID-ATE") ) 	
		graph save "g2_SDID" "/Volumes/alan/method paper/Data Analysis/drinking30_sdid.gph",replace
		graph save "g1_SDID" "/Volumes/alan/method paper/Data Analysis/drinking30_sdid.gph",replace
		outreg2 using "/Volumes/alan/method paper/Data Analysis/Select_allresults.doc",append word stats(coef ci) dec(3) alpha(0.01,0.05,0.1,0.15) symbol(***,**,*,+)

		
***************************************************************	 
********************* 生成用于conditional parallel检验的数据--did ****************
***************************************************************	 
use "${OUT}/final with 18 random select_fin.dta",clear
	gen g = 2011 if  inlist(dsp,230103,310117) 
	replace g = 2012 if  inlist(dsp,220102,330483) 
	replace g = 2014 if  inlist(dsp,469021,500101) 
	recode g (.=0)
	drop treated
	gen treated =1 if g !=0
	keep dspcode year drinking30 treated sex prop_65 log_gdp g
save	"${OUT}/final with 18 random select untreated_clear_did.dta",replace


***************************************************************	 
********************* 对SC和SDID加权，回到did package得到dynamic results ****************
***************************************************************	 
use "${INT}/weight_11.dta",clear
	gen year = 2011
	append using "${INT}/weight_12.dta" 
	recode year (.=2012)	
	append using "${INT}/weight_14.dta" 
	recode year (.=2014)	
	merge m:1 dsp using "${RAW}/county name.dta"
	keep if _m ==3
	drop _m
	
	reshape wide did_w sc_w sdid_w,i(dspcode Name County) j(year)
	
	foreach k in did sc sdid{
		gen `k'_total = `k'_w2011*6/16 +  `k'_w2012*6/16 + `k'_w2014*4/16
	}
	
	order County sc_w2011 sdid_w2011 sc_w2012 sdid_w2012 sc_w2014 sdid_w2014 sc_total sdid_total
	
	
save "${OUT}/weight.dta" ,replace	

