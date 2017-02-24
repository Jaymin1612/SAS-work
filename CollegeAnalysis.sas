*Importing data;
PROC IMPORT datafile='/folders/myfolders/College.csv' out=college replace;
	getnames=YES;
	datarow=2;
RUN;

*Creating dummy variables;
data college;
infile '/folders/myfolders/College.csv' delimiter=",";
input school $ Private $ Accept_pct Elite10 F_Undergrad P_Undergrad Outstate Room_Board Books Personal PhD Terminal S_F_Ration perc_alumni Expend Grad_Rate;
*We will require only one dummy variable here for Private.;
numPrivate = (Private = 'Yes');
PROC PRINT;
run;

*Analysing the distribution of Grad_Rate;
PROC UNIVARIATE;
VAR Grad_Rate;
histogram / normal;
run;

*Creating scatter plots;
PROC SGSCATTER data=college;
MATRIX Grad_Rate numPrivate Accept_pct Elite10 F_Undergrad P_Undergrad Outstate Room_Board Books Personal PhD Terminal S_F_Ration perc_alumni Expend Grad_Rate;
RUN;

*Sorting numPrivate;
PROC SORT DATA=college;
BY numPrivate;
RUN;

*Boxplot for Grad_Rate against Private;
TITLE "Boxplot for Grad_Rate vs Private";
PROC BOXPLOT data=college;
PLOT Grad_Rate * numPrivate;
RUN;

*Sorting Elite10;
PROC SORT DATA=college;
BY Elite10;
RUN;

*Boxplot for Grad_Rate against Elite10;
TITLE "Boxplot for Grad_Rate vs Elite";
PROC BOXPLOT data=college;
PLOT Grad_Rate * Elite10;
RUN;

*Predicting model with all independent variables;
PROC REG;
MODEL Grad_Rate = school $ numPrivate Accept_pct Elite10 F_Undergrad P_Undergrad Outstate Room_Board Books Personal PhD Terminal S_F_Ration perc_alumni Expend;
RUN;

*Removing school and Private;
data college;
set college;
drop school;
drop Private;
run;  

*Checking Multicollinearity;
TITLE "Multicollinearity";
PROC CORR data=college;
VAR Accept_pct Elite10 F_Undergrad P_Undergrad Outstate Room_Board Books Personal PhD Terminal S_F_Ration perc_alumni Expend Grad_Rate numPrivate;
RUN;

*Computing VIF values;
TITLE "VIF";
PROC REG;
MODEL Grad_Rate = Accept_pct Elite10 F_Undergrad P_Undergrad Outstate Room_Board Books Personal PhD Terminal S_F_Ration perc_alumni Expend numPrivate / VIF;
RUN;

*MODEL Selection Method : Forward;
PROC REG;
MODEL Grad_Rate = Accept_pct Elite10 F_Undergrad P_Undergrad Outstate Room_Board Books Personal PhD Terminal S_F_Ration perc_alumni Expend numPrivate / SELECTION=forward sle=0.05 sls=0.05;
RUN;

*MODEL Selection Method : Backward;
PROC REG;
MODEL Grad_Rate = Accept_pct Elite10 F_Undergrad P_Undergrad Outstate Room_Board Books Personal PhD Terminal S_F_Ration perc_alumni Expend numPrivate / SELECTION=backward sle=0.05 sls=0.05;
RUN;

*Studentised residual plots & normal probability plots;
PROC REG;
MODEL Grad_Rate = Accept_pct Elite10 F_Undergrad P_Undergrad Outstate Room_Board Books Personal PhD Terminal S_F_Ration perc_alumni Expend numPrivate;
plot student.*(Accept_pct Elite10 F_Undergrad P_Undergrad Outstate Room_Board Books Personal PhD Terminal S_F_Ration perc_alumni Expend numPrivate predicted.);
plot npp.*student;
RUN;

*Outliers and Influential points;
PROC REG;
MODEL Grad_Rate = Accept_pct Elite10 F_Undergrad P_Undergrad Outstate Room_Board Books Personal PhD Terminal S_F_Ration perc_alumni Expend numPrivate / INFLUENCE R;
RUN;

