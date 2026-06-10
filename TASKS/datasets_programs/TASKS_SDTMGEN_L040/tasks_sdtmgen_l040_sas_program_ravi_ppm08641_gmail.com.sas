* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: TASKS_SDTMGEN_L040;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

* Important: Replace <path> with the folder where you saved the downloaded lesson files.;
* Important: On Windows SAS, use backslash as the folder separator.;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.TASKS\TASKS_SDTMGEN\TASKS_SDTMGEN_L040\TASKS_SDTMGEN_L040;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

*==============================================================================;
*Create standard versions of the variables;
*==============================================================================;

*------------------------------------------------------------------------------;
*Create required formats;
*------------------------------------------------------------------------------;

proc format;
   value sex
   1="M"
   2="F"
   ;
run;

*------------------------------------------------------------------------------;
*create SEX, ETHNIC, COUNTRY;
*------------------------------------------------------------------------------;

data dm01;
   set demog(rename=(sex=old_sex race=old_race country=old_country));

   length sex $1 ethnic $30 country $3;
   sex=put(old_sex,sex.);

   ethnic=upcase(ethnicity);

   if old_country="UNITED STATES OF AMERICA" then country="USA";
   else if old_country="INDIA" then country="IND";
   else if old_country="MEXICO" then country="MEX";
   else if old_country="JAPAN" then country="JPN";

run;

*------------------------------------------------------------------------------;
*create race variable;
*------------------------------------------------------------------------------;

data race_meta;
   set metadata;
   where variable="RACE";

   length old_race $5;
   old_race=collected_value;
   race=standard_value;

   keep old_race race;
run;

proc sort data=dm01;
   by old_race;
run;

proc sort data=race_meta;
   by old_race;
run;

data dm02;
   merge dm01(in=a) race_meta(in=b);
   by old_race;
   if a;
run;

proc sort data=dm02 out=dm03;
   by subject;
run;

data dm;
   set dm03;
   drop old_: ethnicity;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;