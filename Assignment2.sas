PROC IMPORT datafile='/folders/myfolders/Banking.txt' out=age replace;
delimiter='09'x;
getnames=YES;
datarow=2;
RUN;

TITLE "Descripptive statistics";
PROC MEANS mean std stderr clm min p25 p50 p75 max;
var Balance;
RUN; 

TITLE "Histogram - Balance";
PROC UNIVARIATE normal; 
var Balance; 
histogram / normal(mu=est sigma=est);
RUN;

ods graphics on;
TITLE "Scatter plot - Balance";
proc corr data=age nomiss plots=matrix(histogram);
   var Balance Age Education Income;
run;
ods graphics off;

PROC TTEST data=age sides=2 alpha=0.05 h0=0;
var Balance Age Education Income;
RUN; 

TITLE "Correlation Values";
PROC reg corr;
model Balance = Age Education Income;
plot Balance.*(Age Education Income);
run; quit;

PROC reg corr;
model Balance = Age Income;
plot Balance.*(Age Income);
run; quit;