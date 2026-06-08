* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: ADaM_C1002_L101;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.ADaM\ADaM_C1002\ADaM_C1002_L101\ADaM_C1002_L101;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
Read input data
=========================================================*/

data ae01;
   set ae;
run;

/*=========================================================
Create ASTDT, ASTTM, ASTDTM variables
=========================================================*/

data ae02;
   set ae01;

   if length(aestdtc) ge 16 then do;
      astdt=input(substrn(aestdtc,1,10),?? yymmdd10.);
      asttm=input(scan(aestdtc,2,'T'),time8.);
      astdtm=input(aestdtc,is8601dt19.);
   end;
   else if length(aestdtc) ge 10 then do;
      astdt=input(substrn(aestdtc,1,10),?? yymmdd10.);
   end;

   format astdt date9. asttm time8. astdtm datetime20.;
run;

/*=========================================================
Keep required variables and order the variables in a logical sequence
=========================================================*/

data output;
   retain usubjid aestdtc astdt asttm astdtm;
   set ae02;
   keep usubjid aestdtc astdt asttm astdtm;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;