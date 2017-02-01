OPTIONS NODATE;

*Main TITLE;
TITLE "vOTING";

PROC IMPORT datafile='/folders/myfolders/voting_1992.txt' out=voting replace;
delimiter='09'x;
getnames=YES;
datarow=2;
RUN;

DATA voting;
INFILE "/folders/myfolders/voting_1992.txt" DELIMITER = '09'x MISSOVER FIRSTOBS=2; 
INPUT County $ Pct_Voted MedianAge MeanSavings Pct_Poverty PopulationDensity Gender $;
RUN; 

TITLE "Infile Voting";
PROC PRINT data= voting; 
RUN;

TITLE "5 point summary";
PROC MEANS min p25 p50 p75 max;
var Pct_Voted MedianAge;
RUN;

TITLE "Histogram for Percent People Voted";
PROC UNIVARIATE normal; 
var Pct_Voted; 
histogram / normal(mu=est sigma=est);
RUN;

PROC SORT DATA=voting; 
BY Gender; 
RUN; 
PROC BOXPLOT;
PLOT Pct_Voted*Gender ;
RUN;

PROC FREQ;
RUN;