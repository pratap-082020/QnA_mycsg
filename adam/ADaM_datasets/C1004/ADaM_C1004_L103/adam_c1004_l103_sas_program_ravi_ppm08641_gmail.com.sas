* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: ADaM_C1004_L103;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.ADaM\ADaM_C1004\ADaM_C1004_L103\ADaM_C1004_L103;

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
   if vstestcd="SYSBP" and vspos="SITTING" then paramcd="STSBP";
   else if vstestcd="DIABP" and vspos="SITTING" then paramcd="STDBP";

   param=strip(propcase(vspos))||" "||strip(vstest)||" ("||strip(vsstresu)||")";
   if length(vsdtc) ge 10 then adt=input(substrn(vsdtc,1,10),yymmdd10.);
   aval=vsstresn;
   format adt date9.;
run;

/*=========================================================
Create the new parameter- MAP
=========================================================*/

/*----------------------------------------------------------
Subset the input parameters: STSBP and STDBP
----------------------------------------------------------*/

proc sort data=vs02 out=map01;
   by usubjid adt visitnum visit;
   where paramcd in ("STSBP" "STDBP");
run;

/*----------------------------------------------------------
Transpose the data such that STSBP and STDBP collected at a timepoint are available side by side
----------------------------------------------------------*/

proc transpose data=map01 out=map02(drop=_:);
   by usubjid adt visitnum visit;
   id paramcd;
   var aval;
run;

/*----------------------------------------------------------
Derive AVAL for MAP as (STSBP+2*STDBP)/3
----------------------------------------------------------*/
data map03;
   set map02;
   length paramcd $8 param $200;
   if stsbp ne . and stdbp ne . then do;
      aval=round((stsbp+2*stdbp)/3,0.01);
   end;
   paramcd="STMAP";
   param="Sitting Mean Arterial Pressure (mmHg)";
   paramtyp="DERIVED";
run;

/*=========================================================
Combine the derived paramter records with records of source parameters
=========================================================*/

data vs03;
   set vs02 map03;
   if paramcd="STSBP" then paramn=1;
   else if paramcd="STDBP" then paramn=2;
   else if paramcd="STMAP" then paramn=3;
run;

proc sort data=vs03;
   by usubjid adt paramn paramcd;
run;

/*=========================================================
Keep only the required variables and order the variables in a logical sequence
=========================================================*/

data output;
   retain usubjid paramn paramcd param paramtyp adt aval ;
   set vs03;
   keep usubjid paramn paramcd param adt aval paramtyp;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;