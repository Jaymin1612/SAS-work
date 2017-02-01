PROC IMPORT datafile='/folders/myfolders/Banking.txt' out=age replace;
delimiter='09'x;
getnames=YES;
datarow=2;
RUN;

proc reg;
model balance = Age Education Income;

plot balance.*( Age Education Income );

plot balance.*predicted.;

plot npp.*balance.;
run;