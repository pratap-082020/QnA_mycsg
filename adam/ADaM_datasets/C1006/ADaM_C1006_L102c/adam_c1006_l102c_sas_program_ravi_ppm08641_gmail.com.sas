* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: ADaM_C1006_L102c;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.ADaM\ADaM_C1006\ADaM_C1006_L102c\ADaM_C1006_L102c;

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
   else if vstestcd="WEIGHT" then do; paramcd=vstestcd; paramn=3; end;

   if vstestcd ne "WEIGHT" then do;
      param=strip(propcase(vspos))||" "||strip(vstest)||" ("||strip(vsstresu)||")";
   end;
   else param=strip(vstest)||" ("||strip(vsstresu)||")";

   if length(vsdtc) ge 10 then adt=input(substrn(vsdtc,1,10),yymmdd10.);
   aval=vsstresn;
   length avisit $50;
   avisitn=visitnum;
   if visit="SCREEN" then avisit="Screening";
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
Derive the baseline flag
=========================================================*/

/*----------------------------------------------------------
Subset the records with non-missing result which are on or before treatment start
Process the data such the minimum record is picked for SYSBP and maximum record is 
picked for DIABP, and the closest record is picked for WEIGHT.
----------------------------------------------------------*/

data base01;
   set vs02;
   where . lt adt le trtsdt and aval ne .;
   if paramn=1 then aval2=aval*-1;
   else if paramn=2 then aval2=aval;
   else if paramn=3 then aval2=1;
run;

proc sort data=base01;
   by usubjid paramn aval2 adt visitnum;
run;

data base02;
   set base01;
   by usubjid paramn aval2 adt visitnum;
   if last.paramn;
   keep usubjid paramn adt visitnum ablfl aval;
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
   merge vs02(in=a) base02(in=b drop=aval);
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
Deriving base, chg, and pchg variables
=========================================================*/

proc sort data=vs03;
   by usubjid paramn;
run;

proc sort data=base02;
   by usubjid paramn;
run;

data vs04;
   merge vs03(in=a) base02(in=b keep=usubjid paramn aval rename=(aval=base));
   by usubjid paramn;
run;

data vs05;
   set vs04;
   length basetype $10;
   if paramn=2 then basetype="MAXIMUM";
   else if paramn=1 then basetype="MINIMUM";
   else if paramn=3 then basetype="ORIGINAL";

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
   retain usubjid basetype paramn paramcd param avisitn avisit adt aval base chg pchg trtsdt ablfl;
   set vs05;
   keep usubjid paramn paramcd param avisitn avisit adt aval base chg pchg trtsdt ablfl basetype;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;