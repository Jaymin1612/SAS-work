*Importing data;

PROC IMPORT datafile='/folders/myfolders/Bankingfull.txt' out=bank replace;
	delimiter='09'x;
	getnames=YES;
	datarow=2;
RUN;

ods graphics on;
title 'Scatter Plot: Balance to other variables';

proc corr data=bank nomiss plots=matrix(nvar=all);
	var Balance Age Education Income HomeVal Wealth;
run;

Title "Correlation";
proc corr;
var Balance Age Education Income HomeVal Wealth;
RUN;

TITLE "Multicollinearity";
PROC CORR data=bank;
 var Balance Age Education Income HomeVal Wealth;
RUN;

TITLE "VIF model 1";
PROC REG;
MODEL Balance = Age Education Income HomeVal Wealth / VIF;
RUN;

TITLE "VIF Model 2";
PROC REG;
MODEL Balance = Age Education HomeVal Wealth / VIF;
RUN;

TITLE "Outliers and influence points";
PROC REG;
MODEL Balance = Age Education HomeVal Wealth / INFLUENCE R;
plot student.*(Age Education HomeVal Wealth predicted.);
plot npp.*student;

TITLE "::Standardized Estimates::";
PROC REG;
MODEL Balance = Age Education HomeVal Wealth / STB;
RUN;
QUIT;