* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: TASKS_SDTMGEN_L071;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

* Important: Replace <path> with the folder where you saved the downloaded lesson files.;
* Important: On Windows SAS, use backslash as the folder separator.;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.TASKS\TASKS_SDTMGEN\TASKS_SDTMGEN_L071\TASKS_SDTMGEN_L071;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
Fetch the randomization number into demog dataset from enrollment dataset
=========================================================*/

proc sort data=demog;
   by study pt;
run;

proc sort data=enrlment;
   by study pt;
run;

data dm01;
   merge demog(in=a)
         enrlment(in=b keep=study pt randno);
   by study pt;

   if a;
run;

/*=========================================================
Fetch tx_cd as armcd by merging demog dataset with randomization dataset based on randomization number
=========================================================*/

proc sort data=dm01;
   by randno;
run;

proc sort data=rand;
   by rand_id;
run;

data dm02;
   merge dm01(in=a)
         rand(in=b keep=rand_id tx_cd rename=(rand_id=randno tx_cd=armcd));
   by randno;

   if a;
   length arm $20;
   if armcd="ACTIVE" then arm="Active";
   else if armcd="PBO" then arm="Placebo";

run;

proc sort data=dm02;
    by study pt;
run;

data output;
    set dm02;
    keep study pt armcd randno arm;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;