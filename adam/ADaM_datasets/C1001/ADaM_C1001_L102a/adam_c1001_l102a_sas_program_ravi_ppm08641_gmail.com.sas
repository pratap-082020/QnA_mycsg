* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: ADaM_C1001_L102a;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.ADaM\ADaM_C1001\ADaM_C1001_L102a\ADaM_C1001_L102a;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
Processing for TRTSDT
=========================================================*/

proc sort data=ex out=trtsdt01;
    by usubjid exstdtc;
    where EXCAT="TREATMENT PERIOD" and not missing(EXSTDTC);
run;

data trtsdt;
    set trtsdt01;
    by usubjid exstdtc;
    if first.usubjid;
    if not missing(exstdtc) then trtsdt=input(substrn(exstdtc,1,10),yymmdd10.);
    format trtsdt yymmdd10.;
    keep usubjid trtsdt;
run;

/*=========================================================
Processing for TRTEDT
=========================================================*/

proc sort data=ex out=TRTEDT01;
    by usubjid EXENDTC;
    where EXCAT="TREATMENT PERIOD" and not missing(EXENDTC);
run;

data TRTEDT;
    set TRTEDT01;
    by usubjid EXENDTC;
    if last.usubjid;
    if not missing(EXENDTC) then TRTEDT=input(substrn(EXENDTC,1,10),yymmdd10.);
    format TRTEDT yymmdd10.;
    keep usubjid TRTEDT;
run;

/*=========================================================
Processing Drug Accountability data
=========================================================*/

/*----------------------------------------------------------
Get the the number doses dispensed
----------------------------------------------------------*/

proc sort data=da out=disp01(rename=(dastresn=dispamt) keep=usubjid dastresn);
    by usubjid;
    where visitnum=2 and datestcd="DISPAMT";
run;

/*----------------------------------------------------------
Get the the number doses returned
----------------------------------------------------------*/

proc sort data=da out=ret01(rename=(dastresn=retamt) keep=usubjid dastresn);
    by usubjid;
    where visitnum=3 and datestcd="RETAMT";
run;

/*----------------------------------------------------------
Get the the number doses taken
----------------------------------------------------------*/

data taken;
    merge disp01(in=a) ret01(in=b);
    by usubjid;
    taken=dispamt-retamt;
    if taken gt 0;
    keep usubjid;
run;

/*=========================================================
Process all datasets to create final variables
=========================================================*/
data adsl;
    merge dm(in=a) trtsdt trtedt taken(in=d);
    by usubjid;
    if a;
    if trtsdt ne . then saffl="Y";
    else saffl="N";
    if trtsdt ne . and d then saf2fl="Y";
    else saf2fl="N";
run;

/*=========================================================
Keep required variables only in the final dataset
=========================================================*/

data output;
    set adsl;
    keep usubjid trtsdt trtedt saffl saf2fl;
run;

data output;
    set adsl;
    keep usubjid trtsdt trtedt saffl saf2fl;
run;

data csg_formoutput;
    set adsl;
    call missing(trtsdt,trtedt,saffl,saf2fl);
    keep usubjid trtsdt trtedt saffl saf2fl;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;