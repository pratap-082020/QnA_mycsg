* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: ADaM_C1005_L102;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Read input dataset and create analysis variables which are directly based on SDTM variables
=========================================================*/

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
   if visit="SCREEN" then avisit="Screening";
   else avisit=propcase(visit);
   format adt date9.;
run;

/*=========================================================
Derive average value record
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
Average of all values across postbaseline and append it back to full data
----------------------------------------------------------*/

proc sort data=vs02 out=avg01;
   by usubjid paramn aval adt;
   where adt gt trtsdt gt . and aval ne .;
run;

proc means data=avg01 noprint;
   by usubjid paramn paramcd param trtsdt;
   var aval;
   output out=avg02 mean=mean;
run;

data avg03;
   set avg02;
   length avisit $50;
   aval=round(mean,0.01);
   avisitn=100;
   avisit="Average of all postbaseline values";
   dtype="AVERAGE";
run;

data vs03;
   set vs02(in=a) avg03(in=b);
run;

proc sort data=vs03;
    by usubjid paramn avisitn adt;
run;

/*=========================================================
Keep only the required variables and order the variables in a logical sequence
=========================================================*/
data output;
   retain usubjid paramn paramcd param avisitn avisit adt aval dtype trtsdt;
   set vs03;
   keep usubjid paramn paramcd param avisitn avisit adt aval dtype trtsdt;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;