use "/Volumes/alan/method paper/Data Analysis/final with 18.dta",clear
set scheme cleanplots, perm

foreach k in BMI waist overweight obesity overweightint obesityint centralobesity centralobesityint sbp dbp hypertension awarehypertension treathypertension controlhypertension diabetes awarediabetes treatdiabetes drugdiabetes controldiabetes{
	preserve
		sort treated_g year
		egen av_dk = mean(`k'), by (treated_g year)
		*gen av_dk1 = av_dk if treated_g == 1
		*gen av_dk2 = av_dk if treated_g == 0
		duplicates drop treated_g year, force
		keep av_dk* treated_g year
		reshape wide av_dk*, i(year) j(treated_g)
		label var av_dk1  "Treated"
		label var av_dk0  "Controled"
		twoway (line av_dk1 av_dk0 year,sort)  , title("`k'") legend(ring(0) pos(5)) ytitle("Mean")
		graph save "`k'.gph", replace	
	restore	
	//coefplot dynamic, vertical recast(connect) yline(0) xline() ciopts(recast( > rline) lpattern(dash))
}

graph combine BMI.gph waist.gph  obesity.gph overweight.gph obesityint.gph centralobesity.gph  , row(3) title("Anthropometric Measures") 
graph export "/Volumes/alan/method paper/Data Analysis/Fig 1 Trend of BMI&waist with 18.png",replace width(3000) height(1200)

graph combine sbp.gph dbp.gph hypertension.gph awarehypertension.gph treathypertension.gph controlhypertension.gph , row(3) title("hypertension") 
graph export "/Volumes/alan/method paper/Data Analysis/Fig 1 Trend of hypertension with 18.png",replace width(3000) height(1200)

graph combine diabetes.gph awarediabetes.gph treatdiabetes.gph drugdiabetes.gph controldiabetes.gph , row(3) title("diabetes") 
graph export "/Volumes/alan/method paper/Data Analysis/Fig 1 Trend of diabetes with 18.png",replace width(3000) height(1200)

***************************************************************	 
********************* TWFX	 ****************
***************************************************************	 
use "/Volumes/alan/method paper/Data Analysis/final with 18.dta",clear
ren (treated treated_g) (post treat)

	xtset dspcode year
	tab time_window,gen(eventt) // 年度虚拟变量	
	
	drop eventt1
		
	*政策随时间变化
foreach k in BMI waist overweight obesity overweightint obesityint centralobesity centralobesityint sbp dbp hypertension awarehypertension treathypertension controlhypertension diabetes awarediabetes treatdiabetes drugdiabetes controldiabetes{
	
	preserve
	xtreg `k'  eventt* i.year i.dspcode, r fe	
	coefplot, ///
	   keep(eventt*)  ///
	   coeflabels(eventt2 = "-5"   ///
	   eventt3 = "-4"             ///
	   eventt4 = "-2"             ///
	   eventt5 = "-1"              ///
	   eventt6  = "1"             ///
	   eventt7  = "2"             ///
	   eventt8  = "3"             ///
	   eventt9  = "4"             ///
	   eventt10 = "6"           ///
	   eventt11 = "7"  )         ///
	   vertical                       ///
	   yline(0)                       ///
	   title("`k'") ///
	   xline(4.5, lp(dash) )  ///	 
	   addplot(line @b @at)                 ///
	   ciopts(recast(rcap))                 ///
	   scheme(cleanplots)
	graph save "`k'.gph", replace
	restore 	
	
}	
graph combine BMI.gph waist.gph  obesity.gph overweight.gph obesityint.gph centralobesity.gph  , row(3) title("Anthropometric Measures") 
graph export "/Volumes/alan/method paper/Data Analysis/Timeserious BMI&waist with 18.png",replace width(3000) height(1200)

graph combine sbp.gph dbp.gph hypertension.gph awarehypertension.gph treathypertension.gph controlhypertension.gph , row(3) title("hypertension") 
graph export "/Volumes/alan/method paper/Data Analysis/Timeserious hypertension with 18.png",replace width(3000) height(1200)

graph combine diabetes.gph awarediabetes.gph treatdiabetes.gph drugdiabetes.gph controldiabetes.gph , row(3) title("diabetes") 
graph export "/Volumes/alan/method paper/Data Analysis/Timeserious diabetes with 18.png",replace width(3000) height(1200)

	xtreg BMI  eventt* i.year i.dspcode, r fe
	outreg2 BMI using "/Volumes/alan/method paper/Data Analysis/TWFE_Anthropometric Measures.doc",replace word stats(coef ci) dec(3) alpha(0.01,0.05,0.1,0.15) symbol(***,**,*,+) 
	
foreach k in waist overweight obesity overweightint obesityint centralobesity centralobesityint {
	xtreg `k'  eventt* i.year i.dspcode, r fe
	outreg2 using "/Volumes/alan/method paper/Data Analysis/TWFE_Anthropometric Measures.doc",append word stats(coef ci) dec(3) alpha(0.01,0.05,0.1,0.15) symbol(***,**,*,+) 
}	

	xtreg sbp  eventt* i.year i.dspcode, r fe
	outreg2 sbp using "/Volumes/alan/method paper/Data Analysis/TWFE_hypertension.doc",replace word stats(coef ci) dec(3) alpha(0.01,0.05,0.1,0.15) symbol(***,**,*,+) 
	
foreach k in  dbp hypertension awarehypertension treathypertension controlhypertension {
	xtreg `k'  eventt* i.year i.dspcode, r fe
	outreg2 using "/Volumes/alan/method paper/Data Analysis/TWFE_hypertension.doc",append word stats(coef ci) dec(3) alpha(0.01,0.05,0.1,0.15) symbol(***,**,*,+) 
}	

	xtreg  diabetes  eventt* i.year i.dspcode, r fe
	outreg2  diabetes using "/Volumes/alan/method paper/Data Analysis/TWFE_ diabetes.doc",replace word stats(coef ci) dec(3) alpha(0.01,0.05,0.1,0.15) symbol(***,**,*,+) 
	
foreach k in  awarediabetes treatdiabetes drugdiabetes controldiabetes{
	xtreg `k'  eventt* i.year i.dspcode, r fe
	outreg2 using "/Volumes/alan/method paper/Data Analysis/TWFE_diabetes.doc",append word stats(coef ci) dec(3) alpha(0.01,0.05,0.1,0.15) symbol(***,**,*,+) 
}	

***************************************************************	 
********************* 合成控制法	 ****************
***************************************************************	 
use "/Volumes/alan/method paper/Data Analysis/final with 18.dta",clear
label variable BMI "BMI(kg/m²)" 
label variable  waist "Waist(cm)"   
label variable  obesity "Prevelance of Obesity" 
label variable  overweight "Prevelance of Overweight" 


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


** 第一部分
drop if treated2014 == 1 
drop if treated2017 == 1 
ren (treated treated_g) (post treat)

xtset dspcode year    
gen log_gdp = log(gdp_pc)
tab year,gen(timeto)
tab dspcode if treat == 1 ,gen(eventarea)

drop timeto1 eventarea1

//set trace on

destring time* ,replace

foreach k in BMI waist overweight obesity overweightint obesityint centralobesity centralobesityint{
	synth_runner `k' sex prop_65 log_gdp second_ind ,d(post) pre_rmspe post_rmspe  
	effect_graphs , trlinediff(-10) effect_gname(`k'_effect) tc_gname(`k'_tc) tc_options(xtitle("Period`k'"))
	graph save "graph_`k'_effect.gph"  ,replace
	pval_graphs , pvals_gname(`k'_pval) pvals_std_gname(`k'_pval_t)  xtitle("`k'") ytitle("P-Values")
	//pvals_options(title("Lead Specific Significance Level (P-Values) for `k'")) 
	graph save "graph_`k'_pvals.gph",replace
/*	
	foreach  g in n_pl  pval_joint_post pval_joint_post_t avg_pre_rmspe_p avg_val_rmspe_p{
		local `g' = e(`g')
		dis ``g''
	}
	foreach m in treat_control b pvals pvals_std{
		matrix list e(`m')
		mat `m' = e(`m')
	}
*/	
}

foreach k in sbp dbp hypertension awarehypertension treathypertension controlhypertension{
	synth_runner `k' sex prop_65 log_gdp second_ind ,d(post) pre_rmspe post_rmspe  
	effect_graphs , trlinediff(-10) effect_gname(`k'_effect) tc_gname(`k'_tc) tc_options(xtitle("Period`k'"))
	graph save "graph_`k'_effect.gph"  ,replace
	pval_graphs , pvals_gname(`k'_pval) pvals_std_gname(`k'_pval_t)  xtitle("`k'") ytitle("P-Values")
	//pvals_options(title("Lead Specific Significance Level (P-Values) for `k'")) 
	graph save "graph_`k'_pvals.gph",replace
/*	
	foreach  g in n_pl  pval_joint_post pval_joint_post_t avg_pre_rmspe_p avg_val_rmspe_p{
		local `g' = e(`g')
		dis ``g''
	}
	foreach m in treat_control b pvals pvals_std{
		matrix list e(`m')
		mat `m' = e(`m')
	}
*/	
}
/*
foreach k in diabetes awarediabetes treatdiabetes drugdiabetes controldiabetes{
	synth_runner `k' sex prop_65 log_gdp second_ind ,d(post) pre_rmspe post_rmspe  
	effect_graphs , trlinediff(-10) effect_gname(`k'_effect) tc_gname(`k'_tc) tc_options(xtitle("Period`k'"))
	graph save "graph_`k'_effect.gph"  ,replace
	pval_graphs , pvals_gname(`k'_pval) pvals_std_gname(`k'_pval_t)  xtitle("`k'") ytitle("P-Values")
	//pvals_options(title("Lead Specific Significance Level (P-Values) for `k'")) 
	graph save "graph_`k'_pvals.gph",replace
/*	
	foreach  g in n_pl  pval_joint_post pval_joint_post_t avg_pre_rmspe_p avg_val_rmspe_p{
		local `g' = e(`g')
		dis ``g''
	}
	foreach m in treat_control b pvals pvals_std{
		matrix list e(`m')
		mat `m' = e(`m')
	}
*/	
}
*/
graph combine graph_BMI_effect.gph graph_waist_effect.gph graph_obesity_effect.gph graph_overweight_effect.gph graph_obesityint_effect.gph graph_centralobesity_effect.gph , row(3) title("Anthropometric Measures") 
graph export "/Volumes/alan/method paper/Data Analysis/SC BMI&waist _effect with 18.png",replace width(3000) height(3000)

graph combine graph_sbp_effect.gph graph_dbp_effect.gph graph_hypertension_effect.gph graph_awarehypertension_effect.gph graph_treathypertension_effect.gph graph_controlhypertension_effect.gph , row(3) title("hypertension") 
graph export "/Volumes/alan/method paper/Data Analysis/SC hypertension _effect with 18.png",replace width(3000) height(3000)
/*
graph combine graph_diabetes_effect.gph graph_awarediabetes_effect.gph graph_treatdiabetes_effect.gph graph_drugdiabetes_effect.gph graph_controldiabetes_effect.gph , row(3) title("diabetes") 
graph export "/Volumes/alan/method paper/Data Analysis/SC diabetes with _effect 18.png",replace width(3000) height(1200)
*/


graph combine graph_BMI_pvals.gph graph_waist_pvals.gph graph_obesity_pvals.gph graph_overweight_pvals.gph graph_obesityint_pvals.gph graph_centralobesity_pvals.gph , row(3) title("Anthropometric Measures") 
graph export "/Volumes/alan/method paper/Data Analysis/SC BMI&waist _pvals with 18.png",replace width(3000) height(3000)

graph combine graph_sbp_pvals.gph graph_dbp_pvals.gph graph_hypertension_pvals.gph graph_awarehypertension_pvals.gph graph_treathypertension_pvals.gph graph_controlhypertension_pvals.gph , row(3) title("hypertension") 
graph export "/Volumes/alan/method paper/Data Analysis/SC hypertension _pvals with 18.png",replace width(3000) height(3000)
/*
graph combine graph_diabetes_pvals.gph graph_awarediabetes_pvals.gph graph_treatdiabetes_pvals.gph graph_drugdiabetes_pvals.gph graph_controldiabetes_pvals.gph , row(3) title("diabetes") 
graph export "/Volumes/alan/method paper/Data Analysis/SC diabetes with _pvals 18.png",replace width(3000) height(1200)
*/


***************************************************************	 
********************* sdid	 ****************
***************************************************************	
***************************************************************	 
********************* sdid	 ****************
***************************************************************	 
use "/Volumes/alan/method paper/Data Analysis/final with 18.dta",clear

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
xtset dspcode year    

** 第一部分
preserve
drop if treated2014 == 1 
drop if treated2017 == 1 
 
foreach k in  hypertension awarehypertension treathypertension controlhypertension{
		sdid `k' dspcode year treated ,  vce(bootstrap) covariates(sex prop_65 log_gdp   , projected)  graph  ///
		g1_opt(ytitle("Prevelence") xtitle("year") ) ///
		g2_opt(ytitle("Prevelence") xtitle("year") title("`k'"))
		graph save "`k'_sdid_1.gph",replace
 }	
restore

** 第2部分
preserve
drop if treated2011 == 1 
drop if treated2017 == 1 
 
foreach k in  hypertension awarehypertension treathypertension controlhypertension{
		sdid `k' dspcode year treated ,  vce(bootstrap) covariates(sex prop_65 log_gdp   , projected)  graph  ///
		g1_opt(ytitle("Prevelence") xtitle("year") ) ///
		g2_opt(ytitle("Prevelence") xtitle("year") title("`k'"))
		graph save "`k'_sdid_2.gph",replace
 }	
restore

** 第3部分
preserve
drop if treated2011 == 1 
drop if treated2014 == 1 
 
foreach k in  hypertension awarehypertension treathypertension controlhypertension{
		sdid `k' dspcode year treated ,  vce(bootstrap) covariates(sex prop_65 log_gdp   , projected)  graph  ///
		g1_opt(ytitle("Prevelence") xtitle("year") ) ///
		g2_opt(ytitle("Prevelence") xtitle("year") title("`k'"))
		graph save "`k'_sdid_3.gph",replace
 }	
restore


foreach k in  hypertension awarehypertension treathypertension controlhypertension{
graph combine `k'_sdid_1.gph `k'_sdid_2.gph  `k'_sdid_3.gph  , row(2) title("`k'") 
graph export "/Volumes/alan/method paper/Data Analysis/sdid `k' with 18.png",replace width(3000) height(3000)
}
