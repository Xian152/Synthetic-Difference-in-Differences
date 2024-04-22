/* DiD code 
1. 平行趋势假设：
	我们首先得生成一系列政策实施前后的虚拟变量
	然后将虚拟变量带入模型中重新回归
	最后再用 coefplot 之类的命令绘图
	
ref：
https://blog.csdn.net/arlionn/article/details/103220314	
https://www.lianxh.cn/news/e715545930fcf.html //Stata：一行代码绘制平行趋势图-eventdd
https://www.lianxh.cn/news/3849f237b6d36.html //Stata：DID入门教程
*/
ssc install matsort, replace
ssc install eventdd, replace
ssc install coefplot,replace
ssc install synth, replace
ssc install synth2, replace
ssc install binscatter,replace 
ssc install reghdfe,replace
ssc install cnssc,replace
ssc install ftools,replace
ssc install estout,replace
ssc install outreg2,replace
cnssc install lxhget, replace
lxhget tsg_schemes.pkg, des
net install cleanplots, from("https://tdmize.github.io/data/cleanplots")

webuse set www.damianclarke.net/stata/
webuse bacon_example.dta, clear

//NFD：无过错婚姻法案 (No-fault divorce，NFD)
//asmrs：女性自杀率
//解释变量 post 为各州是否实施 NFD 的虚拟变量，_nfd 是各州实施 NFD 的具体年份

*每个样本政策实施的相对时间 dist
gen dist = year - _nfd

/*随后，我们用事件研究法估计政策效应。该命令提供了三种估计方法，分别是 ols、fe 和 hdfe。
ols 需要自己加入个体固定效应 i.stfips 和时间固定效应 i.year；
fe 则可以设置 method(fe)，仅需加入时间固定效应；
hdfe 则可以用过 absorb(stfips year) 设定个体固定效应和时间固定效应。当然，三种方法所得结果几无差异。
三者没有区别
*/

* ols
eventdd asmrs pcinc asmrh cases i.year i.stfips,  	///
    timevar(dist) method(, cluster(stfips))       	///
    graph_op(ytitle("Suicides per 1m Women"))
	
* 目的：事前不显著，事后显著异于零。	
*对事前趋势进行联合显著性检验，
estat leads	 //p=0.000 F test 拒绝原假设，即确实存在事前趋势。
*事后趋势
estat lags	//事后趋势虽然显著异于零，满足分析要求，但是 F 值却不大。
	
* fe
eventdd asmrs pcinc asmrh cases i.year, 			///
     timevar(dist) method(fe, cluster(stfips)) 		///
     graph_op(ytitle("Suicides per 1m Women"))

* hdfe
eventdd asmrs pcinc asmrh cases, timevar(dist) 		///
     method(hdfe, absorb(stfips year) cluster(stfips)) 	///
     graph_op(ytitle("Suicides per 1m Women"))

*多数情况下，我们并不需要这么长的分析窗口，时间一长，很难避免其他不可观测因素的影响。
*因此，我们更倾向于把事件分析窗口压缩至较短范围。例如将分析窗口限定在政策实施前后的 10 期内：
eventdd asmrs pcinc asmrh cases, timevar(dist) 				///
     method(hdfe, absorb(stfips year) cluster(stfips))		///
     inrange leads(10) lags(10) 							///
     graph_op(ytitle("Suicides per 1m Women")				///
     graphregion(fcolor(white)))

eventdd asmrs pcinc asmrh cases, timevar(dist) 				///
     method(hdfe, absorb(stfips year) cluster(stfips)) ///
     accum leads(10) lags(10)  ///
     graph_op(ytitle("Suicides per 1m Women") ///
     graphregion(fcolor(white)))

* 绘制连线
eventdd asmrs pcinc asmrh cases, timevar(dist) 				///
     method(hdfe, absorb(stfips year) cluster(stfips))				///
     inrange leads(10) lags(10) 				///
     baseline(0) noline				///
     coef_op(m(oh) c(l) color(black) lcolor(black))				///
     graph_op(ytitle("Suicides per 1m Women")				///
     color(black)				///
     xline(0, lc(black*0.5) lp(dash))				///
     graphregion(fcolor(white)))
	 
* 调整置信区间样式
eventdd asmrs pcinc asmrh cases, timevar(dist) 		///
     method(hdfe, absorb(stfips year) cluster(stfips))		///
     inrange leads(10) lags(10) 		///
     level(90) ci(rline)		///
     baseline(0) noline		///
     coef_op(m(o) c(l) color(black) lcolor(black))		///
     graph_op(ytitle("Suicides per 1m Women")		///
     color(black)		///
     xline(0, lc(black*0.5) lp(dash))		///
     graphregion(fcolor(white)))		///

eventdd asmrs pcinc asmrh cases, timevar(dist) 		///
     method(hdfe, absorb(stfips year) cluster(stfips))		///
     inrange leads(10) lags(10) 		///
     level(90) ci(rarea, fcolor(ltblue%45))		///
     baseline(0) noline		///
     coef_op(m(o) c(l) color(black) lcolor(black))		///
     graph_op(ytitle("Suicides per 1m Women")		///
     color(black)		///
     xline(0, lc(black*0.5) lp(dash))		///
     graphregion(fcolor(white)))		///	 
	 
	 
* 对图进行优化
	 
	 
***************************************************************	 
********************* 合成控制法	 ****************
***************************************************************	 
sysuse smoking      
xtset state year     
synth cigsale retprice lnincome age15to24 beer  ///
    cigsale(1975) cigsale(1980) cigsale(1988),    ///
    trunit(3)trperiod(1989) xperiod(1980(1)1988)  ///
    figure nested keep(smoking_synth)	 
	 
gen effect= _Y_treated - _Y_synthetic //定义处理效应为变量effect，其中"_Y_treated"与"_Y_synthetic"分别表示处理地区与合成控制的结果变量
label variable _time "year"
label variable effect "gap in per-capita cigarette sales (in packs)"
line effect _time, xline(1989,lp(dash)) yline(0,lp(dash))
	 
local weight1name 2018weight1 2015weight1 2013weight1 2007weight1
use "/Volumes/Alan/Data Analysis/county_pch/2010oweight2.dta",clear
foreach m of local weight1name{
	append using "/Volumes/Alan/Data Analysis/county_pch//`m'"
	*merge 1:1 dspcode using "/Volumes/Alan/Data Analysis/county_pch/\`m'"
	*drop _merge
}
destring dspcode, replace
merge m:1 dspcode using "/Volumes/Alan/Data Analysis/county_pch/da_code"
drop _merge
gen time0 = 2011 if batch == 1
replace time0 = 2012 if batch == 2
replace time0 = 2014 if batch == 3
replace time0 = 2017 if batch == 4
gen time_window = year - time0 if batch != .

gen treated = 0
replace treated = 1 if time_window > 0 & time_window != .
gen treated_g = 0
replace treated_g = 1 if batch != .
