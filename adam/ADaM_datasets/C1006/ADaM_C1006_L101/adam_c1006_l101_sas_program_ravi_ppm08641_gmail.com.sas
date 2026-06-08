* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: ADaM_C1006_L101;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.ADaM\ADaM_C1006\ADaM_C1006_L101\ADaM_C1006_L101;

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

   if visit="SCREEN" then do; avisit="Screening"; avisitn=-1; end;
   else do; avisit=propcase(visit); avisitn=visitnum; end;
   format adt date9.;
run;

/*=========================================================
Fetch the treatment start date into vital signs dataset for comparison of dates
=========================================================*/
data adsl01;
   set adsl;
   keep usubjid trtsdt;
run;

proc sort data=vs01;
   by usubjid paramn adt;
run;

proc sort data=adsl01;
   by usubjid;
run;

data vs02;
   merge vs01(in=a) adsl01(in=b);
   by usubjid;
   if a and b;
run;

/*=========================================================
Derive the baseline flag
=========================================================*/

/*----------------------------------------------------------
Subset the records with non-missing result which are on or before treatment start
Create ABLFL variable by assiging a value of "Y" on the latest record identified
----------------------------------------------------------*/

proc sort data=vs02 out=base01;
   by usubjid paramn adt visitnum;
   where . lt adt le trtsdt and aval ne .;
run;

data base02;
   set base01;
   by usubjid paramn adt visitnum;
   if last.paramn;
   keep usubjid paramn adt visitnum ablfl;
   ablfl="Y";
run;

/*----------------------------------------------------------
Merge the baseline flag back onto the parent dataset using appropriate by variables
Assign AVISIT/AVISITN with appropriate values as per specification.
----------------------------------------------------------*/
proc sort data=vs02;
   by usubjid paramn adt visitnum;
run;

data vs03;
   merge vs02(in=a) base02(in=b);
   by usubjid paramn adt visitnum;
   if a;
run;

data vs03;
   set vs03;
   if ablfl="Y" then do;
      avisitn=0;
      avisit="Baseline";
   end;
run;

proc sort data=vs03;
   by usubjid paramn adt;
run;

/*=========================================================
Keep only the required variables and order the variables in a logical sequence
=========================================================*/
data output;
   retain usubjid paramn paramcd param adt aval avisit avisitn trtsdt ablfl;
   set vs03;
   keep usubjid paramn paramcd param adt aval avisit avisitn trtsdt ablfl;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;