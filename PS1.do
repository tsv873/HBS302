// DO NOT BEGIN RUNNING THE DO FILE AT THIS PART. THIS PART OF THE DO FILE SIMPLY EXPLAINS WHAT I WAS DOING AND HOW I CREATED THE DATA SET WITH THE LINK THAT CAN BE RUN. 
// The data I selected was from the Census Burea. I selected data containing information on incomes and education levels in Hamilton County, TN and Tennesse as a whole. I figured this would be a good starting point for the future so that I could compare my data to other counties in TN or to other states/ the country as a whole. They might answer questions related to how income affects education rates, or when coupled with other datasets it might answer income and education rates related to healthcare, crime, and so on, showing why it is a great starting data set. Additionally, it could answer questions relating to how Hamilton County compares to Tennessee as a whole in relation to educaiton levels/incomes. 

// First, I imported the file containing the data that I was using. My first file contained census data for school enrollment. It contained information such as below/above poverty levels and school enrollment based on them, both in Hamilton County, TN (Where I am from) as well as Tennessee as a whole.

import delimited cd1.csv, clear

// The formatting was slightly off in terms of variables and labels, so I had to change a lot of the labels so that the would make sense for the data I was exploring.

rename v2 Tennessee
label variable Tennessee "TN estimated data"
rename v3 TNMOE
rename v4 HCTN
rename v1 attributes
rename v5 HCMOE
label variable TNMOE "TN Margin of Error"
label variable HCTN "Hamilton County TN"
label variable HCMOE "Hamilton County Margin of Error"

// I also dropped the first two rows because they were also causing formatting issues. 

drop in 1/2

// I resaved the file since I had edited it so much, it took my a couple tries to do it correctly.

save cd1, replace
save cd1_edited

// Next, I imported the second data set. 

import delimited cd2.csv, clear


// I had to do the same with this data set, except it had a lot more variables. This dataset was also from the census and contained data on household income with a variety of workers, Social Security Income, and other various factors that affect income. I did not label this data set since I knew I would be cutting it down after merging so I did not find it necessary.

rename v1 attributes
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

// This data set was very messy and I had to drop 4 rows to clean it up. 

drop in 1/4

// Right here I resaved the data set as edited so I could access it before as a .csv file and now as a .dta file. 

save cd2_edited.dta
clear

// Next, I opened my previous data set so I could being merging. 

use cd1_edited.dta, clear

// I had to rename some variables so that they would match with the other data sets.

rename Tennessee TN
rename HCTN HC

// Saved it once more since I edited it.

save cd1_edited2.dta

// I decided to instead use the other data set for merging. 

use cd2_edited.dta

// I merged using the three variables that matched one another.

merge 1:1 attributes TN HC using cd1_edited2.dta

// I dropped all of these variables because there were so many and I did not deem them applicable to what I was searching for. They contained information on Magin of Error and Percent distribution as well as mean income for Tennessee as a state and Hamilton County. I deleted them because I was just doing simple comparisons and looking at simple stats, so they were not necessary. 

drop TNMOE TNPD TNPDMOE TNMI HCMOE HCPD HCPDMOE HCMI HCMIMOE
drop TNMIMOE 


//I finally saved the dataset that had been merged containing all of the stats as one. Now I have a dataset containing information about incomes in TN and Hamilton County as well as education information. In the future, I can use this dataset to draw comparisons state wide to income levels and education levels, but I can also merge it with future datasets to compare Tennessee to either other states or national levels. 

save cd3.dta


// I then summarized and described my data so I could explore it. This did not really help though, as a lot of the data is observations and they don't necessarily connect with one another. However, once I add more national data or other state data I will be able to use these commands to comare those datasets to one another. The mering in this is mainly focused on creating a dataset for future use and comparison. 

describe
summarize 

// Finally, I saved the same dataset as a .csv file on top of the .dta file I had already saved it as.

export delimited using "cd_final.csv", replace

//NOW is where you can run the .do file. This is where my shareable link was created so that you could open the dataset and see it in its final form, merged and completed. 

// The reason I did it this way, was because I had initially done all of the work on the backhand side connected to my computer, so I went back and created my dataset as a google file so that I could then simply attach it to the end instead of going back and doing the work all over again. 
import delimited ///
"https://drive.google.com/uc?id=1RI7Y38i_zGtB_jLTgSlVqdKgTIYYZCeL/export=download"

// Then, you can drop the merged variables just to clean up your dataset a bit more since it is a little messy at this point. 
drop _merge

// Now, I am going back and saving my dataset in two different ways after doing it via a google link to further show understanding. 
save cd3g.dta
export delimited using "cdg_final.csv" 

