* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: ADaM_C1005_L101b;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.ADaM\ADaM_C1005\ADaM_C1005_L101b\ADaM_C1005_L101b;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

options validvarname=upcase;

/*=========================================================
Read input dataset and create analysis variables which are directly based on SDTM variables
=========================================================*/
/*----------------------------------------------------------
PARAMCD
PARAM
PARAMN
ADT
AVAL
AVISIT
AVISITN
----------------------------------------------------------*/
data vs01;
   set vs;
   length paramcd $8 param $200;
   if vstestcd="SYSBP" and vspos="SITTING" then do; paramcd="STSBP"; paramn=1; end;
   else if vstestcd="DIABP" and vspos="SITTING" then do; paramcd="STDBP"; paramn=2; end;

   param=strip(propcase(vspos))||" "||strip(vstest)||" ("||strip(vsstresu)||")";
   if length(vsdtc) ge 10 then adt=input(substrn(vsdtc,1,10),yymmdd10.);
   aval=vsstresn;
   length avisit $30;
   avisitn=visitnum;
   if visit="SCREEN" then avisit="Screening";
   else avisit=propcase(visit);
   format adt date9.;
run;

/*=========================================================
Separate minimum value record and maximum value record
=========================================================*/

/*----------------------------------------------------------
Fetch the reference start date from SDTM.DM as treatment start date
----------------------------------------------------------*/
data dm01;
   set dm;
   if length(rfstdtc) ge 10 then trtsdt=input(substrn(rfstdtc,1,10),??yymmdd10.);
   keep usubjid trtsdt;
   format trtsdt date9.;
run;

proc sort data=vs01;
   by usubjid paramn adt;
run;

proc sort data=dm01;
   by usubjid;
run;

data vs02;
   merge vs01(in=a) dm01(in=b);
   by usubjid;
   if a and b;
run;

/*----------------------------------------------------------
Identify the record with minimum result across postbaseline rows
----------------------------------------------------------*/
proc sort data=vs02 out=min01;
   by usubjid paramn aval adt;
   where adt gt trtsdt gt . and aval ne .;
run;

data min02;
   set min01;
   by usubjid paramn aval adt;
   if first.paramn;
   avisitn=98;
   avisit="Minimum value postbaseline";
   dtype="MINIMUM";
run;

/*----------------------------------------------------------
Identify the record with maximum result across postbaseline rows
----------------------------------------------------------*/
proc sort data=vs02 out=max01;
   by usubjid paramn aval descending adt;
   where adt gt trtsdt gt . and aval ne .;
run;

data max02;
   set max01;
   by usubjid paramn aval descending adt;
   if last.paramn;
   avisitn=99;
   avisit="Maximum value postbaseline";
   dtype="MAXIMUM";
run;

/*=========================================================
Combine the minimum and maximum records to parent records
=========================================================*/

data vs03;
   set vs02(in=a) min02(in=b) max02;
run;

proc sort data=vs03;
   by usubjid paramn avisitn adt;
run;

/*=========================================================
Keep only the required variables and order the variables in a logical sequence
=========================================================*/
data output;
   retain usubjid paramn paramcd param avisitn avisit adt aval dtype trtsdt visitnum visit;
   set vs03;
   keep usubjid paramn paramcd param avisitn avisit adt aval dtype trtsdt visitnum visit;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;