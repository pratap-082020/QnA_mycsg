* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: ADaM_C1001_L101;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.ADaM\ADaM_C1001\ADaM_C1001_L101\ADaM_C1001_L101;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
RFICDT: Informed Consent Date
=========================================================*/
/*----------------------------------------------------------
Subset the required records
Extract the date portion and convert the date to numeric format
Keep only requried variables
----------------------------------------------------------*/
data RFICDT;
    set ds;
    where DSCAT="PROTOCOL MILESTONE" and DSSCAT="INFORMED CONSENT OBTAINED" and
          DSDECOD="SUBJECT INFORMED CONSENT";
    if not missing(dsstdtc) then RFICDT=input(substrn(dsstdtc,1,10),yymmdd10.);
    format RFICDT date9.;
    keep usubjid RFICDT;
run;

/*=========================================================
RANDDT: Randomization Date
=========================================================*/

/*----------------------------------------------------------
Subset the required records
Extract the date portion and convert the date to numeric format
Keep only requried variables
----------------------------------------------------------*/

data randdt;
    set ds;
    where DSCAT="PROTOCOL MILESTONE" and DSDECOD="RANDOMIZED";
    if not missing(dsstdtc) then randdt=input(substrn(dsstdtc,1,10),yymmdd10.);
    format randdt date9.;
    keep usubjid randdt;
run;

/*=========================================================
TRTSDT: Treatment Start Date
=========================================================*/

/*----------------------------------------------------------
Subset the required records
Sort the records such that the required record comes on top to select using first. approach
Extract the date portion and convert the date to numeric format
Keep only requried variables
----------------------------------------------------------*/

proc sort data=ex out=trtsdt01;
    by usubjid exstdtc;
    where EXCAT="TREATMENT PERIOD" and not missing(EXSTDTC);
run;

data trtsdt;
    set trtsdt01;
    by usubjid exstdtc;
    if first.usubjid;
    if not missing(exstdtc) then trtsdt=input(substrn(exstdtc,1,10),yymmdd10.);
    format trtsdt date9.;
    keep usubjid trtsdt;
run;

/*=========================================================
TRTEDT: Treatment End Date
=========================================================*/

/*----------------------------------------------------------
Subset the required records
Sort the records such that the required record comes at the end to select using last. approach
Extract the date portion and convert the date to numeric format
Keep only requried variables
----------------------------------------------------------*/

proc sort data=ex out=TRTEDT01;
    by usubjid EXENDTC;
    where EXCAT="TREATMENT PERIOD" and not missing(EXENDTC);
run;

data TRTEDT;
    set TRTEDT01;
    by usubjid EXENDTC;
    if last.usubjid;
    if not missing(EXENDTC) then TRTEDT=input(substrn(EXENDTC,1,10),yymmdd10.);
    format TRTEDT date9.;
    keep usubjid TRTEDT;
run;

/*=========================================================
FVISDT: First Visit Date
=========================================================*/

/*----------------------------------------------------------
Subset the required records
Sort the records such that the required record comes on top to select using first. approach
Extract the date portion and convert the date to numeric format
Keep only requried variables
----------------------------------------------------------*/

proc sort data=sv out=fvisdt01;
    by usubjid svstdtc;
    where not missing(svstdtc);
run;

data fvisdt;
    set fvisdt01;
    by usubjid svstdtc;
    if first.usubjid;
    fvisdt=input(substrn(svstdtc,1,10),yymmdd10.);
    format fvisdt date9.;
    keep usubjid fvisdt;
run;

/*=========================================================
LVISDT: Last Visit Date
=========================================================*/

/*----------------------------------------------------------
Subset the required records
Sort the records such that the required record comes at the end to select using last. approach
Extract the date portion and convert the date to numeric format
Keep only requried variables
----------------------------------------------------------*/

data sv01;
    set sv;
    if missing(svendtc) then svendtc=svstdtc;
run;

proc sort data=sv01 out=lvisdt01;
    by usubjid svendtc;
    where not missing(svendtc);
run;

data lvisdt;
    set lvisdt01;
    by usubjid svendtc;
    if last.usubjid;
    lvisdt=input(substrn(svendtc,1,10),yymmdd10.);
    format lvisdt date9.;
    keep usubjid lvisdt;
run;

/*=========================================================
Combine all variables
=========================================================*/

data adsl;
   merge dm(in=a) RFICDT(in=b) randdt(in=c) trtsdt(in=d) trtedt(in=e)
         fvisdt(in=f) lvisdt(in=g);
   by usubjid;
   if a;
run;

data output;
    set adsl;
    keep usubjid RFICDT randdt trtsdt trtedt fvisdt lvisdt;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;