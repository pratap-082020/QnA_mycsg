* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: ADaM_C1001_L103b;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.ADaM\ADaM_C1001\ADaM_C1001_L103b\ADaM_C1001_L103b;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
Process the data as per specification
=========================================================*/

/*----------------------------------------------------------
Derive the variables only for non screen-failures
----------------------------------------------------------*/

data adsl;
   set dm(in=a) ;
   by usubjid;
   if a;

   if arm ne "Screen Failure" then do;
        trt01p=arm;
        trt01a=actarm;
    end;
    length tr01pg1 tr01ag1 $15.;
    if index(trt01p,"CSG") then tr01pg1="CSG";
    else if index(trt01p,"Placebo") then tr01pg1="Placebo";

    if index(trt01a,"CSG") then tr01ag1="CSG";
    else if index(trt01a,"Placebo") then tr01ag1="Placebo";

run;

/*=========================================================
Keep only the required variables in final dataset
=========================================================*/

data output;
    set adsl;
    keep usubjid arm actarm trt01p trt01a tr01pg1 tr01ag1;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;