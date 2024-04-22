/*
Note: 

The do files involved are cited from by Yaxi and by Siyu

*/

clear all
set matsize 3956, permanent
set more off, permanent
set maxvar 30000
capture log close
sca drop _all
matrix drop _all
macro drop _all

******************************
*** Define main root paths ***
******************************

//NOTE FOR WINDOWS USERS : use "\" instead of "/" in your paths
global root "/Users/x152/Desktop/method paper 分析和文稿" 					// adjust 

* Define path for data sources
global RAW "${root}/Rawdata"

* Define path for general output data
global OUT "${root}/Output"

* Define path for intermediate data
global INT "${root}/Intermediate"

* Define path for do-files
global DO "${root}/Code"

* Define path for general output data 
global Result "${root}/Results"

