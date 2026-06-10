* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: TASKS_SDTMGEN_L101;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

* Important: Replace <path> with the folder where you saved the downloaded lesson files.;
* Important: On Windows SAS, use backslash as the folder separator.;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.TASKS\TASKS_SDTMGEN\TASKS_SDTMGEN_L101\TASKS_SDTMGEN_L101;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
Read input datasets
=========================================================*/

/*----------------------------------------------------------
Creating copies of input datasets
----------------------------------------------------------*/
data dm01;
   set dm;
run;

data vs01;
   set vs;
run;

/*=========================================================
Get reference start date from DM dataset to VS dataset
=========================================================*/

/*----------------------------------------------------------
Sort the input datasets by usubjid
Merge VS dataset to DM dataset based on usubjid
Use in= dataset option to keep only records coming from VS dataset
----------------------------------------------------------*/

proc sort data=dm01;
   by usubjid;
run;

proc sort data=vs01;
   by usubjid;
run;

data vs02;
   merge vs01(in=a) dm(in=b keep=usubjid rfstdtc);
   by usubjid;
   if a;
run;

/*=========================================================
Calculate study day
=========================================================*/
/*----------------------------------------------------------
Create numeric version of reference start date
Create numeric version of vital signs collection date
Check if collection date is before reference start date
If before: Calculate study day as difference between collection date and reference start date
If on or after: Calculate study day as above and add 1 to it
----------------------------------------------------------*/

data vs03;
   set vs02;

   if length(rfstdtc) ge 10 then rfstdt=input(rfstdtc,yymmdd10.);
   if length(vsdtc) ge 10 then vsdt=input(vsdtc,yymmdd10.);

   if (. lt vsdt lt rfstdt) then vsdy=vsdt-rfstdt;
   else if (vsdt ge rfstdt gt .) then vsdy=vsdt-rfstdt+1;

   format rfstdt vsdt date9.;
run;

data output;
    set vs03;
    drop vsdt rfstdt;
run;

proc sort data=output;
    by usubjid vstestcd vsdtc;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;