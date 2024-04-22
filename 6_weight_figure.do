use "${OUT}/final with_weightsdid_2.dta",clear
	preserve 
		keep if year <2013
		keep year drinking30 County
		reshape wide drinking30,i(County) j(year)
		gen mean_drinkno_2  = drinking302007*0.3698 +  drinking302010*0.6302
		keep County mean_*
		tempfile t1
		save `t1',replace
	restore
		keep if year >=2013
		keep if treated2011==1 | treated_g == 0
		merge m:1 County using `t1'
		keep if _m == 3
		drop _m
			
		bysort dspcode: egen mean_sc_drinkno  = mean(drinking30)
		gen mean_sdid_drinkno  = mean_sc_drinkno-mean_drinkno_2
		egen mean_sc_drink = mean(mean_sc_drinkno) if treated2011 == 1 
		egen mean_scfin_drink = mean(mean_sc_drink)
		
		egen mean_sdid_drink = mean(mean_sdid_drinkno) if treated2011 == 1 
		egen mean_sdidfin_drink = mean(mean_sdid_drink)
	
		keep if treated_g == 0
		keep County mean_sdidfin* mean_scfin*  mean_sc_drinkno mean_sdid_drinkno sc_w11 sdid_w11
		duplicates drop
		

		
		gen gap_sc_11 = mean_scfin-mean_sc_drinkno
		gen gap_sdid_11 = mean_sdidfin-mean_sdid_drinkno

		keep gap_sc_11 gap_sdid_11 County sc_w11 sdid_w11
		sort County
		gen order = _n
								
local xlabel 1 "Tongzhou District" ///
2 "Seaport District" ///
3 "Fenning Manchu  County" ///
4 "Jiangxian County" ///
5 "Balingyu Banner" ///
6 "Liaoyang County" ///
7 "Dehui City" ///
8 "Fengman District" ///
9 "Ji'an City" ///
10 "Yi'an County" ///
11 "Jinhu County" ///
12 "Ringshui County" ///
13 "Wucheng District" ///
14 "Yushan District" ///
15 "Longnan County" ///
16 "Shanggao County" ///
17 "Penglai" ///
18 "Laicheng District" ///
19 "Zhongyuan District" ///
20 "Sli County" ///
21 "Huixian District" ///
22 "Tanghe County" ///
23 "Wujiagang District" ///
24 "Liuyang City" ///
25 "Pingjiang County" ///
26 "Sihui City" ///
27 "Wuhua County" ///
28 "Xiufeng district" ///
29 "Hepu County" ///
30 "Lingyun county" ///
31 "Renhe District" ///
32 "Xichong County" ///
33 "Hanyuan County" ///
34 "Honghuagang District" ///
35 "Meitan County" ///
36 "Yuping Dong County" ///
37 "Tonghai County" ///
38 "Guangnan county" ///
39 "Xiangyun county" ///
40 "Lanping Bai Pumi County" ///
41 "Gyantse County" ///
42 "Huayin City" ///
43 "Maiji District" ///
44 "Dunhuang District" ///
45 "Lintan County" ///
46 "Ping'an County" ///
47 "Xingqing District" ///
48 "Xinhe County" ///
49 "Shache County" ///
50 "Hotan County" 	

	preserve
		keep County *sc* gap_sc_11 order
		gen line = -4.437
		save "${OUT}/weightsdid_sc_11.dta",replace
	restore	
	preserve
		keep County *sdid* gap_sdid_11 order
		ren  (sdid_w11 gap_sdid_11) (sc_w11 gap_sc_11)
		gen line = -12.939	
		save "${OUT}/weightsdid_sdid_11.dta",replace
	restore	
	
	use "${OUT}/weightsdid_sc_11.dta",clear
		gen class = "sc"
		append using "${OUT}/weightsdid_sdid_11.dta"
		replace class = "sdid" if class == ""
	save "${OUT}/weightsdid_11.dta",replace	

	
use "${OUT}/final with_weightsdid_2.dta",clear
	preserve 
		keep if year <2013
		keep year drinking30 County
		reshape wide drinking30,i(County) j(year)
		gen mean_drinkno_2  = drinking302007*0.3698 +  drinking302010*0.6302
		keep County mean_*
		tempfile t1
		save `t1',replace
	restore
		keep if year >=2013
		keep if treated2012==1 | treated_g == 0
		merge m:1 County using `t1'
		keep if _m == 3
		drop _m
			
		bysort dspcode: egen mean_sc_drinkno  = mean(drinking30)
		gen mean_sdid_drinkno  = mean_sc_drinkno-mean_drinkno_2
		egen mean_sc_drink = mean(mean_sc_drinkno) if treated2012 == 1 
		egen mean_scfin_drink = mean(mean_sc_drink)
		
		egen mean_sdid_drink = mean(mean_sdid_drinkno) if treated2012 == 1 
		egen mean_sdidfin_drink = mean(mean_sdid_drink)
	
		keep if treated_g == 0
		keep County mean_sdidfin* mean_scfin*  mean_sc_drinkno mean_sdid_drinkno sc_w12 sdid_w12
		duplicates drop
		

		
		gen gap_sc_12 = mean_scfin-mean_sc_drinkno
		gen gap_sdid_12 = mean_sdidfin-mean_sdid_drinkno

		keep gap_sc_12 gap_sdid_12 County sc_w12 sdid_w12
		sort County
		gen order = _n
								
	preserve
		keep County *sc* gap_sc_12 order
		gen line = -3.882
		save "${OUT}/weightsdid_sc_12.dta",replace
	restore	
	preserve
		keep County *sdid* gap_sdid_12 order
		ren  (sdid_w12 gap_sdid_12) (sc_w12 gap_sc_12)
		gen line = -6.925
		save "${OUT}/weightsdid_sdid_12.dta",replace
	restore	
	
	use "${OUT}/weightsdid_sc_12.dta",clear
		gen class = "sc"
		append using "${OUT}/weightsdid_sdid_12.dta"
		replace class = "sdid" if class == ""
	save "${OUT}/weightsdid_12.dta",replace	

	
	
	
	
	
use "${OUT}/final with_weightsdid_2.dta",clear
	preserve 
		keep if year <2015
		keep year drinking30 County
		reshape wide drinking30,i(County) j(year)
		gen mean_drinkno_2  = drinking302007*0.3099 +  drinking302010*0.2219 +  drinking302013*0.4682 
		keep County mean_*
		tempfile t1
		save `t1',replace
	restore
		keep if year >=2015
		keep if treated2014==1 | treated_g == 0
		merge m:1 County using `t1'
		keep if _m == 3
		drop _m
			
		bysort dspcode: egen mean_sc_drinkno  = mean(drinking30)
		gen mean_sdid_drinkno  = mean_sc_drinkno-mean_drinkno_2
		egen mean_sc_drink = mean(mean_sc_drinkno) if treated2014 == 1 
		egen mean_scfin_drink = mean(mean_sc_drink)
		
		egen mean_sdid_drink = mean(mean_sdid_drinkno) if treated2014 == 1 
		egen mean_sdidfin_drink = mean(mean_sdid_drink)
	
		keep if treated_g == 0
		keep County mean_sdidfin* mean_scfin*  mean_sc_drinkno mean_sdid_drinkno sc_w14 sdid_w14
		duplicates drop
		

		
		gen gap_sc_14 = mean_scfin-mean_sc_drinkno
		gen gap_sdid_14 = mean_sdidfin-mean_sdid_drinkno

		keep gap_sc_14 gap_sdid_14 County sc_w14 sdid_w14
		sort County
		gen order = _n
								
	preserve
		keep County *sc* gap_sc_14 order
		gen line = -6.780
		save "${OUT}/weightsdid_sc_14.dta",replace
	restore	
	preserve
		keep County *sdid* gap_sdid_14 order
		ren  (sdid_w14 gap_sdid_14) (sc_w14 gap_sc_14)
		gen line = -2.403
		save "${OUT}/weightsdid_sdid_14.dta",replace
	restore	
	
	use "${OUT}/weightsdid_sc_14.dta",clear
		gen class = "sc"
		append using "${OUT}/weightsdid_sdid_14.dta"
		replace class = "sdid" if class == ""
	save "${OUT}/weightsdid_14.dta",replace	
	

	
	
	
	
	
use "${OUT}/weightsdid_14.dta",clear
	append using "${OUT}/weightsdid_12.dta"  "${OUT}/weightsdid_11.dta"
	drop line
	foreach k in sc_w14 gap_sc_14 sc_w12 gap_sc_12 sc_w11 gap_sc_11 {
		bysort County class: egen mean`k' = mean(`k')	
		
	}
	foreach k in meansc_w    {
		gen `k' = `k'11 *9/35 + `k'12 *18/35 +`k'12 * 8/35	
	}
	gen gap_sc = meangap_sc_11 *9/35 + meangap_sc_12 *18/35 + meangap_sc_14 * 8/35	
	keep County gap_sc meansc_w order class
	duplicates drop
	
	gen line = 1.407 if class =="sc"
	replace line = -7.433 if line == .
	
	ren meansc_w sc_w
	save "${OUT}/weightsdid_total.dta",replace	
