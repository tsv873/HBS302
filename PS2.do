
/// In this prioblem set, I used different datasets in order to ensure better merging and to create more graphs, however I did run into some trouble which you will see later. That being said, we always start by importing the data sets.

/// This dataset is downloaded from a google drive link, and is describing percent of broadband access across different zipcodes, seen in GEOID within Tennessee.

import delimited "https://drive.google.com/uc?export=download&id=16nXnrJ3EJV7Tnu1D4vuSnoP3l9s1fBW-" 

/// Here, I'm just renaming some variables to ensure that merging will be possible.

rename geoid_1 geoid 

/// Of course, we have to save this as its own new dataset, while also replacing any old dataset with the same name to ensure replicability across platforms.

save dataset1.dta, replace

/// Make sure to clear so you can start using a new dataset. 

clear

/// Next, we are importing the next dataset also via a google drive link. This dataset explores the percentage of bachelor degrees within different area codes in the state of Tennessee.

import delimited "https://drive.google.com/uc?export=download&id=1TidBJG6ilnv8TzvsRGCd9aeDTsBUFVPB" 

/// Again, we have to save the dataset and replace if there is an old dataset with the same name to ensure replicability. 


save dataset2.dta, replace

/// Clear again so we can go back to the first dataset and clean it up before meging the two togther. 

clear

/// Bring back the first dataset.

use dataset1.dta

/// Check to see if there are duplicates between the two variables you'd like to merge on. I chose these two variables because they are the same among the two datsets, both look at the location of TN as a state and at the GEOIDs(zip codes), so they can be merged with those variables.

duplicates list geoid location

/// After seeing duplicates, we have to find out where those are. This dataset originally contained two different zip code examinations so we are just taking out the second one and going to focus on percent of broadband in this specific set. To do that, we have to drop the second set of geoids,locations, and formatiing. Additionally, I dropped a couple of other variables in order to clean the dataset and make it easier to read.

drop geoid_description_2 geovintage_2 geoid_name_2 geoid_formatted_2 pfampov_20192023 timeframe_2 geoid_2 geoid_description_1 geovintage_1 geoid_name_1 geoid_formatted_1

/// Once again, you have to resave the dataset in order to keep it as the revamped version that you are using to merge. That replace command is key to ensure it stays under the same name but with the updated variables.

save dataset1.dta, replace ///
clear

/// Double check that second dataset in order to ensure that it is also clean before doing the merge process.

use dataset2.dta

/// Here I am just dropping some variables to make sure there are no duplicates in this dataset and just to clean it up a little more. After that I once again resave and replace the dataset for the same reasons as before.

drop geoid_name geoid_formatted geovintage ///
save dataset2.dta, replace ///
clear ///

/// Now, we go back to that first dataset to begin the merge process.

use dataset1.dta

/// Once again, we just double check to make sure there are no duplicates.

duplicates list geoid 

/// Since there are, we drop the rows where they exist. We have to be very specific here, because the duplicates that do exist are because some of the zipcodes spill into other states, and we really only want to see the Tennessee data, which is why we drop the rows we do.

drop in 1/4
drop in 608/609

/// These two commands show us that there are no more duplicates and that we can begin the merge process.

duplicates list geoid ///
isid geoid

/// Merge! Since the two datasets contain the same variables and observations for location and geoid we merge on that variable.

merge 1:1 geoid using dataset2.dta

/// Just drop the variable describing the merge to clean it up a little more.

drop _merge

/// Now, save this dataset with the merged variables as a 3rd dataset. The replace is there for the same reason that it is previously in the dataset.

save dataset3.dta, replace/// 
clear

/// Make sure it opens with use.

use dataset3.dta

/// Renaming this variable since it is long and I want to explore it. This just cleans it up and makes it easier to use in commands. 

rename phh_anybroadband_20192023 pbroadband

/// I am just exploring the variables that I want to know more about here, which are percent of broadband access in zip codes and the percent of bachelors degrees in zipcodes.

summarize pbroadband ///
tabulate pbach

/// I noticed a discrepancy between data and observations between the two sets so I just cut it out since some zip codes and geoIDs were unable to report information and therefore wouldn't be helpful for this study.

drop in 608/638

/// Now I am just exploring more of the variables, even exploring the relationship between geoid and location. I do this to ensure all are located in Tennessee and that I didn't miss anything.

tabulate pbach ///
tab geoid ///
tab geoid location 

/// Finally, I looked at broadband access by geoID and how they deviate from one another as well as their max and min potential stat based off the standard deviation between one another. 

tabstat pbroadband, by(geoid) statistics(mean sd min max n) 

/// What I noticed here is that pbach was labeled as a string variable, but there are only numeric values, which is why I destring so I can really look at pbach and understand it and use it in graphing as a numeric variable and observations. Resave the dataset after this to make sure that dataset is correct if you happen to lose your place.

destring pbach, replace ///
save dataset3.dta, replace 

/// Now I retabulate to explore further.

tabulate pbach ///
tab pbach pbroadband

/// Now it is time to make graphs.

//First, I make a twoway scatter plot showcasing how the first ten zipcodes vary in terms of their percentage of broadband access and their percentage of bachelors degrees. This shows how different zip code regions match up with one another on the two variables.


twoway scatter pbroadband pbach in 1/10, ///
mlabel (geoid) ///
    mcolor(green) ///
	mlabcolor(green) ///
    legend(on label (1 "GEOID") position(3) ring(2)) ///
	ytitle("Percent Broadband Access") ///
    xtitle("Percent Bachelor's Degree") ///
    title("Broadband vs Bachelor's Degree", margin (medium)) ///
	graphregion(margin(t+3)) 
	
	/// Make sure to export it so that it saves as a png and it can be more easily saved on to your desktop. 
	
	graph export "PBrBa_Scatter.png"
	
/// Next, we are making a second graph. This is more concise. Here, we are making a bar graph showing the percent of broadband access per the first ten geo ids in a bar graph. It includes value labels on top of the bar graph and is very easy to read. We also save this one as a .png. 


graph bar (asis) pbroadband if _n <= 5, over(geoid) bar(1, color(green)) title("Broadband Percentage by GEOID ") /// 
subtitle("First 5 Observations") ///
blabel(bar, format(%2.1f)) ///

graph export "BroadBand_ByGBar1.png"
	
	
/// These visuals helped me to understand how broadband access and percent bachelors degrees correlated between zip codes. I only use five to ten zip codes or geoids in this so that it does not overcrowd the graph and still make it easy to read. In the future, this data will make it way easier to understand how these two variables correlate and can be used on small scale level between zip codes, giving a precise understanding of how they correlate with one another. I think the two way scatter was especially insightful as it showed really how the two differentiated with one another. If I add a line to that and fit the geo IDs there, I will soon be able to see how all counties allign with another and how well they are doing in both areas. The bar graph gives a much simpler understanding and is very good as a basic check in on some of these zip codes at least in a visual sense. 
