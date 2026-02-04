****************
// ABSTRACT // 
***************

//The first dataset I selected was from the Census Burea. I selected data containing information on incomes and education levels in Hamilton County, TN and Tennesse as a whole. I figured this would be a good starting point for the future so that I could compare my data to other counties in TN or to other states/ the country as a whole. They might answer questions related to how income affects education rates, or when coupled with other datasets it might answer income and education rates/demographics related to healthcare, crime, and so on, showing why it is a great starting data set. Additionally, it could answer questions relating to how Hamilton County compares to Tennessee as a whole in relation to educaiton levels/incomes. 

//As seen, the second dataset I selected had to do with educational demogrpahics. I used policymap to retrieve data about the demographics of schools in Hamilton County. This will serve as a good initial set to understand varying demographics. Later, I may use it to compare income in Hamilton County to different school demogrpahics, which could help lead to questions about education outcomes/ rates of post-secondary degrees completed/pursued, or things like crime rates or even health insurance rates. The datasets I have combined for now are quite simple and bare boned, but they will help me in the future as I synthesize relationships between certain demographics and characteristics with income and education demographics. 

****************
// FIRST DATASET // 
***************

// First, I imported the file containing the data that I was using. My first file contained census data for income levels both in Hamilton County and in Tennessee as a whole. It contained information such as below/above poverty levels and school enrollment based on them, both in Hamilton County, TN (Where I am from) as well as Tennessee as a whole.

import delimited "https://drive.google.com/uc?export=download&id=188SCPo5YmApwdC3HrMtfwOzsSLYiMIwB"

//// The formatting was slightly off in terms of variables and labels, so I had to change a lot of the labels so that the would make sense for the data I was exploring. I did not label some of the variables I renamed here since I knew I would be dropping them. 

rename v1 Attributes
rename v2 TN
rename v3 TNMOE
rename v4 TNPD
rename v5 TNPDMOE
rename v6 TNMI
rename v7 TNMIMOE
rename v8 HC
rename v9 HCMOE
rename v10 HCPD
rename v11 HCPDMOE
rename v12 HCMI
rename v13 HCMIMOE

// I had to drop some of the rows to fix formatting issues.

drop in 1/4

// I dropped variables to clean the set up.

drop TNMOE TNPD TNPDMOE TNMI TNMIMOE HCMOE HCPD HCPDMOE HCMI HCMIMOE

// Good to go, now you save, clear, and get ready for the second data set.

save censusdata1.dta, replace
clear

****************
// SECOND DATASET // 
***************

// I import my second data set. This set contains information on schools in Hamilton County. It has lot of demographic and enrollment information to work with.

import delimited "https://drive.google.com/uc?export=download&id=1fhNSuEsLa7sZwORSYyQbcOy-QDiUm5JO"

// It contained a lot of unecessary variables that I did not care to use in this comparison, so I dropped them.

drop v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v15 v16 v17 v18 v19 v20 v21 v22 v39 v40 v57 v58 v59 v60 v56

//Dropped more rows to enhance formatting.

drop in 1/2

// Renamed the school labeling as attributes so that the two sets would merge properly. 

rename v1 Attributes

//Save, replace, clear, go forward with merging.

save policymapdata1.dta, replace 
clear 

****************
// MERGE // 
***************

use censusdata1.dta, clear
merge 1:1 Attributes using policymapdata1.dta

// After merging, you can see that the data set does not entirely match up due to the differences in the datasets and what they are evaluating. From here, there are several things you can do. 

//Here, I am splitting up the Attributes variable into two different variables so that I can make sure the two data sets are distinct and show up in different ways in the data editor.

gen Attributes_top = Attributes if _n <= 31
gen Attributes_bottom = Attributes[_n + 31]

// Here, I moved attributes_bottom to before the variable v12 so it would be clear and obvious the distinction between the two datasets.

order Attributes_bottom, before(v12)

// I shifted all of my observations up in the variables so that they would be visible on the chart and allign with the school names, since the data came from the various schools.

local vars v12 v13 v14 v23 v24 v25 v26 v27 v28 v29 v30 v31 v32 v33 v34 v35 v36 v37 v38 v41 v42 v43 v44 v45 v46 v47 v48 v49 v50 v51 v52 v53 v54 v55

foreach var of local vars {
    gen `var'_shifted = `var'[_n + 31]
}

// I deemed a lot of the variables unecessary in the chart and in the comparions I was trying to draw, hence me dropping many of them below. 

local vars v12 v13 v14 v23 v24 v25 v26 v27 v28 v29 v30 v31 v32 v33 v34 v35 v36 v37 v38 v41 v42 v43 v44 v45 v46 v47 v48 v49 v50 v51 v52 v53 v54 v55

drop `vars'

// More variables were dropped to clean up the dataset.

drop _merge
drop Attributes_top

//The observations of the schools in Attributes were dropped so that they were not repeated and to avoid confusion.

replace Attributes = "" in 32/L 

// Renaming variables to fit what the dataset is communicating.

rename Attributes_bottom School_Names
rename v12_shifted Total_students
rename v13_shifted fulltime_staff
rename fulltime_staff fulltime_teachers
rename v14_shifted studentteacher_ratio

// I had to go back and drop shifted variables that I had dropped already, but I had not dropped the shifted version.

drop v23_shifted-v41_shifted

// Renamed variables so that they were properly communicating information from the original dataset and so that the reader would understand what was going on. 

rename v42_shifted White_Non_Hispanic_Students
rename v43_shifted Hispanic_students
rename v44_shifted Black_students
rename v45_shifted asian_students
rename v46_shifted American_native_students
rename v47_shifted Hawaiian_native_students
rename v48_shifted two_or_more_race_students
rename v49_shifted percent_white
rename v50_shifted Percent_hispanic
rename v51_shifted Percent_black
rename v52_shifted Percent_asian
rename v53_shifted Percent_american_native
rename v54_shifted percent_hawaiian_native
rename v55_shifted Percent_two_or_more_races


****************
// SAVE AND FINISH // 
***************

save ps1_edited.dta, replace

export delimited "ps1_edited.csv", replace 
