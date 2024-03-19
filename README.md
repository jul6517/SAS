Final SAS Lab group project
Due: 4/9/2023 11:59 EST on canvas

subtitle: “pt: 40”

Submit only one .PDF / .HTML/ .DOC file that include the following:

Your group member’s names

You should include each task as listed in this html and under each numbered task, include your sas code and result, it can be screenshot.

You will read in the study1.csv file that contains the following variables:

“id”

“rx”: treatment 1=placebo; 2=treatment

“age”

“bmi”

“female”

“readmission” 1= Readmission yes; 0=No 90 day readmission

“comorbidity_index”: index 4-5: severe; 3: moderate; 1-2: light

“charges”: total hospital charge

“los” : length of stay

“tract”: census tract

survival.df

"id"

"time" : time of follow up(death of censor)

"status": true = event, false= censor
note: steps are sequential

Do the following:

Round up age to integer (pt 2)

Do basic statistical summary on this data (5pt)

Write a macro that would take in variable name and run univariate logistic regression on readmission controlling for the other variables(excluding id and tract) one at a time. (5pt)

Do a ttest to compare numeric variables between treatment (2pt)

Do a chi sq test to compare categorical variable(s) between treatment (2pt)

Do a propensity score matching 1:1 that on age, bmi, female and comorbidity_index for treatment group (5pt)

Then use the PS matched 1:1 data and repeat the above step 1-3, summarize what you find. (difference in variables between treatment group should be smaller after matching). (2pt)

Merge the PS matched dataset from step 5 with survival.df on id, name the merged file “merged_1” (2pt)

Merge the PS matched dataset from step 5 with survival.df on id, and subset to only include comorbidity_index in severe or moderate categories, name the merged file “merged_2”(2pt)

For merged_1 file and For merged_2 file, do the following steps:

Run a proc lifetest and populate the following curves (3pt)

KM curve for the whole group

KM curves between gender

KM curve between treatment

Run a cox ph model on time to death (time variable) controlling for age, female, treatment (3pt)

Read in the social_characteristics.csv file, do the following data cleaning steps (7pt)

Remove first row

Substring GEO_ID to keep only characters after US (for example: 1400000US42001030101 – > 42001030101) and keep that to a new column called “tract”

Clean up name column separate them into columns by “,”

We will subset this social_characteristics data, we will keep GEO_ID and variables in the column “variable” from data_dictionary_include.csv that start with prefix”DP02” and include column =“x”

Use the tract variable to merge the subsetted social_characteristics file with the merged_1 file.

Run a linear regression on los controlling for all the DP02 variables, rx, age, female, charge

Use proc sql to summary by tract, what’s the mean age, mean of each DP variables, sum of all the DP variables, and order by sum of all the DP variables and show only the top 10 tract.
