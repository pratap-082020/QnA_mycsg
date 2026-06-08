* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: ADaM_C1003_L101;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.ADaM\ADaM_C1003\ADaM_C1003_L101\ADaM_C1003_L101;

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
   format trtsdt date9.;
run;

/*=========================================================
Create ASTDT, AENDT and TRTEMFL variables
=========================================================*/

data ae02;
   set ae01;
   if length(aestdtc)=10 then astdt=input(aestdtc,yymmdd10.);
   if length(aeendtc)=10 then aendt=input(aeendtc,yymmdd10.);
   format astdt aendt date9.;

   if astdt ge trtsdt gt . then trtemfl="Y";
   else trtemfl="N";
run;

/*=========================================================
Keep only required variables and order the variables in a logical sequence
=========================================================*/
data output;
   retain usubjid aedecod astdt aendt trtemfl trtsdt aestdtc aeendtc;
   set ae02;
   keep usubjid aedecod astdt aendt trtemfl trtsdt aestdtc aeendtc;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;