* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: TASKS_SDTMGEN_L073;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

* Important: Replace <path> with the folder where you saved the downloaded lesson files.;
* Important: On Windows SAS, use backslash as the folder separator.;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.TASKS\TASKS_SDTMGEN\TASKS_SDTMGEN_L073\TASKS_SDTMGEN_L073;

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
Sort the records by date within each subject and create separate datasets for the earliest and latest records
=========================================================*/

proc sort data=ipadmin01 out=ipadmin02;
    by study pt ipstdt;
run;

data rfxstdtc(keep=study pt ipstdtc rename=(ipstdtc=rfxstdtc))
     rfxendtc(keep=study pt ipstdtc rename=(ipstdtc=rfxendtc));
   set ipadmin02;
   by study pt ipstdt;
   if first.pt then output rfxstdtc;
   if last.pt then output rfxendtc;
   keep study pt ipstdtc;
run;

/*=========================================================
Bring RFXSTDTC and RFXENDTC into demog dataset
=========================================================*/

proc sort data=demog;
    by study pt;
run;

data dm01;
    merge demog(in=a) rfxstdtc(in=b) rfxendtc;
    by study pt;
    if a;
run;

data output;
    set dm01;
    keep study pt rfxstdtc rfxendtc;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;