*import data from file;
proc import datafile="/folders/myfolders/pgatour2006.csv" out=myd replace;
delimiter=',';
getnames=yes;
run;

ODS GRAPHICS ON;
TITLE "Scatter Plot: PrizeMoney to Others";
PROC CORR DATA=myd NOMISS PLOTS(MAXPOINTS= NONE)=matrix(HISTOGRAM NVAR=ALL);
VAR PrizeMoney DrivingAccuracy GIR PuttingAverage BirdieConversion PuttsPerRound;
RUN;
ODS GRAPHICS OFF;

TITLE "Distribution of PrizeMoney (Histogram)";
PROC UNIVARIATE DATA=myd NOPRINT;
HISTOGRAM PrizeMoney / NORMAL;
RUN;

TITLE "Log Transformation of PrizeMoney.";
DATA myd_new;
SET myd;
ln_prize = log(PrizeMoney);
RUN;

TITLE "Distribution of ln_prize: (Histogram)";
PROC UNIVARIATE DATA=myd_new NOPRINT;
HISTOGRAM ln_prize / NORMAL;
RUN;

TITLE "Fit regression: Model 1";
PROC REG;
MODEL ln_prize = DrivingAccuracy GIR PuttingAverage BirdieConversion PuttsPerRound;
RUN;

*Remove DrivingAccuracy from the model;
TITLE "Fit regression: Model 2";
PROC REG;
MODEL ln_prize = GIR PuttingAverage BirdieConversion PuttsPerRound;
RUN;

*Remove PuttingAverage from the model;
TITLE "Fit regression: Model 3";
PROC REG;
MODEL ln_prize = GIR BirdieConversion PuttsPerRound;
RUN;

TITLE "Outliers and influence points";
PROC REG;
MODEL ln_prize = GIR BirdieConversion PuttsPerRound / INFLUENCE R;
RUN;

*Coefficient for final model;
PROC REG;
MODEL ln_prize = GIR BirdieConversion PuttsPerRound;
RUN;

TITLE "1% increase in GIR";
DATA myd_new_gir;
SET myd_new;
inc_gir = GIR + 1;
RUN;

*Coefficients for increased GIR;
PROC REG;
MODEL ln_prize = inc_gir BirdieConversion PuttsPerRound;
RUN; 