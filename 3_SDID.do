cls
use "${OUT}/final with 18 random select untreated_clear11_2.dta",clear
	sdid drinking30  id year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp  , projected) method(did) ///
	graph g1on  ///
	g1_opt(ytitle("Differences") xtitle("Counties") title("Difference-in-Differences") legend(ring(0) pos(5)))  ///
	g2_opt(ytitle("Past-Month Drinking Rate(%)") xtitle("Year") title("Difference-in-Differences") ylabel(20(10)50) xlabel(2005(2)2020) title("Difference-in-Differences"))
	
	graph save "g2_2013" "${OUT}/drinking30_did—ATE—11.gph",replace
	graph save "g1_2013" "${OUT}/drinking30_did—weight—11.gph",replace
	outreg2 using "${OUT}/Table_main.xls",replace excel stats(coef pval) dec(3) alpha(0.01,0.05,0.1) symbol(***,**,*)   	

	sdid drinking30  id year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp  , projected) method(sc) ///
	graph g1on  ///
	g1_opt(ytitle("Differences") xtitle("Counties") title("Synthetic Control") legend(ring(0) pos(5)))  ///
	g2_opt(ytitle("Past-Month Drinking Rate(%)") xtitle("Year") title("Synthetic Control") ylabel(20(10)50) xlabel(2005(2)2020) title("Synthetic Control") )
	graph save "g2_2013" "${OUT}/drinking30_sc—ATE—11.gph",replace
	graph save "g1_2013" "${OUT}/drinking30_sc—weight—11.gph",replace
	
	outreg2 using "${OUT}/Table_main.xls",append excel stats(coef pval) dec(3) alpha(0.01,0.05,0.1) symbol(***,**,*)   

	foreach m in tau omega lambda adoption beta  {
		matrix list e(`m')
		mat `m' = e(`m')
	}	


	sdid drinking30  id year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp  , projected) method(sdid) 	///
	graph g1on  ///
	g1_opt(ytitle("Differences") xtitle("Counties") title("SDID") legend(ring(0) pos(5)))  ///
	g2_opt(ytitle("Past-Month Drinking Rate(%)") xtitle("Year") title("SDID") ylabel(20(10)50) xlabel(2005(2)2020) title("SDID") )
	graph save "g2_2013" "${OUT}/drinking30_sdid—ATE—11.gph",replace
	graph save "g1_2013" "${OUT}/drinking30_sdid—weight—11.gph",replace
	
	outreg2 using "${OUT}/Table_main.xls",append excel stats(coef pval) dec(3) alpha(0.01,0.05,0.1) symbol(***,**,*)   


	foreach m in tau omega lambda adoption beta  {
		matrix list e(`m')
		mat `m' = e(`m')
	}	

use "${OUT}/final with 18 random select untreated_clear12_2.dta",clear
cls
	sdid drinking30  id year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp  , projected) method(did) 	///
	graph g1on  ///
	g1_opt(ytitle("Differences") xtitle("Counties") title("Difference-in-Differences") legend(ring(0) pos(5)))  ///
	g2_opt(ytitle("Past-Month Drinking Rate(%)") xtitle("Year") title("Difference-in-Differences") xlabel(2005(2)2020) ylabel(20(10)50) title("Difference-in-Differences") )
	graph save "g2_2013" "${OUT}/drinking30_did—ATE—12.gph",replace
	graph save "g1_2013" "${OUT}/drinking30_did—weight—12.gph",replace
	
	outreg2 using "${OUT}/Table_main.xls",append excel stats(coef pval) dec(3) alpha(0.01,0.05,0.1) symbol(***,**,*)   

	
	sdid drinking30  id year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp  , projected) method(sc) 	///
	graph g1on  ///
	g1_opt(ytitle("Differences") xtitle("Counties") title("Synthetic Control") legend(ring(0) pos(5)))  ///
	g2_opt(ytitle("Past-Month Drinking Rate(%)") xtitle("Year") title("Synthetic Control") ylabel(20(10)50) xlabel(2005(2)2020) title("Synthetic Control") )
	graph save "g2_2013" "${OUT}/drinking30_sc—ATE—12.gph",replace
	graph save "g1_2013" "${OUT}/drinking30_sc—weight—12.gph",replace
	
	outreg2 using "${OUT}/Table_main.xls",append excel stats(coef pval) dec(3) alpha(0.01,0.05,0.1) symbol(***,**,*)   

	foreach m in tau omega adoption beta   {
		matrix list e(`m')
		mat `m' = e(`m')
	}


	sdid drinking30  id year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp  , projected) method(sdid) 	///
	graph g1on  ///
	g1_opt(ytitle("Differences") xtitle("Counties") title("SDID") legend(ring(0) pos(5)))  ///
	g2_opt(ytitle("Past-Month Drinking Rate(%)") xtitle("Year") title("SDID") ylabel(20(10)50) xlabel(2005(2)2020) title("SDID") )
	graph save "g2_2013" "${OUT}/drinking30_sdid—ATE—12.gph",replace
	graph save "g1_2013" "${OUT}/drinking30_sdid—weight—12.gph",replace
	outreg2 using "${OUT}/Table_main.xls",append excel stats(coef pval) dec(3) alpha(0.01,0.05,0.1) symbol(***,**,*)   


	foreach m in tau omega adoption beta   {
		matrix list e(`m')
		mat `m' = e(`m')
	}	
	
	
use "${OUT}/final with 18 random select untreated_clear14_2.dta",clear
cls
	sdid drinking30  id year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp  , projected) method(did) 	///
	graph g1on  ///
	g1_opt(ytitle("Differences") xtitle("Counties") title("Difference-in-Difference") legend(ring(0) pos(5)))  ///
	g2_opt(ytitle("Past-Month Drinking Rate(%)") xtitle("Year") title("Difference-in-Differences") ylabel(20(10)50) xlabel(2005(2)2020) title("Difference-in-Differences") )
	graph save "g2_2015" "${OUT}/drinking30_did—ATE—14.gph",replace
	graph save "g1_2015" "${OUT}/drinking30_did—weight—14.gph",replace
	
	outreg2 using "${OUT}/Table_main.xls",append excel stats(coef pval) dec(3) alpha(0.01,0.05,0.1) symbol(***,**,*)   

	sdid drinking30  id year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp  , projected) method(sc) 	///
	graph g1on  ///
	g1_opt(ytitle("Differences") xtitle("Counties") title("Synthetic Control") legend(ring(0) pos(5)))  ///
	g2_opt(ytitle("Past-Month Drinking Rate(%)") xtitle("Year") title("Synthetic Control") ylabel(20(10)50) xlabel(2005(2)2020) title("Synthetic Control") )
	graph save "g2_2015" "${OUT}/drinking30_sc—ATE—14.gph",replace
	graph save "g1_2015" "${OUT}/drinking30_sc—weight—14.gph",replace
	
	outreg2 using "${OUT}/Table_main.xls",append excel stats(coef pval) dec(3) alpha(0.01,0.05,0.1) symbol(***,**,*)   


	foreach m in tau omega adoption beta   {
		matrix list e(`m')
		mat `m' = e(`m')
	}	


	sdid drinking30  id year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp  , projected) method(sdid) ///
	graph g1on  ///
	g1_opt(ytitle("Differences") xtitle("Counties") title("SDID") legend(ring(0) pos(5)))  ///
	g2_opt(ytitle("Past-Month Drinking Rate(%)") xtitle("Year") title("SDID") ylabel(20(10)50) xlabel(2005(2)2020) title("SDID") )  
	graph save "g2_2015" "${OUT}/drinking30_sdid—ATE—14.gph",replace
	graph save "g1_2015" "${OUT}/drinking30_sdid—weight—14.gph",replace
	
	outreg2 using "${OUT}/Table_main.xls",append excel stats(coef pval) dec(3) alpha(0.01,0.05,0.1) symbol(***,**,*)   

	foreach m in tau omega adoption beta   {
		matrix list e(`m')
		mat `m' = e(`m')
	}	
xx
	
******************combine graph
	graph combine "${OUT}/figure/drinking30_did—ATE—11.gph" "${OUT}/figure/drinking30_sc—ATE—11.gph" "${OUT}/figure/drinking30_sdid—ATE—11.gph", title("Panel A : The First Batch") rows(3)  cols(1) iscale(.7273) ysize(12)  graphregion(margin(zero))
	graph export "${OUT}/figure/ATE_11.png",replace  	
	
	graph combine "${OUT}/figure/drinking30_did—ATE—12.gph" "${OUT}/figure/drinking30_sc—ATE—12.gph" "${OUT}/figure/drinking30_sdid—ATE—12.gph", title("Panel B : The Second Batch") rows(3)  cols(1) iscale(.7273) ysize(12)  graphregion(margin(zero))
	graph export "${OUT}/figure/ATE_12.png",replace  
	
	graph combine "${OUT}/figure/drinking30_did—ATE—14.gph" "${OUT}/figure/drinking30_sc—ATE—14.gph" "${OUT}/figure/drinking30_sdid—ATE—14.gph", title("Panel C : The Third Batch") rows(3)  cols(1) iscale(.7273) ysize(12)  graphregion(margin(zero))
	graph export "${OUT}/figure/ATE_14.png",replace 
	xx
	
	graph combine "${OUT}/figure/ATE_11.gph" "${OUT}/figure/ATE_12.gph" "${OUT}/figure/ATE_14.gph", rows(1)  cols(3) iscale(.7273) ysize(12) xsize(12)  graphregion(margin(zero))	

	
	graph combine  "${OUT}/drinking30_sc—weight—11.gph" "${OUT}/drinking30_sdid—weight—11.gph"
	graph export "${OUT}/figure/weight_11.png",replace width(6000)  height(3000)
	
	graph combine  "${OUT}/drinking30_sc—weight—12.gph" "${OUT}/drinking30_sdid—weight—12.gph"
	graph export "${OUT}/figure/weight_12.png",replace width(6000)  height(3000)	
	
	graph combine  "${OUT}/drinking30_sc—weight—14.gph" "${OUT}/drinking30_sdid—weight—14.gph"
	graph export "${OUT}/figure/weight_14.png",replace width(6000)  height(3000)	
		
	
	
	
	
	
	//title("Comparasion between DID, SC, and SDID estimates in the first batch")
	
	
/*

    Macros         
      e(cmd)              sdid
      e(cmdline)          command as typed
      e(depvar)           name of dependent variable
      e(vce)              vcetype specified in vce()
      e(clustvar)         name of cluster variable

    Matrices       
      e(tau)              tau estimator for each adoption time-period, along with its standard error
      e(lambda)           lambda weights (time-specific weights)
      e(omega)            omega weights (unit-specific weights)
      e(adoption)         adoption times
      e(beta)             beta vector of corresponding to covariates (only returned when the covariates option is indicated)
      e(series)           control and treatment series of the graphs (only returned when the graph option is indicated)
      e(difference )       difference between treatment and control series (only returned when the graph option is indicated)

*/	
use "${OUT}/final with 18 random select_fin2.dta",clear
ren dsp id
cls
	sdid drinking30  id year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp  , projected) method(did) 	
	outreg2 using "${OUT}/Table_main.xls",append excel stats(coef pval) dec(3) alpha(0.01,0.05,0.1) symbol(***,**,*)   

	
	sdid drinking30  id year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp  , projected) method(sc) 	
	outreg2 using "${OUT}/Table_main.xls",append excel stats(coef pval) dec(3) alpha(0.01,0.05,0.1) symbol(***,**,*)   


	foreach m in tau omega adoption beta   {
		matrix list e(`m')
		mat `m' = e(`m')
	}	


	sdid drinking30  id year treated , vce(bootstrap) seed(1213) covariates(sex prop_65 log_gdp  , projected) method(sdid) 	
	outreg2 using "${OUT}/Table_main.xls",append excel stats(coef pval) dec(3) alpha(0.01,0.05,0.1) symbol(***,**,*)   

	foreach m in tau omega adoption beta   {
		matrix list e(`m')
		mat `m' = e(`m')
	}	
