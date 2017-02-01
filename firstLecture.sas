OPTIONS NODATE;

*Main title;
TITLE 'Grade';

* Dataset name is "grades";
DATA grades;
INPUT studID gender $ mt final hw;
DATALINES;
101 M 78 89 90
102 F 60 40 75
103 M 84 90 80
104 F 76 82 87
;

* print the data;
PROC PRINT;
RUN;

* Main TITLE;
TITLE 'GPA';

PROC IMPORT datafile='/folders/myfolders/gpa.txt' out=gpa replace;
delimiter='09'x;
getnames=YES;
datarow=2;
RUN;

*print dataset gpa;
PROC PRINT;
RUN;

TITLE "Descripptive statistics";
PROC MEANS mean std stderr clm min p25 p50 p75 max;
var gpa hsm hse satm sex;
RUN; 

/* creates histogram with normal density plotted on top of histogram;*/
TITLE "Histogram - GPA";
PROC UNIVARIATE normal; 
var gpa; 
histogram / normal(mu=est sigma=est);
RUN;

*Create boxplot for GPS by gender. Always sort it before creating the boxplot;
PROC SORT DATA='/folders/myfolders/gpa.txt'; 
BY sex; 
RUN; 
PROC BOXPLOT;
PLOT gpa*sex ;
RUN;

*----- GET DATA FROM EXTERNAL FILE USING "INFILE"  ----;
* Dataset name is "gpa_infile";
* DELIMITER = '09'x indicates that the data uses tab seperation;
* MISSOVER - ignores if there are any missing records;
* FIRSTOBS - tells which row the data begins;
* If a field is text, use a $ after you specify the field name - e.g gender;
DATA gpa; 
INFILE "/folders/myfolders/gpa.txt" DELIMITER = '09'x MISSOVER FIRSTOBS=2; 
INPUT gpa hsm hse satm sex;
RUN; 

TITLE "Infile Option - GPA";
PROC PRINT data= gpa_infile; 
RUN;