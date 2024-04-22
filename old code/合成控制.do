***************************************************************	 
********************* 合成控制法	synth ****************
***************************************************************	 
use "/Volumes/alan/method paper/Data Analysis/final with 18 random select",clear
** 第一部分--综合
preserve
	//drop if dspcode == 230826  //2011
	drop if dspcode == 420102  //2012
	drop if dspcode == 341823  //2014
	drop if dspcode == 330283   //2017
	ren (treated treated_g) (post treat)

	xtset dspcode year    
	tab year,gen(timeto)

	drop timeto2 
	//set trace on

	destring timeto*  ,replace

cls
foreach k in drinking30  drinking12 {  //
	synth `k' sex prop_60 log_gdp  ,  trunit(230826)trperiod(2013) xperiod(2007 2010)  /// 
	figure nested allopt keep(1_sc_`k'_r1) replace
}
restore
/*
** 第一部分--短期
preserve
	//drop if dspcode == 230826  //2011
	drop if dspcode == 420102  //2012
	drop if dspcode == 341823  //2014
	drop if dspcode == 330283   //2017
keep if year == 2007|year == 2010|year == 2013
	ren (treated treated_g) (post treat)

	xtset dspcode year    
	tab year,gen(timeto)

	drop timeto2 
	//set trace on

	destring timeto*  ,replace

cls
foreach k in drinking30  drinking12 {  
	synth2 `k' sex prop_60 log_gdp  ,  trunit(230826)trperiod(2013) preperiod(2007 2010) postperiod(2013 ) ///
    figure nested allopt margin(0.05) sigf(3) ///
	placebo(unit cutoff(2))  loo  ///
	frame(`k'_synth_r1)	 // timeto1 timeto3 timeto4 timeto5
	foreach g in bias eff eff_loo eff_pboUnit pred pred_loo pvalLeft_pboUnit pvalRight_pboUnit pvalTwo_pboUnit  ratio_pboUnit weight_unit weight_vars{
		graph save "`g'" "/Volumes/alan/method paper/Data Analysis/Graph_sdid_`k'_`g'_short_round1.gph",  replace	
	}
	foreach m in V_wt  U_wt bal mspe pval{
		matrix list e(`m')
		mat `m'_`k'_short_r1 = e(`m')
	}
}
restore

** 第一部分--mid
preserve
	//drop if dspcode == 230826  //2011
	drop if dspcode == 420102  //2012
	drop if dspcode == 341823  //2014
	drop if dspcode == 330283   //2017
keep if year == 2007|year == 2010|year == 2015
	ren (treated treated_g) (post treat)

	xtset dspcode year    
	tab year,gen(timeto)

	drop timeto2 
	//set trace on

	destring timeto*  ,replace

cls
foreach k in drinking30  drinking12 {  
	synth2 `k' sex prop_60 log_gdp  ,  trunit(230826)trperiod(2013) preperiod(2007 2010) postperiod( 2015 ) ///
    figure nested allopt margin(0.05) sigf(3) ///
	placebo(unit cutoff(2))  loo  ///
	frame(`k'_synth_r1)	 // timeto1 timeto3 timeto4 timeto5
	foreach g in bias eff eff_loo eff_pboUnit pred pred_loo pvalLeft_pboUnit pvalRight_pboUnit pvalTwo_pboUnit  ratio_pboUnit weight_unit weight_vars{
		graph save "`g'" "/Volumes/alan/method paper/Data Analysis/Graph_sdid_`k'_`g'_mid_round1.gph",  replace	
	}
	foreach m in V_wt  U_wt bal mspe pval{
		matrix list e(`m')
		mat `m'_`k'_mid_r1 = e(`m')
	}
}
restore

** 第一部分--long
preserve
	//drop if dspcode == 230826  //2011
	drop if dspcode == 420102  //2012
	drop if dspcode == 341823  //2014
	drop if dspcode == 330283   //2017
keep if year == 2007|year == 2010|year == 2018
	ren (treated treated_g) (post treat)

	xtset dspcode year    
	tab year,gen(timeto)

	drop timeto2 
	//set trace on

	destring timeto*  ,replace

cls
foreach k in drinking30  drinking12 {  
	synth2 `k' sex prop_60 log_gdp  ,  trunit(230826)trperiod(2013) preperiod(2007 2010) postperiod(2018) ///
    figure nested allopt margin(0.05) sigf(3) ///
	placebo(unit cutoff(2))  loo  ///
	frame(`k'_synth_r1)	 // timeto1 timeto3 timeto4 timeto5
	foreach g in bias eff eff_loo eff_pboUnit pred pred_loo pvalLeft_pboUnit pvalRight_pboUnit pvalTwo_pboUnit  ratio_pboUnit weight_unit weight_vars{
		graph save "`g'" "/Volumes/alan/method paper/Data Analysis/Graph_sdid_`k'_`g'_long_round1.gph",  replace	
	}
	foreach m in V_wt  U_wt bal mspe pval{
		matrix list e(`m')
		mat `m'_`k'_long_r1 = e(`m')
	}
}
restore
*/
** 第二部分--综合
preserve
	drop if dspcode == 230826  //2011
	//drop if dspcode == 420102  //2012
	drop if dspcode == 341823  //2014
	drop if dspcode == 330283   //2017

	ren (treated treated_g) (post treat)

	xtset dspcode year    
	tab year,gen(timeto)

	drop timeto2 
	//set trace on

	destring timeto*  ,replace

foreach k in drinking30  drinking12 {  //
	synth `k' sex prop_60 log_gdp  ,  trunit(420102)trperiod(2013) xperiod(2007 2010)  /// 
	figure nested allopt keep(1_sc_`k'_r2) replace
}
restore
/*
** 第二部分--short
preserve
	drop if dspcode == 230826  //2011
	//drop if dspcode == 420102  //2012
	drop if dspcode == 341823  //2014
	drop if dspcode == 330283   //2017
keep if year == 2007|year == 2010|year == 2013

	ren (treated treated_g) (post treat)

	xtset dspcode year    
	tab year,gen(timeto)

	drop timeto2 
	//set trace on

	destring timeto*  ,replace

foreach k in drinking30  drinking12 {  
	synth2 `k' sex prop_60 log_gdp   ,  trunit(420102)trperiod(2013) preperiod(2007 2010) postperiod(2013) ///
    figure nested allopt margin(0.05) sigf(3) ///
	placebo(unit cutoff(2))  loo  /// 
	frame(`k'_synth_r2)	 // timeto1 timeto3 timeto4 timeto5
	foreach g in bias eff eff_loo eff_pboUnit pred pred_loo pvalLeft_pboUnit pvalRight_pboUnit pvalTwo_pboUnit  ratio_pboUnit weight_unit weight_vars{
		graph save "`g'"  "/Volumes/alan/method paper/Data Analysis/Graph_sdid_`k'_`g'_short_round2.gph",  replace	
	}
	foreach m in V_wt  U_wt bal mspe pval{
		matrix list e(`m')
		mat `m'_`k'_short_r2 = e(`m')
	}
	
}
restore

** 第二部分--mid
preserve
	drop if dspcode == 230826  //2011
	//drop if dspcode == 420102  //2012
	drop if dspcode == 341823  //2014
	drop if dspcode == 330283   //2017
keep if year == 2007|year == 2010|year == 2015

	ren (treated treated_g) (post treat)

	xtset dspcode year    
	tab year,gen(timeto)

	drop timeto2 
	//set trace on

	destring timeto*  ,replace

foreach k in drinking30  drinking12 {  
	synth2 `k' sex prop_60 log_gdp   ,  trunit(420102)trperiod(2013) preperiod(2007 2010) postperiod(2015) ///
    figure nested allopt margin(0.05) sigf(3) ///
	placebo(unit cutoff(2))  loo  /// 
	frame(`k'_synth_r2)	 // timeto1 timeto3 timeto4 timeto5
	foreach g in bias eff eff_loo eff_pboUnit pred pred_loo pvalLeft_pboUnit pvalRight_pboUnit pvalTwo_pboUnit  ratio_pboUnit weight_unit weight_vars{
		graph save "`g'"  "/Volumes/alan/method paper/Data Analysis/Graph_sdid_`k'_`g'_mid_round2.gph",  replace	
	}
	foreach m in V_wt  U_wt bal mspe pval{
		matrix list e(`m')
		mat `m'_`k'_mid_r2 = e(`m')
	}
	
}
restore

** 第二部分--long
preserve
	drop if dspcode == 230826  //2011
	//drop if dspcode == 420102  //2012
	drop if dspcode == 341823  //2014
	drop if dspcode == 330283   //2017
keep if year == 2007|year == 2010|year == 2018

	ren (treated treated_g) (post treat)

	xtset dspcode year    
	tab year,gen(timeto)

	drop timeto2 
	//set trace on

	destring timeto*  ,replace

foreach k in drinking30  drinking12 {  
	synth2 `k' sex prop_60 log_gdp   ,  trunit(420102)trperiod(2013) preperiod(2007 2010) postperiod( 2018) ///
    figure nested allopt margin(0.05) sigf(3) ///
	placebo(unit cutoff(2))  loo  /// 
	frame(`k'_synth_r2)	 // timeto1 timeto3 timeto4 timeto5
	foreach g in bias eff eff_loo eff_pboUnit pred pred_loo pvalLeft_pboUnit pvalRight_pboUnit pvalTwo_pboUnit  ratio_pboUnit weight_unit weight_vars{
		graph save "`g'"  "/Volumes/alan/method paper/Data Analysis/Graph_sdid_`k'_`g'_long_round2.gph",  replace	
	}
	foreach m in V_wt  U_wt bal mspe pval{
		matrix list e(`m')
		mat `m'_`k'_long_r2 = e(`m')
	}
	
}
restore

*/
** 第三部分--综合
preserve
	drop if dspcode == 230826  //2011
	drop if dspcode == 420102  //2012
	//drop if dspcode == 341823  //2014
	drop if dspcode == 330283   //2017

	xtset dspcode year   
	tab year,gen(timeto)

	drop timeto2 
	//set trace on

	destring timeto*  ,replace

foreach k in drinking30  drinking12 {  //
	synth `k' sex prop_60 log_gdp  ,  trunit(341823)trperiod(2015) xperiod(2007 2010 2013)  /// 
	figure nested allopt keep(1_sc_`k'_r3) replace
}
restore
/*
** 第三部分--short
preserve
	drop if dspcode == 230826  //2011
	drop if dspcode == 420102  //2012
	//drop if dspcode == 341823  //2014
	drop if dspcode == 330283   //2017
keep if year == 2007|year == 2010|year == 2013|year == 2015

	xtset dspcode year   
	tab year,gen(timeto)

	drop timeto2 
	//set trace on

	destring timeto*  ,replace

foreach k in drinking30  drinking12 {  
	synth2 `k' sex prop_60 log_gdp ,  trunit(341823)trperiod(2015) preperiod(2007 2010 2013 ) postperiod(2015) ///
    figure nested allopt margin(0.05) sigf(3) ///
	placebo(unit cutoff(2))  loo  /// 
	frame(`k'_synth_r3)	 // timeto1 timeto3 timeto4 timeto5
	foreach g in bias eff eff_loo eff_pboUnit pred pred_loo pvalLeft_pboUnit pvalRight_pboUnit pvalTwo_pboUnit  ratio_pboUnit weight_unit weight_vars{
		graph save "`g'"  "/Volumes/alan/method paper/Data Analysis/Graph_sdid_`k'_`g'_short_round3.gph",  replace	
	}
	foreach m in V_wt  U_wt bal mspe pval{
		matrix list e(`m')
		mat `m'_`k'_short_r3 = e(`m')
	}	
}
restore

** 第三部分--mid
preserve
	drop if dspcode == 230826  //2011
	drop if dspcode == 420102  //2012
	//drop if dspcode == 341823  //2014
	drop if dspcode == 330283   //2017
keep if year == 2007|year == 2010|year == 2013|year == 2018

	xtset dspcode year   
	tab year,gen(timeto)

	drop timeto2 
	//set trace on

	destring timeto*  ,replace

foreach k in drinking30  drinking12 {  
	synth2 `k' sex prop_60 log_gdp ,  trunit(341823)trperiod(2015) preperiod(2007 2010 2013) postperiod(2018) ///
    figure nested allopt margin(0.05) sigf(3) ///
	placebo(unit cutoff(2))  loo  /// 
	frame(`k'_synth_r3)	 // timeto1 timeto3 timeto4 timeto5
	foreach g in bias eff eff_loo eff_pboUnit pred pred_loo pvalLeft_pboUnit pvalRight_pboUnit pvalTwo_pboUnit  ratio_pboUnit weight_unit weight_vars{
		graph save "`g'"  "/Volumes/alan/method paper/Data Analysis/Graph_sdid_`k'_`g'_mid_round3.gph",  replace	
	}
	foreach m in V_wt  U_wt bal mspe pval{
		matrix list e(`m')
		mat `m'_`k'_mid_r3 = e(`m')
	}	
}
restore
*/
** 第4部分
preserve
	drop if dspcode == 230826  //2011
	drop if dspcode == 420102  //2012
	drop if dspcode == 341823  //2014
	//drop if dspcode == 330283   //2017

	xtset dspcode year   
	tab year,gen(timeto)

	drop timeto2 
	//set trace on

	destring timeto*  ,replace

foreach k in drinking30  drinking12 {  //
	synth `k' sex prop_60 log_gdp  ,  trunit(330283)trperiod(2018) xperiod(2007 2010 2013 2015)  /// 
	figure nested allopt keep(1_sc_`k'_r4) replace
}
restore
/*
** 第4部分
preserve
	drop if dspcode == 230826  //2011
	drop if dspcode == 420102  //2012
	drop if dspcode == 341823  //2014
	//drop if dspcode == 330283   //2017

	xtset dspcode year   
	tab year,gen(timeto)

	drop timeto2 
	//set trace on

	destring timeto*  ,replace

foreach k in drinking30  drinking12 {  
	synth2 `k' sex prop_60 log_gdp ,  trunit(341823)trperiod(2018) preperiod(2007 2010 2013 2015) postperiod(2018) ///
    figure nested allopt margin(0.05) sigf(3) ///
	placebo(unit cutoff(2))  loo  /// 
	frame(`k'_synth_r3)	 // timeto1 timeto3 timeto4 timeto5
	foreach g in bias eff eff_loo eff_pboUnit pred pred_loo pvalLeft_pboUnit pvalRight_pboUnit pvalTwo_pboUnit  ratio_pboUnit weight_unit weight_vars{
		graph save "`g'"  "/Volumes/alan/method paper/Data Analysis/Graph_sdid_`k'_`g'_short_round3.gph",  replace	
	}
	foreach m in V_wt  U_wt bal mspe pval{
		matrix list e(`m')
		mat `m'_`k'_short_r3 = e(`m')
	}	
}
restore
*/
xx
**合成主结果图像#
graph combine  drinking30_effect_1.gph  graph_drinking30_pvals_round1.gph graph_drinking30_pvals_t_round1.gph  ///
drinking30_effect_2.gph  graph_drinking30_pvals_round2.gph graph_drinking30_pvals_t_round2.gph ///
drinking30_effect_3.gph  graph_drinking30_pvals_round3.gph graph_drinking30_pvals_t_round3.gph  , row(3) title("Prevalence of Drinking in the past 30 days") 
graph export "/Volumes/alan/method paper/Data Analysis/SC drinking30.png",replace width(3000) height(2000)

graph combine  drinking12_effect_1.gph  graph_drinking12_pvals_round1.gph graph_drinking12_pvals_t_round1.gph  ///
drinking12_effect_2.gph  graph_drinking12_pvals_round2.gph graph_drinking12_pvals_t_round2.gph ///
drinking12_effect_3.gph  graph_drinking12_pvals_round3.gph graph_drinking12_pvals_t_round3.gph  , row(3) title("Prevalence of Drinking in the past 12 months") 
graph export "/Volumes/alan/method paper/Data Analysis/SC drinking12.png",replace width(3000) height(2000)

preserve
	drop if treated_g == 1 
	bysort year: sum BMI waist obesity overweight
restore

foreach k in drinking30 drinking12  {  
use `k'_synth_r1,clear
	gen effect_`k'= _Y_treated - _Y_synthetic //定义处理效应为变量effect，其中"_Y_treated"与"_Y_synthetic"分别表示处理地区与合成控制的结果变量
	ren (_Y_treated  _Y_synthetic) (`k'_Y_treated `k'_Y_synthetic)
	label variable _time "year"
	label variable effect_`k' "gap in implementation in `k'"
	line effect_`k' _time, xline(2011,lp(dash)) yline(0,lp(dash))
}


foreach k in drinking30 drinking12{
	twoway function y = 24.6,range(2011 2012) recast(area) color(gs12) base(22.95) yaxis(1) || ///
	(line `k'_1 year) (line `k'_synth_1 year) (line `k'not year) , xlabel(2005(2)2020)  xtitle("year") ytitle("Prevalence of `k'") ///
	legend(ring(0) pos(5) order(1 "First & Second Batch" 2 "Treated Counties" 3 "Synthetic Counties" 4 "Not-treated Counties")) title("First & Second Batch")

	graph save "/Volumes/alan/method paper/Data Analysis/`k'_1.gph", replace
	
	twoway	(line `k'_2 year) (line `k'_synth_2 year) (line `k'not year) ,xlabel(2005(2)2020)   xtitle("year") xline(2014) ///
	legend(ring(0) pos(5) order( 1 "Treated Counties" 2 "Synthetic Counties" 3 "Not-treated Counties")) title("Third Batch")
	graph save "/Volumes/alan/method paper/Data Analysis/`k'_2.gph", replace
	
	twoway 	(line `k'_3 year) (line `k'_synth_3 year) (line `k'not year) ,xlabel(2005(2)2020)  xline(2017)  xtitle("year") ytitle("Mean of `k'") ///
	legend(ring(0) pos(5) order( 1 "Treated Counties" 2 "Synthetic Counties" 3 "Not-treated Counties")) title("Forth Batch")
	graph save "/Volumes/alan/method paper/Data Analysis/`k'_3.gph", replace	
	
	graph combine  `k'_1.gph `k'_2.gph `k'_3.gph, row(2) title("`k'")
	graph export "/Volumes/alan/method paper/Data Analysis/SC 比较 of `k'.png",replace
}

**#
import excel "/Users/mac/Desktop/SC result.xlsx", sheet("Sheet7") firstrow clear

foreach k in drinking30 drinking12{
	twoway (line `k'_1 windows,yaxis(1)  ytitle("`k'")) (scatter `k'_P_value_1 windows,yaxis(2)  ytitle("P Value")) (scatter `k'_P_standard_1 windows) , xtitle("Lead") ytitle("`k'") xlabel(1(1)3) 	///
	legend(off) title("First & Second Batch")  ylabel(#10, axis(1))  ylabel(0(0.2)1, axis(2))  ytitle("`k'", axis(1))  ytitle("P Value", axis(2))
	graph save "/Volumes/alan/method paper/Data Analysis/`k'_1.gph", replace
	
	twoway (line `k'_2 windows,yaxis(1) ytitle("`k'")) (scatter `k'_P_value_2 windows,yaxis(2) ytitle("P Value") ) (scatter `k'_P_standard_2 windows), xtitle("Lead") ytitle("`k'")  xlabel(1(1)2) ///
	legend(off) title("Third Batch")  ylabel(#10, axis(1))  ylabel(0(0.2)1, axis(2))  ytitle("`k'", axis(1))  ytitle("P Value", axis(2))
	graph save "/Volumes/alan/method paper/Data Analysis/`k'_2.gph", replace
	
	twoway (scatter `k'_3 windows,yaxis(1) ytitle("`k'") ) (scatter `k'_P_value_3 windows,yaxis(2) ytitle("P Value")) (scatter `k'_P_standard_3 windows), xtitle("Lead") ytitle("`k'") xlabel(1(1)1) ///
	legend( order( 1 "Coeffcient" 2 "P-Value" 3 "Standard P-Value")) title("Forth Batch")  ylabel(#10, axis(1))  ylabel(0(0.2)1, axis(2))  ytitle("`k'", axis(1))  ytitle("P Value", axis(2))
	graph save "/Volumes/alan/method paper/Data Analysis/`k'_3.gph", replace	
	
	graph combine  `k'_1.gph `k'_2.gph `k'_3.gph, row(1) title("`k'")
	graph export "/Volumes/alan/method paper/Data Analysis/SC 系数 of `k'.png",replace width(5000) height(800)
}
//ring(0) pos(5) 

//legend(order(1 "First & Second Batch" 2 "Treated Counties" 3 "Synthetic Counties" 4 "Not-treated Counties"))

**#

/*
e(n_pl)                  number of placebo averages used for comparison
e(pval_joint_post)       proportion of placebos that have a posttreatment RMSPE at least as large as the average for the treated units

e(avg_pre_rmspe_p)       proportion of placebos that have a pretreatment RMSPE at least as large as the average of the treated units; the farther this measure is from 0 toward 1, the better the relative fit of the treated units

e(treat_control)         average treatment outcome (centered around treatment) and the average of the outcome of those units' synthetic controls for the pretreatment and posttreatment periods
e(b)                     a vector with the per-period effects (unit's actual outcome minus the outcome of its synthetic control) for posttreatment periods
e(pvals)                 a vector of the proportions of placebo effects that are at least as large as the main effect for each posttreatment period
e(pvals_std)             a vector of the proportions of placebo standardized effects that are at least as large as the main standardized effect for each posttreatment period
 


*/
