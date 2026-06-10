* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: TASKS_SDTMGEN_L075;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

* Important: Replace <path> with the folder where you saved the downloaded lesson files.;
* Important: On Windows SAS, use backslash as the folder separator.;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.TASKS\TASKS_SDTMGEN\TASKS_SDTMGEN_L075\TASKS_SDTMGEN_L075;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
Subset the records from EOS dataset where EOTERM=Death
Conver EOSTDT_RAW to ISO 8601 format for DTHDTC
=========================================================*/

data eos01;
    set eos;
    where eoterm='Death';
    if eostdt_raw ne "" then dthdtc=put(input(eostdt_raw,date11.),yymmdd10.);
run;

/*=========================================================
Merge the death records onto demog dataset and populate DTHFL
=========================================================*/
proc sort data=demog;
    by study pt;
run;

proc sort data=eos01;
    by study pt;
run;

data dm01;
    merge demog(in=a) eos01(in=b keep=study pt dthdtc);
    by study pt;
    if a;
    if b then dthfl="Y";
run;

data output;
    set dm01;
    keep study pt dthfl dthdtc;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;