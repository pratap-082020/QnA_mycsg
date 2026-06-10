* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: TASKS_SDTMGEN_L072;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

* Important: Replace <path> with the folder where you saved the downloaded lesson files.;
* Important: On Windows SAS, use backslash as the folder separator.;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.TASKS\TASKS_SDTMGEN\TASKS_SDTMGEN_L072\TASKS_SDTMGEN_L072;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
Identify the boxid of the earliest non-zero dose for each subject
=========================================================*/
/*----------------------------------------------------------
Create numeric version of administration date to sort the records based on dose date
Also subset the records of non-zero dose
----------------------------------------------------------*/
data ipadmin01;
    set ipadmin;
    if not missing(ipstdt_raw) then ipstdt=input(ipstdt_raw,date11.);
    format ipstdt date9.;
    if input(ipqty_raw,??best.) gt 0;
run;

/*----------------------------------------------------------
Sort the records by date within each subject and pick the earliest record
----------------------------------------------------------*/

proc sort data=ipadmin01 out=ipadmin02;
    by study pt ipstdt;
run;

data ipadmin03;
   set ipadmin02;
   by study pt ipstdt;
   if first.pt;
   keep study pt ipboxid;
run;

/*=========================================================
Bring the earliest box id into demog dataset
=========================================================*/

proc sort data=demog;
    by study pt;
run;

data dm01;
    merge demog(in=a) ipadmin03(in=b);
    by study pt;
    if a;
run;

/*=========================================================
Fetch the CONTENT from BOX dataset associated with the earliest boxid
=========================================================*/

proc sort data=dm01;
   by ipboxid;
run;

proc sort data=box;
   by kitid;
run;

data dm02;
   merge dm01(in=a)
         box(in=b rename=(kitid=ipboxid));
   by ipboxid;

   if a;
   actarmcd=content;

   length actarm $20;
   if actarmcd="ACTIVE" then actarm="Active";
   else if actarmcd="PBO" then actarm="Placebo";
run;

proc sort data=dm02;
    by study pt;
run;

data output;
    set dm02;
    keep study pt ipboxid actarmcd actarm;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;