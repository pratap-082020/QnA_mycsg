* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: ADaM_C1004_L103a;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.ADaM\ADaM_C1004\ADaM_C1004_L103a\ADaM_C1004_L103a;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
Read input datasets
=========================================================*/

data vs01;
   set vs;
run;

data dm01;
   set dm;
run;

/*=========================================================
Create variables and parameters which are directly based on source records
=========================================================*/

data vs02;
   set vs01;
   length paramcd $8 param $200;
   paramcd=vstestcd;
   param=strip(vstest)||" ("||strip(vsstresu)||")";
   if length(vsdtc) ge 10 then adt=input(substrn(vsdtc,1,10),yymmdd10.);
   aval=vsstresn;
   format adt date9.;
run;

/*=========================================================
Create the new parameter- BMI
=========================================================*/
proc sort data=vs02 out=hgt01(keep=usubjid aval rename=(aval=height));
   by usubjid adt visitnum visit;
   where paramcd in ("HEIGHT");
run;

data bmi03;
   merge vs02(in=a where=(paramcd="WEIGHT") rename=(aval=weight)) hgt01(in=b);
   by usubjid;
   length paramcd $8 param $200 paramtyp $7;
   if height ne . and weight ne . then aval=round(weight/((height/100)**2),0.01);
   paramcd="BMI";
   param="Body Mass Index (kg/m2)";
   paramtyp="DERIVED";
run;

/*=========================================================
Combine the derived paramter records with records of source parameters
=========================================================*/

data vs03;
   set vs02 bmi03;
run;

proc sort data=vs03;
   by usubjid paramcd adt;
run;

/*=========================================================
Keep only the required variables and order the variables in a logical sequence
=========================================================*/

data output;
   retain usubjid paramcd param adt aval;
   set vs03;
   keep usubjid paramcd param adt aval;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;