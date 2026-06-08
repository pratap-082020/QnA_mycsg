* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: ADaM_C1003_L102;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.ADaM\ADaM_C1003\ADaM_C1003_L102\ADaM_C1003_L102;

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
Create ASTDT and AENDT variables
=========================================================*/

data ae02;
   set ae01;
   if length(aestdtc)=10 then astdt=input(aestdtc,yymmdd10.);
   if length(aeendtc)=10 then aendt=input(aeendtc,yymmdd10.);
   format astdt aendt date9.;
run;

/*=========================================================
Get the maximum severity per AEDECOD for the events occurred prior to treatment start
=========================================================*/

proc sort data=ae02 out=base01;
   by usubjid aedecod aesev;
   where . lt astdt lt trtsdt;
run;

data base02;
   set base01;
   by usubjid aedecod aesev;
   if last.aedecod;
   basesev=aesev;
   keep usubjid aedecod basesev;
run;

/*=========================================================
Populate Maximum severity observed for a decod for a subject across all records of that decod of that subject
=========================================================*/

proc sort data=ae02;
   by usubjid aedecod;
run;

data ae03;
   merge ae02(in=a) base02(in=b);
   by usubjid aedecod;
run;

/*=========================================================
Create TRTEMFL variable
=========================================================*/

data ae04;
   set ae03;
   if astdt ge trtsdt gt . then do;
      if basesev="" then trtemfl="Y";
      else if aesev gt basesev then trtemfl="Y";
   end;
   if trtemfl="" then trtemfl="N";
run;

proc sort data=ae04;
    by usubjid aedecod aestdtc;
run;

/*=========================================================
Keep only required variables and order the variables in a logical sequence
=========================================================*/
data output;
   retain usubjid aedecod astdt aendt trtemfl trtsdt aestdtc aeendtc;
   set ae04;
   keep usubjid aedecod astdt aendt trtemfl trtsdt aestdtc aeendtc aesev;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;