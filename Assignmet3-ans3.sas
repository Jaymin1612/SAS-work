*Creating dummy variables;
data HouseSales;
infile '/folders/myfolders/HouseSales.txt' delimiter='09'X MISSOVER;
input Region $ Type $ Price Cost;
numregion = (Region="M");
numtype = (Type="SF");
run;
proc print;
run;

proc corr;
var Price Cost numregion numtype;
run;

*Model-1; 
proc reg;
model Price = Cost numregion numtype;
run;

*Model-2 remove numregion;
proc reg;
model Price = Cost numtype;
run;

*Model-3 remove numtype;
proc reg;
model Price = Cost;
run;

proc corr;
var Price numtype;
run;

proc reg;
model Price = numregion;
run;