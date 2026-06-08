* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: ADaM_C1002_L102;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.ADaM\ADaM_C1002\ADaM_C1002_L102\ADaM_C1002_L102;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
Read input datasets
=========================================================*/

data cm01;
   set cm;
run;

/*=========================================================
Create ASTDT and ASTDTF variables
=========================================================*/

data cm02;
   set cm01;

   if length(cmstdtc)=10 then astdt=input(cmstdtc,yymmdd10.);
   else if length(cmstdtc)=7 then do;
      astdt=input(catx("-",cmstdtc,"01"),yymmdd10.);
      astdtf="D";
   end;
   else if length(cmstdtc)=4 then do;
      astdt=input(catx("-",cmstdtc,"01","01"),yymmdd10.);
      astdtf="M";
   end;
   format astdt date9.;
run;

/*=========================================================
Keep only the required variables and order the variables in a logical sequence
=========================================================*/

data output;
   retain usubjid cmstdtc astdt astdtf;
   set cm02;
   keep usubjid cmstdtc astdt astdtf;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;