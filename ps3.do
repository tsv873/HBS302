
///  *** Julia Dieter, 2/27/2026 Project on Percentage of Bachelors Degrees in comparsion to Percentage of Broadband Access in each zipcode in the state of Tennessee. *** ///


///
*** IMPORTING AND CLEANING THE DATASET ****

///

/// First, I start by importing my dataset from google drive. 

import delimited "https://drive.google.com/uc?export=download&id=110AJVac7cnGVOQIfDBJTlt5IaZbzHsYw", clear

/// Here, I work on cleaning the dataset so that I could view the variables on a smaller scale and therefore have an easier time identifying independent and dependent variables. So here, I just renamed some of the variables and dropped other ones so I could more easily read the dataset and see what was going on.

rename phh_anybroadband_20192023 p_broadband
drop timeframe_1 geoid_description location sitsinstate timeframe source

/// I wanted to describe and tabulate some of the variables so that I could make sure they were continous so that I could use one of them as the dependent variable. 

describe geoid

tab pbach
tab p_broadband

/// I also ran two regressions just to quickly explore the relationships between the variables before actually creating the scatterplot. 

reg p_broadband pbach
reg pbach p_broadband

*** SCATTERPLOT CREATION ***

/// After discovering that pbach and p_broadband were continous, I decided I wanted to use those as my dependent and independent variables. From this, I decided to compare the percentage of bachelors degrees in different area codes (GEOids) based on the percentage of broadband access. 

/// In this scatterplot pbach (Percent of Bachelor's Degrees) is dependent, p_broadband (Percent of Broadband Access)is independent. So, in this scatterplot, we are exploring how broadband access relates to the percentage of people with a bachelor's degree, with each dot representing a geoid/zipcode in the state of Tennessee. On the graph, the horizontal position of the dots (GEOids) is the units pbroadband value and the vertical position is the units pbach value. The fitted line on the scatterplot is the average predicted value of pbach at each level of pbroadband, so you can see in this particular scatterplot higher broadband access is associated with higher bachelors attainment, though that doesn't necessarily mean causation.

twoway (scatter pbach p_broadband) ///
       (lfit pbach p_broadband), ///
       ytitle("Percent of Bachelor's Degrees") ///
       xtitle("Percent of Broadband Access") ///
       title("Scatterplot of % Bachelor's Degrees vs. % Broadband Access") ///
       legend(off)
	   
/// There were a lot of observations in the original scatterplot, so I decided to only do the first ten observations so I could clean up the dataset and make it easier to read. Additionally, I labeled the dots with geoids so you could see where individual zip codes laid on the plot. On top of this, I added more detailed titles explaining what was being seen in the graph. 
	   
	 twoway ///
(scatter pbach p_broadband in 1/10, ///
    mlabel(geoid) mlabsize(small) mlabposition(1)) ///
(lfit pbach p_broadband in 1/10), ///
title("% Bachelor's Degrees vs. % Broadband Access (First 10 Observations)") ///
xtitle("Percent of Broadband Access") ///
ytitle("Percent of Bachelor's Degrees") 
	
    
///
*** REGRESSION AND MARGIN PLOTS ***
///
	  
/// In this next portion, I ran regression, as well as margins and marginsplots in order to further explore the relationships between the two variables. 

/// Here, I create the margins plot describing the relationship previously described by the scatterplot. Before that though, I ran margins to see the ranges, followed by marginsplot for the visualization of those ranges. 
	  
	reg pbach p_broadband
margins, at(p_broadband=(0(10)100))
marginsplot, xdimension(p_broadband) ///
    title("Predicted Percent of Bachelors Degrees by Perdicted Broadband Access") ///
    ytitle("Predicted Percent of Bachelors Degree") ///
    xtitle("Percent of Broadband Access") 
	
/// From this plot, we can see the predicted values, along with the confidence intervals, letting us see how much our dependent variable (Percent of Bachelor's Degrees) changes across values of our independent variable (Percent of Broadband Access). 

/// More specifically, we can see that generally speaking, the perdicted range of percent of Bachelor's degrees decreased as percent broadband access increased, suggesting that a higher percent of broadband access means there is less variation in the percent of bachelor's degrees attainted. On top of this, the plot also suggests that the higher the percent of broadband access, the higher percent of bachelor's degrees attained, seen in the positive slop of the line. 

/// Next, I once again ran the regression and ran est store so that I could create a new regression table showcasing regression variables such as the constant, number of observation, p values/ level of significance, and how much of an affect the Percent of Broadband Access has on the Percent of Bachelor's Degrees in GEOids/Zip codes.
	
	
	reg pbach p_broadband
est store Model1


/// From these results, we can see that for every 1 percentage point increase in Percentage of Broadband Access, we can predict that the percentage of people with Bachelor's Degrees will increase by .490 percentage points, on average, all else equal. Additionally, since the p value given is p<.01, we can know that the relationship is statistically significant at the 1% level, meaning that the relationship does have assocation and is not random. Since the constant is such a high negative at -26.589, we can assume that it is not meaningful in relaity as percentage values can not be negative in reality. All in all though, there is a strong positive association, so that means that we can assume that areas with higher broadband access tend to have higher bachelor's degree attainment. 

/// In this line, I am saving the model we created as a .csv so it can be accessed again via google drive or another method. This just makes it more universal in terms of sharing with others but also saves it to the desktop making it easy to access in the future. 

esttab Model1 using "pbach_regression.csv", ///
    replace ///
    se ///
    label ///
    title("Regression of Percent of Broadband Access on Percent of Bachelor's Degrees") ///
    b(%9.3f) se(%9.3f) star(* 0.05 ** 0.01 *** 0.001) 
	
/// Now the model should be saved on your desktop. 

///
*** CONCLUSION AND REFLECTION***
///

/// The regression results did not surprise me at all. After interpretation, it makes sense to me that there is a clear relatinoship between broadband access and bachelor's degrees, as the internet provides a lot of information about various things, allows people to do homework, participate in zoom classes, and a variety of other things.

/// As far as the visualization, it greatly aided in my understanding of the relationships between the variables. Being able to see a graph depicting how the variables are related to one another helped me understand the positive correlation between the two, as well as how the range of variability changes when different variables change. 

/// As far as next steps, I'd love to be able to compare the groups with more variables to see if this is a matter of causation or correlation and just how strongly these variables are related. With that being said, adding more variables in would help me to see just how related the variables are. 
