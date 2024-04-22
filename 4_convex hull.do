use "${OUT}/final with_weightsdid_2.dta",clear
********* 各种数据的分别加总和合并，脑子实在转不动了用了这种办法
	* synthetic non
	preserve 
		foreach k in 11 12 14{
			bysort year: egen sc_`k'_drinking30_0 = sum(drinking30*sc_w`k') if treated_g == 0 
			bysort year: egen sc_`k'_sex_0 = sum(sex*sc_w`k') if treated_g == 0 
			bysort year: egen sc_`k'_prop_65_0 = sum(prop_65*sc_w`k') if treated_g == 0 
			bysort year: egen sc_`k'_gdp_pc_0 = sum(gdp_pc*sc_w`k') if treated_g == 0 
		}	
				
		foreach k in 11 12 14{
			bysort year: egen sdid_`k'_drinking30_0 = sum(drinking30*sdid_w`k') 	if treated_g == 0 
			bysort year: egen sdid_`k'_sex_0 = sum(sex*sdid_w`k') 				if treated_g == 0 
			bysort year: egen sdid_`k'_prop_65_0 = sum(prop_65*sdid_w`k') 		if treated_g == 0 
			bysort year: egen sdid_`k'_gdp_pc_0 = sum(gdp_pc*sdid_w`k') 		if treated_g == 0 
		}	
		keep sc_*_0 sdid_*_0 year 
		duplicates drop
		drop if sc_11_drinking30_0 == .
		isid year
		tempfile t1
		save `t1',replace
	restore
	
	* treated
	preserve 
		foreach k in 11 12 14{
			bysort year: egen sdid_`k'_drinking30_1 = mean(drinking30) if treated_g == 1 & treated20`k' ==1 
			bysort year: egen sdid_`k'_sex_1 = mean(sex) if treated_g == 1 & treated20`k' ==1 
			bysort year: egen sdid_`k'_prop_65_1 = mean(prop_65) if treated_g == 1 & treated20`k' ==1 
			bysort year: egen sdid_`k'_gdp_pc_1 = mean(gdp_pc ) if treated_g == 1 & treated20`k' ==1 
		}	
		keep  sdid_*_1 year 
		duplicates drop
		drop if sdid_11_drinking30_1 == . & sdid_12_drinking30_1 == . & sdid_14_drinking30_1 == .
		ren (sdid_11_drinking30_1 sdid_12_drinking30_1 sdid_14_drinking30_1) (sdid_drinking30_11 sdid_drinking30_12 sdid_drinking30_14)
		ren (sdid_11_sex_1 sdid_12_sex_1 sdid_14_sex_1) (sdid_sex_11 sdid_sex_12 sdid_sex_14)
		ren (sdid_11_prop_65_1 sdid_12_prop_65_1 sdid_14_prop_65_1) (sdid_prop_65_11 sdid_prop_65_12 sdid_prop_65_14)
		ren (sdid_11_gdp_pc_1 sdid_12_gdp_pc_1 sdid_14_gdp_pc_1) (sdid_gdp_pc_11 sdid_gdp_pc_12 sdid_gdp_pc_14)
		
		bysort year: gen order = _n
		reshape long  sdid_drinking30_ sdid_sex_ sdid_prop_65_ sdid_gdp_pc_ ,i(year order) j(work)
		drop if sdid_drinking30_ == .
		drop order 
		reshape wide sdid_drinking30_ sdid_sex_ sdid_prop_65_ sdid_gdp_pc_ ,i(year ) j(work)
		isid year
		tempfile t2
		save `t2',replace
	restore
	
	* synthetic non total
	preserve 
		bysort year: egen sc_drinking30_0 = sum(drinking30*sc_w) if treated_g == 0 
		bysort year: egen sdid_drinking30_0 = sum(drinking30*sdid_w) if treated_g == 0 
		bysort year: egen sc_sex_0 = sum(sex*sc_w) if treated_g == 0 
		bysort year: egen sdid_sex_0 = sum(sex*sdid_w) if treated_g == 0 
		bysort year: egen sc_prop_65_0 = sum(prop_65*sc_w) if treated_g == 0 
		bysort year: egen sdid_prop_65_0 = sum(prop_65*sdid_w) if treated_g == 0 
		bysort year: egen sc_gdp_pc_0 = sum(gdp_pc *sc_w) if treated_g == 0 
		bysort year: egen sdid_gdp_pc_0 = sum(gdp_pc *sdid_w) if treated_g == 0 
		keep  sc_*_0 sdid_*_0   year 
		duplicates drop
		drop if sc_drinking30_0 == .
		tempfile t3
		save `t3',replace
	restore
	
	* treated total	
	preserve 
		bysort year: egen sc_drinking30_1 = mean(drinking30) if treated_g == 1
		bysort year: egen sdid_drinking30_1 = mean(drinking30) if treated_g == 1 
		bysort year: egen sc_sex_1 = mean(sex) if treated_g == 1
		bysort year: egen sdid_sex_1 = mean(sex) if treated_g == 1 
		bysort year: egen sc_prop_65_1 = mean(prop_65) if treated_g == 1
		bysort year: egen sdid_prop_65_1 = mean(prop_65) if treated_g == 1 
		bysort year: egen sc_gdp_pc_1 = mean(gdp_pc) if treated_g == 1
		bysort year: egen sdid_gdp_pc_1 = mean(gdp_pc) if treated_g == 1 
		keep  sc_*_1 sdid_*_1   year 
		duplicates drop
		drop sc_*_1
		drop if sdid_drinking30_1 == .
		tempfile t4
		save `t4',replace
	restore	
	
********* 合并
	use `t1',clear
	merge 1:1 year using `t2'
	drop _m
	merge 1:1 year using `t3'
	drop _m
	merge 1:1 year using `t4'
	drop _m
	
********* 计算gap
		foreach k in 11 12 14{
			gen gap_sc_`k'_drinking = sdid_drinking30_`k' -  sc_`k'_drinking30_0
			gen gap_sc_`k'_sex = sdid_sex_`k' -  sc_`k'_sex_0
			gen gap_sc_`k'_prop_65 = sdid_prop_65_`k' -  sc_`k'_prop_65_0
			gen gap_sc_`k'_gdp_pc = sdid_gdp_pc_`k' -  sc_`k'_gdp_pc_0
		}	
		foreach k in 11 12 14{
			gen gap_sdid_`k'_drinking = sdid_drinking30_`k' -  sdid_`k'_drinking30_0
			gen gap_sdid_`k'_sex = sdid_sex_`k' -  sdid_`k'_sex_0
			gen gap_sdid_`k'_prop_65 = sdid_prop_65_`k' -  sdid_`k'_prop_65_0
			gen gap_sdid_`k'_gdp_pc = sdid_gdp_pc_`k' -  sdid_`k'_gdp_pc_0
		}	
		gen gap_sc_drinking = sdid_drinking30_1 -  sc_drinking30_0
		gen gap_sdid_drinking = sdid_drinking30_1 -  sdid_drinking30_0	
		gen gap_sc_sex = sdid_sex_1 -  sc_sex_0
		gen gap_sdid_sex = sdid_sex_1 -  sdid_sex_0	
		gen gap_sc_prop_65  = sdid_prop_65_1 -  sc_prop_65_0
		gen gap_sdid_prop_65  = sdid_prop_65_1 -  sdid_prop_65_0	
		gen gap_sc_gdp_pc = sdid_gdp_pc_1 -  sc_gdp_pc_0
		gen gap_sdid_gdp_pc = sdid_gdp_pc_1 -  sdid_gdp_pc_0	
save "${OUT}/convex_hull_assumption_2.dta",replace

use "${OUT}/convex_hull_assumption_2.dta",clear
	label variable gap_sc_11_drinking   "Past-month Drinking Rate"
	label variable gap_sc_11_sex  "Sex ratio (%)"
	label variable gap_sc_11_prop_65  "Propotion of Older Adults (%)"
	label variable gap_sc_11_gdp_pc "GDP (CNY)"
	label variable gap_sdid_11_drinking   "Past-month Drinking Rate (%)"
	label variable gap_sdid_11_sex  "Sex ratio (%)"
	label variable gap_sdid_11_prop_65  "Propotion of Older Adults (%)"
	label variable gap_sdid_11_gdp_pc "GDP (CNY)"
	
	label variable gap_sc_12_drinking   "Past-month Drinking Rate (%)"
	label variable gap_sc_12_sex  "Sex ratio (%)"
	label variable gap_sc_12_prop_65  "Propotion of Older Adults (%)"
	label variable gap_sc_12_gdp_pc "GDP (CNY)"
	label variable gap_sdid_12_drinking   "Past-month Drinking Rate (%)"
	label variable gap_sdid_12_sex  "Sex ratio (%)"
	label variable gap_sdid_12_prop_65  "Propotion of Older Adults (%)"
	label variable gap_sdid_12_gdp_pc "GDP (CNY)"
	
	label variable gap_sc_14_drinking   "Past-month Drinking Rate (%)"
	label variable gap_sc_14_sex  "Sex ratio (%)"
	label variable gap_sc_14_prop_65  "Propotion of Older Adults (%)"
	label variable gap_sc_14_gdp_pc "GDP (CNY)"
	label variable gap_sdid_14_drinking   "Past-month Drinking Rate (%)"
	label variable gap_sdid_14_sex  "Sex ratio (%)"
	label variable gap_sdid_14_prop_65  "Propotion of Older Adults (%)"
	label variable gap_sdid_14_gdp_pc "GDP (CNY)"

	label variable gap_sc_drinking   "Past-month Drinking Rate (%)"
	label variable gap_sc_sex   "Sex ratio (%)"
	label variable gap_sc_prop_65  "Propotion of Older Adults (%)"
	label variable gap_sc_gdp_pc   "GDP (CNY)"
	
	foreach k in gap_sc_11_prop_65  gap_sc_12_prop_65 gap_sc_14_prop_65 gap_sc_prop_65{
		replace `k' = `k' *100
		
	}
	
	graph twoway  (connected gap_sc_11_drinking year ,mcolor(red) yaxis(1)) (connected gap_sc_11_sex year,mcolor(red) yaxis(1)) (connected gap_sc_11_prop_65 year,mcolor(red) yaxis(1)) (connected gap_sc_11_gdp_pc year, mcolor(red) lp(dash) yaxis(2)), title("Panel A-1: The First Batch (2011)") ytitle("Difference in Predictors (%)", axis(1)) ytitle("", axis(2))   xtitle(Year) xline(2011) yline(0) ylabel(-15(5)10,axis(1) nogrid) ylabel(-105000(50000)70000,nolabels axis(2)) legend(ring(0) pos(6)) legend(off)  xlabel(2007 2010 2013 2015 2018 ,nogrid) ylabel(,nogrid)
	graph save "${OUT}/Graph_drinking30_SC_11.gph", replace	
	
	graph twoway  (connected gap_sc_12_drinking year,mcolor(red) yaxis(1)) (connected gap_sc_12_sex year,mcolor(red) yaxis(1)) (connected gap_sc_12_prop_65 year,mcolor(red) yaxis(1)) (connected gap_sc_12_gdp_pc year, mcolor(red) lp(dash) yaxis(2)), title("Panel A-2: The Second Batch (2012)")  xtitle(Year)  xline(2012) ytitle("", axis(2)) yline(0) ylabel(-15(5)10,axis(1) nogrid nolabels )  xlabel(2007 2010 2013 2015 2018 ,nogrid)  ylabel(-105000(50000)70000,nolabels axis(2)) legend(off)   ylabel(,nogrid)
	graph save "${OUT}/Graph_drinking30_SC_12.gph", replace	
	
	graph twoway  (connected gap_sc_14_drinking year,mcolor(red) yaxis(1)) (connected gap_sc_14_sex year,mcolor(red) yaxis(1)) (connected gap_sc_14_prop_65 year,mcolor(red) yaxis(1)) (connected gap_sc_14_gdp_pc year, mcolor(red) lp(dash) yaxis(2)), title("Panel A-3: The Third Batch (2014)")  xtitle(Year) ytitle("Difference in GDP (CNY)", axis(2)) xline(2014)  xlabel(2007 2010 2013 2015 2018 ,nogrid)  yline(0) ylabel(-15(5)10,axis(1) nogrid nolabels )  ylabel(-105000(50000)70000,axis(2)) legend(off) 
	graph save "${OUT}/Graph_drinking30_SC_14.gph", replace	

	graph combine "${OUT}/Graph_drinking30_SC_11.gph" "${OUT}/Graph_drinking30_SC_12.gph" "${OUT}/Graph_drinking30_SC_14.gph", rows(1)  cols(3) iscale(.7273) xsize(10)  graphregion(margin(zero))
	graph save "${OUT}/Graph_drinking30_SC_panela.png", replace	
xx
	graph twoway  (connected gap_sc_drinking year,mcolor(red) yaxis(1)) (connected gap_sc_sex year,mcolor(red) yaxis(1)) (connected gap_sc_prop_65 year,mcolor(red) yaxis(1)) (connected gap_sc_gdp_pc year, mcolor(red) lp(dash) yaxis(2)), title("Panel B: Weighted Results of Three Batches") ytitle("Difference in Predictors (%)", axis(1)) ytitle("Difference in GDP (CNY)", axis(2) ) xtitle(Year)  xline(2011) xline(2012) xline(2014)  ylabel(-15(5)10,axis(1) nogrid) ylabel(-105000(50000)70000,axis(2))  xlabel(2007 2010 2013 2015 2018 ,nogrid) legend(si(small) ring(0) pos(5) ) yline(0)    
	graph save "${OUT}/Graph_drinking30_SC.gph", replace	
	graph save "${OUT}/Graph_drinking30_SC.gph" "${OUT}/Graph_drinking30_SC.png", replace	
		
	graph combine "${OUT}/Graph_drinking30_SC_panela.gph" "${OUT}/Graph_drinking30_SC.gph",rows(2) iscale(.7273) xsize(10) ysize(12) graphregion(margin(zero))
	
	graph save "${OUT}/Graph_drinking30_convexhull.gph", replace	
	xx
	
	sum sc_11_drinking30_0 sc_12_drinking30_0 sc_11_sex_0 sc_12_sex_0  sc_11_prop_65_0 sc_12_prop_65_0  sc_11_gdp_pc_0 sc_12_gdp_pc_0  if year <=2010
	sum sdid_drinking30_11 sdid_drinking30_12 sdid_sex_11 sdid_sex_12 sdid_prop_65_11 sdid_prop_65_12  sdid_gdp_pc_11 sdid_gdp_pc_12 if year <=2010
	
	sum sc_14_drinking30_0 sc_drinking30_0  sc_14_sex_0 sc_sex_0 sc_14_prop_65_0 sc_prop_65_0 sc_14_gdp_pc_0 sc_gdp_pc_0 if year <=2013
	sum sdid_drinking30_14 sdid_drinking30_1 sdid_sex_14 sdid_sex_1 sdid_prop_65_14 sdid_prop_65_1 sdid_gdp_pc_14 sdid_gdp_pc_1 if year <=2013
	

	sum gap_sc_11_drinking gap_sc_11_sex gap_sc_11_prop_65 gap_sc_11_gdp_pc gap_sc_12_drinking gap_sc_12_sex gap_sc_12_prop_65 gap_sc_12_gdp_pc gap_sc_14_drinking gap_sc_14_sex gap_sc_14_prop_65 gap_sc_14_gdp_pc
	
	
	
	
	imporved compared with the original, but stull 
	difference between (%)
	
	Panel A-1 -2 -3

	
	
	xx
	//title("Difference in past-month drinking rate Between ")
	graph export "${OUT}/Graph_drinking30_SC——total.png", replace	
	 gap_sc_12 gap_sc_14
	cls
	ttest 	gap_sc_11 =0 if year ==2007  
	ttest 	gap_sc_11 =0 if year ==2010
	
	ttest 	gap_sc_12 =0 if year ==2007  
	ttest 	gap_sc_12 =0 if year ==2010

	ttest 	gap_sc_14 =0 if year ==2007  
	ttest 	gap_sc_14 =0 if year ==2010
	ttest 	gap_sc_14 =0 if year ==2013
	
	
	
	
	ttest 	gap_sc_14 =0 if year <=2010 
	ttest 	gap_sc_11 =0 if year <=2013

