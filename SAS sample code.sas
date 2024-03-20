/***************************************************************************
Project: Final SAS Lab group project 
Purpose: This program is to do basic statistical summary 
compare placebo with medication
Programmer: Hsiang-Ching Huang (Juliana) 
Date: 4/10/2023 
Update: 2/18/2024 
************************************************************************/ 
/*Set up data directory and output pdf document*/
%let outpath=/home/u63057552/SAS/my library/Final Project;
ods pdf file="&outpath/sas sample.pdf" STYLE=JOURNAL STARTPAGE=NO PDFTOC=1;
libname indata '/home/u63057552/SAS/my library/Final Project';


proc import datafile="/home/u63057552/SAS/my library/Final Project/study1-1.csv"
out=study
replace
dbms=csv;
run;

FILENAME study '/home/u63057552/SAS/my library/Final Project/study1-1.csv';

/*Explore the contents of study data*/
PROC CONTENTS DATA=study;
run;

/* Definitions of variables:
“rx”: treatment 1=placebo; 2=treatment
“readmission” 1= Readmission yes; 0=No 90 day readmission
“comorbidity_index”: index 4-5: severe; 3: moderate; 1-2: light
“charges”: total hospital charge*/

/*************************************
Round up age to integer
*********************/
data study;
set study;
 age = round(age, 1);
run;
/****Do basic statistical summary on this data****/

proc means data=study n nmiss mean std;
var _numeric_;
run;
proc freq data=study;
tables rx female readmission comorbidity_index;
run;
/***********************************************************************
Write a macro that would take in variable name and 
run univariate logistic regression on readmission 
controlling for the other variables(excluding id and tract) one at a time
***********************************************************************/

%macro regression(var);
proc logistic data=study;
 model readmission = &var;
run;
%mend;

%regression(rx);
%regression(age);
%regression(bmi);
%regression(female);
%regression(comorbidity_index);
%regression(charges);
/*
 The coefficient for rx is 0.0663 with a standard error of 0.0942. 
 The Wald chi-square test has a p-value of 0.4813, 
 indicating that the coefficient for rx is not statistically significant at the 0.05 level.
 Odds ratio estimates for the predictor variable rx is 1.069, 
 with 95% confidence limits of 0.888 and 1.285. 
 This indicates that, for a one-unit increase in rx, 
 the odds of readmission increase by approximately 6.9%, 
 but the confidence interval includes 1, suggesting that the effect is not statistically significant.*/
/* 
 The coefficient for age is 0.4888 with a standard error of 0.0135. 
 The Wald chi-square test has a p-value less than 0.0001, 
 indicating that the coefficient for age is statistically significant.
 Odds ratio estimates for the predictor variable age is 1.630, 
 with 95% confidence limits of 1.588 and 1.674. 
 This indicates that for a one-unit increase in age, 
 the odds of readmission increase by approximately 63%, holding all other variables constant.*/

/*
 The coefficient for bmi is 0.00318 with a standard error of 0.0143. 
 The Wald chi-square test has a p-value is 0.0490, 
 indicating that the coefficient for bmi is not statistically significant.
 Odds ratio estimates for the predictor variable bmi is 1.003, 
 with 95% confidence limits of 0.975 and 1.032. 
 This indicates that for a one-unit increase in bmi, 
 the odds of readmission increase by approximately 0.3%, holding all other variables constant.*/
*/

/* 
 The note indicates that the parameter for the variable "female" has been set to 0 
 because it's a linear combination of other variables, specifically the intercept. 
 This suggests that the variable "female" does not provide additional information 
 beyond what is captured by the intercept.*/
 
/* 
 The coefficient for comorbidity_index is 0.0173 with a standard error of 0.0259. 
 The Wald chi-square test has a p-value 0.4483, 
 indicating that the coefficient for comorbidity_index is not statistically significant.
 Odds ratio estimates for the predictor variable comorbidity_index is 1.017, 
 with 95% confidence limits of 0.967 and 1.070. 
 This indicates that for a one-unit increase in comorbidity_index, 
 the odds of readmission increase by a factor of 1.017, 
 but the confidence interval includes 1, suggesting that the effect is not statistically significant.*/

/* 
 The coefficient for charges is 2.165E-6 with a standard error of 1.514E-6. 
 The Wald chi-square test has a p-value 0.1526, 
 indicating that the coefficient for bmi is not statistically significant.
 Odds ratio estimates for the predictor variable bmi is 1.000, 
 with 95% confidence limits of 1.000. 
 This indicates that for a one-unit increase in charges, 
 the odds of readmission increase by a factor of 1.000, 
 but the confidence interval includes 1, suggesting that the effect is not statistically significant.*/


/****************************************************************
Do a ttest to compare numeric variables between treatment

The pooled estimator of variance is a weighted average of the two sample
variances, with more weight given to the larger sample;
Satterthwaite is an alternative to the pooled-variance t test and is used when
the assumption that the two populations have equal variances seems unreasonable. 
there is equality of variance (Pr>F is greater than 0.05), we consider pooled t statistics, 
which concludes that the means are no different (Pr>|t| is greater than 0.05)
*****************************************************************/
proc ttest data=study;
    class rx;
    var age bmi charges;
run;

/*
Age:
Based on the two-sample t-test, there is a small, non-significant difference in mean ages between the two groups. 
Group 2 (rx=2) has a slightly higher mean age compared to Group 1 (rx=1), 
but this difference is not statistically significant. 
Additionally, the assumption of equal variances between the two groups is met. 
Therefore, we do not have sufficient evidence to conclude that there is a significant difference in age between the two treatment groups.

BMI:
Based on the two-sample t-test, there is no statistically significant difference in mean BMI between the two groups. 
Both the Pooled and Satterthwaite methods yield similar results, 
indicating that the observed difference in mean BMI could likely be due to random chance. 
Additionally, the assumption of equal variances between the two groups is met. 
Therefore, we do not have sufficient evidence to conclude that there is a significant difference in BMI between the two treatment groups.

charges:
Based on the two-sample t-test, there is a statistically significant difference in mean charges between the two groups. 
Both the Pooled and Satterthwaite methods yield similar results, 
indicating that the observed difference in mean charges is unlikely to be due to random chance. 
Additionally, the assumption of equal variances between the two groups is violated. 
Therefore, we have sufficient evidence to conclude that there is a significant difference in charges between the two treatment groups.
*/

/********************************************************************
Do a chi sq test to compare categorical variable(s) between treatment
********************************************************************/
proc freq data=study;
    tables rx*female rx*comorbidity_index rx*readmission / chisq;
run;
/*
Table of rx by female:
This table shows the distribution of treatment groups (rx) among females.
From the "Row Pct" column, it appears that around 13% of females belong to treatment group 1(placebo), 
while around 87% belong to treatment group 2(drug). 

Table of rx by comorbidity_index:
This table shows the distribution of treatment groups (rx) across different levels of comorbidity index.
The "Row Pct" column shows the percentage of each comorbidity index level within each treatment group. 
For example, within treatment group 1 (placebo), around 6% have a comorbidity index of 2, 
while around 34% have an index of 5.
The "Col Pct" column shows the proportion of each treatment group within each comorbidity index level.
The chi-square test statistics indicate whether there is a significant association between treatment groups and comorbidity index. 
In this case, with a p-value of 0.8609, there's no significant association.

Table of rx by readmission:
This table shows the distribution of treatment groups (rx) among readmission outcomes (0 or 1).
The "Row Pct" column shows the percentage of each readmission outcome within each treatment group. 
For example, within treatment group 1, around 89% have a readmission outcome of 0, 
while around 11% have an outcome of 1.
The chi-square test statistics indicate whether there is a significant association between treatment groups and readmission. 
In this case, with a p-value of 0.4812, there's no significant association.
The Fisher's Exact Test provides an alternative test for independence between treatment groups and readmission.
*/

/*****Do a propensity score matching 1:1 that on age, 
bmi, female and comorbidity_index for treatment group to reduce the effects of 
confounding variables when estimating the treatment effect of an intervention*****/

proc logistic data=study;
class female comorbidity_index;
model rx(event='2') = age bmi female comorbidity_index;
output out=pscore p=p_1;
run;

ods graphics on;
proc psmatch data=pscore region=treated;
   class rx female comorbidity_index;
   psmodel rx(Treated='2')= age bmi female comorbidity_index;
   match distance=lps method=greedy(k=1) exact=female caliper=0.5
         weight=none;
   assess lps var=(age bmi female comorbidity_index)
          / stddev=pooled(allobs=no) stdbinvar=no plots(nodetails)=all;
   output out(obs=match)=OutEx4 matchid=_MatchID;
run;

proc sort data=OutEx4;
by _MatchID;
run;
/*
The DISTANCE=LPS option (which is the default) requests that the logit of the propensity score 
be used in computing differences between pairs of observations.
The METHOD=GREEDY(K=1) option requests greedy nearest neighbor matching in which one control unit 
is matched with each unit in the treated group.
PLOTS=ALL, the PSMATCH procedure creates all applicable plots The CALIPER=0.5 option specifies 
the caliper requirement for matching. Units are matched only if the difference in the logits of 
the propensity scores for pairs of units from the two groups is less than or equal to 0.5 times 
the pooled estimate of the standard deviation.
By default, the output data set includes the variable PS (which provides the propensity score) 
and the variable MATCHWGT (which provides matched observation weights). 
The MATCHID=_MatchID option creates a variable named _MatchID 
that identifies the matched sets of observations.
*/
/*
Propensity score methodology can design observational studies in an analogous way compared with 
the way randomised clinical trials are designed: without involving outcome variables 

However, regression analysis uses the outcome as a left-hand-side variable, which is not supposed to 
be available during randomisation.
*/

/***********************************************************
Use the PS matched 1:1 data and repeat the above step 1-3, 
*****************************************************/

%macro regression(var);
proc logistic data=OutEx4;
 model readmission = &var;
run;
%mend;

%regression(rx);
%regression(age);
%regression(bmi);
%regression(female);
%regression(comorbidity_index);
%regression(charges);

proc ttest data=OutEx4;
    class rx;
    var age bmi charges;
run;

proc freq data=OutEx4;
    tables rx*female rx*comorbidity_index rx*readmission / chisq;
run;

/*
Difference in variables between treatment group is smaller after matching
*/
/****Merge the PS matched dataset from step 5 with survival.df on id, 
name the merged file “merged_1”
*********************************/
proc import datafile="/home/u63057552/SAS/my library/Final Project/survival.df.csv"
	DBMS=CSV
	OUT=survival;
RUN;

proc sort data=OutEx4;
by id;
run;

proc sort data=survival;
by id;
run;

data merged_1;
   merge OutEx4 survival;
   by id;
run;


/******
Merge the PS matched dataset from step 5 with survival.df on id, 
and subset to only include comorbidity_index in severe or moderate categories, 
name the merged file “merged_2”***********/
data merged_2;
SET merged_1;
IF comorbidity_index > 2;
run;


/***********************************************
Run a proc lifetest and populate the following curves (3pt)
KM curve for the whole group
KM curves between gender
KM curve between treatment
*****************************/
/*Change the Data type of status from character to numeric, so we can run KM curve*/
data merged_1;
set merged_1;
IF status='FALSE' then status=0;
else if status='TRUE' then status=1;
run;

data merged_1;
set merged_1;
status1=input(status, 5.);
drop status;
rename status1=status;
run;
/**KM curve for the whole group**/
proc lifetest data=merged_1
plots=survival(atrisk cb test);
time time*status(0);
run;

data merged_2;
set merged_2;
IF status='FALSE' then status=0;
else if status='TRUE' then status=1;
run;

data merged_2;
set merged_2;
status1=input(status, 5.);
drop status;
rename status1=status;
run;

proc lifetest data=merged_2
plots=survival(atrisk cb test);
time time*status(0);
run;

/*KM curves between gender*/
proc lifetest data=merged_1
plots=survival(atrisk cb test);
time time*status(0);
strata female;
run;

proc lifetest data=merged_2
plots=survival(atrisk cb test);
time time*status(0);
strata female;
run;

/*KM curve between treatment*/
proc lifetest data=merged_1
plots=survival(atrisk cb test);
time time*status(0);
strata rx;
run;

proc lifetest data=merged_2
plots=survival(atrisk cb test);
time time*status(0);
strata rx;
run;


/*******************************************
Run a cox ph model on time to death (time variable) 
controlling for age, female, treatment
*******************************************/
ods select all;
  PROC PHREG data=merged_1 plots=survival;
  class female(ref='1');
  model time*status(0)= age female rx;
  run;
  
 ods select all;
  PROC PHREG data=merged_2 plots=survival;
  class female(ref='1');
  model time*status(0)= age female rx;
  run;
  
/*
where we determine the effects of a categorical predictor, gender and treatment, 
and a continuous predictor, age on the hazard rate:
PROC LIFETEST is a nonparametric procedure for estimating the dis- tribution of survival time 
and testing the association of survival time with other vari- ables. 
PROC LIFEREG and PROC PHREG are regression procedures for modeling the distribution of 
survival time with a set of concomitant variables.
*/  
  /***********
  Read in the social_characteristics.csv file, do the following data cleaning steps
  *********************************************************/
proc import datafile="/home/u63057552/SAS/my library/Final Project/social_characteristics.csv" out=social replace dbms=csv;
run;

/*****Remove first row*********/
data social;
   set social;
   if _N_ > 1 then output; 
run;

/****Substring GEO_ID to keep only characters after US 
(for example: 1400000US42001030101 – > 42001030101) 
and keep that to a new column called “tract”
************************************************/
data social;
   set social;
   tract = substr(GEO_ID, length("1400000US")+1); 
run;

/******
Clean up name column separate them into columns by “,”
*******************************************************/
data social;
   set social;
Name1=scan(NAME,1,",");
Name2=scan(NAME,2,",");
Name3=scan(NAME,3,",");
RUN;

/****
We will subset this social_characteristics data, we will keep GEO_ID 
and variables in the column “variable” from data_dictionary_include.csv that 
start with prefix”DP02” and include column =“x” */
FILENAME dict '/home/u63057552/SAS/my library/Final Project/data_dictionary_include.csv';

PROC IMPORT DATAFILE=dict
	DBMS=CSV
	OUT=dict;
	GETNAMES=YES;
RUN;

PROC SQL;
SELECT variable
FROM dict
WHERE variable LIKE "DP02%" AND include LIKE "x";
QUIT;
/*The variable are: 
DP02_0011PE
DP02_0044PE
DP02_0066PE
DP02_0067PE
DP02_0069PE
DP02_0092PE
DP02_0112PE
DP02_0151PE
DP02_0152PE
*/
DATA social_subset;
SET social;
KEEP GEO_ID DP02_0011PE DP02_0044PE DP02_0066PE DP02_0067PE DP02_0069PE DP02_0092PE DP02_0112PE DP02_0151PE DP02_0152PE tract;
RUN;

/*****Use the tract variable 
to merge the subsetted social_characteristics file with the merged_1 file.
****************************/
/*Since the datatype of tract is different in two dataset, 
I convert the datatype of tract in social_subset to numeric*/
data social_subset;
set social_subset;
tract1=input(tract, 30.);
drop tract;
rename tract1=tract;
run;

proc sort data=social_subset;
by tract;
run;

proc sort data=merged_1;
by tract;
run;


data merged_social;
   merge social_subset merged_1;
   by tract;
run;



/***Run a linear regression on los controlling for all the DP02 variables, 
rx, age, female, charge*****/
/*Change the DP02 into numeric*/
data merged_social;
   set merged_social;
   DP02_0011PE_num = input(DP02_0011PE, ??best12.);
   DP02_0044PE_num = input(DP02_0044PE, ??best12.);
   DP02_0066PE_num = input(DP02_0066PE, ??best12.);
   DP02_0067PE_num = input(DP02_0067PE, ??best12.);
   DP02_0069PE_num = input(DP02_0069PE, ??best12.);
   DP02_0092PE_num = input(DP02_0092PE, ??best12.);
   DP02_0112PE_num = input(DP02_0112PE, ??best12.);
   DP02_0151PE_num = input(DP02_0151PE, ??best12.);
   DP02_0152PE_num = input(DP02_0152PE, ??best12.);
run;

PROC REG DATA=merged_social;
    MODEL los =  DP02_0011PE_num DP02_0044PE_num DP02_0066PE_num DP02_0067PE_num DP02_0069PE_num DP02_0092PE_num DP02_0112PE_num DP02_0151PE_num DP02_0152PE_num  rx age female charges;
RUN;

/*Use proc sql to summary by tract, what’s the mean age, 
mean of each DP variables, sum of all the DP variables, 
and order by sum of all the DP variables and show only the top 10 tract.*/
PROC SQL outobs=10;
SELECT tract,
MEAN(age) as mean_age,
MEAN(DP02_0011PE_num) as mean_DP02_0011PE,
MEAN(DP02_0044PE_num) as mean_DP02_0044PE,
MEAN(DP02_0066PE_num) as mean_DP02_0066PE,
MEAN(DP02_0067PE_num) as mean_DP02_0067PE,
MEAN(DP02_0069PE_num) as mean_DP02_0069PE,
MEAN(DP02_0092PE_num) as mean_DP02_0092PE,
MEAN(DP02_0112PE_num) as mean_DP02_0112PE,
MEAN(DP02_0151PE_num) as mean_DP02_0151PE,
MEAN(DP02_0152PE_num) as mean_DP02_0152PE,
SUM(DP02_0011PE_num+DP02_0044PE_num+DP02_0066PE_num+DP02_0067PE_num+DP02_0069PE_num+DP02_0092PE_num+DP02_0112PE_num+DP02_0151PE_num+DP02_0152PE_num) as sum_DP02
FROM merged_social
GROUP BY tract
ORDER BY sum_DP02 desc;
QUIT;

/* Output: Generate summary report */
ods pdf close;
