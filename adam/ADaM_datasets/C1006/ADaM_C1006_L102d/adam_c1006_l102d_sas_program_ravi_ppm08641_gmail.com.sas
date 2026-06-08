* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: ADaM_C1006_L102d;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.ADaM\ADaM_C1006\ADaM_C1006_L102d\ADaM_C1006_L102d;

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
   length avisit $50;
   avisitn=visitnum;
   if visit="SCREEN 1" then avisit="Screening 1";
   else if visit="SCREEN 2" then avisit="Screening 2";
   else avisit=propcase(visit);
   format adt date9.;
run;

/*=========================================================
Fetch the reference start date from SDTM.DM as treatment start date
=========================================================*/
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

/*=========================================================
Create a new record to hold the average result of screening colelctions and append it to source records
=========================================================*/

/*----------------------------------------------------------
Assign DTYPE, AVISIT, AVISITN, ABLFL with appropriate value on the average record
----------------------------------------------------------*/
data base01;
   set vs02;
   where . lt adt le trtsdt and aval ne .;
run;

proc sort data=base01;
   by usubjid paramn aval adt visitnum;
run;

proc means data=base01 noprint;
   by usubjid paramn paramcd param trtsdt;
   var aval;
   output out=base_mean mean=mean;
run;

data base02;
   set base_mean;
   aval=round(mean,0.01);
   *keep usubjid paramn adt visitnum ablfl base;
   ablfl="Y";
   base=aval;
run;

data vs03;
   set vs02 base02(in=b drop=base);
   if b then do;
      dtype="AVERAGE";
      avisitn=-1;
      avisit="Screening Average";
   end;
run;

proc sort data=vs03;
   by usubjid paramn avisitn;
run;

/*=========================================================
Merge the baseline result back onto the parent dataset using appropriate by variables
Assign AVISIT/AVISITN with appropriate values as per specification.
=========================================================*/

proc sort data=vs03;
   by usubjid paramn;
run;

data vs04;
   merge vs03(in=a) base02(in=b keep=usubjid paramn base);
   by usubjid paramn;
   if a;
run;

data vs04;
   set vs04;
   if ablfl="Y" then do;
      avisitn=0;
      avisit="Baseline";
   end;
run;

proc sort data=vs04;
   by usubjid paramn adt;
run;

/*=========================================================
Deriving base, chg, and pchg variables
=========================================================*/

data vs05;
   set vs04;
  basetype="AVERAGE";

   if adt gt trtsdt gt . then do;
      if aval ne . and base ne . then do;
         chg=aval-base;
         pchg=chg/base*100;
      end;
   end;
run;

proc sort data=vs05;
    by usubjid paramn avisitn adt;
run;

/*=========================================================
Keep only the required variables and order the variables in a logical sequence
=========================================================*/
data output;
   retain usubjid basetype paramn paramcd param avisitn avisit adt aval base chg pchg trtsdt ablfl dtype;
   set vs05;
   keep usubjid paramn paramcd param avisitn avisit adt aval base chg pchg trtsdt ablfl basetype dtype;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;