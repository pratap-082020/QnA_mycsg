* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: TASKS_SDTMGEN_L074;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

* Important: Replace <path> with the folder where you saved the downloaded lesson files.;
* Important: On Windows SAS, use backslash as the folder separator.;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.TASKS\TASKS_SDTMGEN\TASKS_SDTMGEN_L074\TASKS_SDTMGEN_L074;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
Create numeric version of administration date to sort the records based on dose date
Also subset the records of non-zero dose
Create the exposure date in ISO 8601 format
=========================================================*/
data ipadmin01;
    set ipadmin;
    if not missing(ipstdt_raw) then ipstdt=input(ipstdt_raw,date11.);
    if ipstdt ne . then ipstdtc=put(ipstdt,yymmdd10.);
    format ipstdt date9.;
    if input(ipqty_raw,??best.) gt 0;
run;

/*=========================================================
Create exposure start date
Sort the records by date within each subject and the pick the earliest record
=========================================================*/

proc sort data=ipadmin01 out=ipadmin02;
    by study pt ipstdt;
run;

data ipstdtc;
   set ipadmin02;
   by study pt ipstdt;
   if first.pt;
   keep study pt ipstdtc;
run;

/*=========================================================
Create iso versions for informed consent and randomization dates
=========================================================*/

data enrl01;
    set enrlment;

    if not missing(icdt_raw) then rficdtc=put(input(icdt_raw,??date11.),yymmdd10.);
    if not missing(randdt_raw) then randdtc=put(input(randdt_raw,??date11.),yymmdd10.);
    keep study pt rficdtc randdtc;
run;

/*=========================================================
Create iso version of eostdt_raw for RFENDTC
=========================================================*/
data eos01;
    set eos;

    if not missing(eostdt_raw) then rfendtc=put(input(eostdt_raw,??date11.),yymmdd10.);
    keep study pt rfendtc;
run;

/*=========================================================
Bring all ISO date values into demog dataset
Create RFSTDTC using exposure start date and randomization date
=========================================================*/

proc sort data=demog;
    by study pt;
run;

data dm01;
    merge demog(in=a) ipstdtc(in=b) enrl01 eos01;
    by study pt;
    if a;
    if ipstdtc ne "" then rfstdtc=ipstdtc;
    else rfstdtc=randdtc;
run;

data output;
    set dm01;
    keep study pt rfstdtc rficdtc rfendtc;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;