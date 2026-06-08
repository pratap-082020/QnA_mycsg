* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: ADaM_C1001_L105;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.ADaM\ADaM_C1001\ADaM_C1001_L105\ADaM_C1001_L105;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
Read input datasets
=========================================================*/

data adsl01;
   set adsl;
run;
/*=========================================================
Create the new grouping variables which are based on direct variables from source dataset
=========================================================*/
/*----------------------------------------------------------
AGEGR1, AGEGR1N, AGEGR2, AGEGR2N
----------------------------------------------------------*/
/*----------------------------------------------------------
BMIGR1, BMIGR1N
----------------------------------------------------------*/

data adsl02;
   set adsl01;
   length bmigr1 agegr1 agegr2 $50;
   if . lt bmibl lt 18.5 then do;
      bmigr1n=1;
      bmigr1="Underweight";
   end;
   else if 18.5 le bmibl lt 25 then do;
      bmigr1="Normal weight";
      bmigr1n=2;
   end;
   else if 25 le bmibl lt 30 then do;
      bmigr1n=3;
      bmigr1="Overweight";
   end;
   else if bmibl ge 30 then do;
      bmigr1n=4;
      bmigr1="Obesity";
   end;

   if . lt age lt 60 then do;
      agegr1n=1;
      agegr1="< 60 years";
   end;
   else if 60 le age le 75 then do;
      agegr1n=2;
      agegr1="60 - 75 years";
   end;
   else if age > 75 then do;
      agegr1n=3;
      agegr1="> 75 years";
   end;

   if . lt age lt 80 then do;
      agegr2n=1;
      agegr2="< 80 years";
   end;
   else if age ge 80 then do;
      agegr2n=2;
      agegr2=">= 80 years";
   end;
run;

/*=========================================================
Create grouping variables which require some data manipulation
=========================================================*/

/*----------------------------------------------------------
Create pooled Site group variable
----------------------------------------------------------*/
/*----------------------------------------------------------
Count the number of subjects in each site
----------------------------------------------------------*/

proc freq data=    adsl02 noprint   ;
tables  siteid/list missing out=siteid01(drop=percent);
where ;
run;

/*----------------------------------------------------------
Create SITEGR1 variable based on the number of subjects within a site, in the dataset containing site totals
----------------------------------------------------------*/
data siteid02;
   set siteid01;
   length sitegr1 $20;

   if count lt 10 then sitegr1="Pooled Group";
   else sitegr1=siteid;
run;

/*----------------------------------------------------------
Merge back the SITEGR1 variable into Parent domain based on SITEID
----------------------------------------------------------*/
proc sort data=adsl02;
   by siteid;
run;

proc sort data=siteid02;
   by siteid;
run;

data adsl03;
   merge adsl02(in=a) siteid02(in=b);
   by siteid;
   if a;
   drop count;
run;

/*=========================================================
Keeping only the required variables and ordering the variables in logical sequence
=========================================================*/

data output;
   retain usubjid siteid sitegr1 age agegr1 agegr1n agegr2 agegr2n bmibl bmigr1 bmigr1n weightbl heightbl;
   set adsl03;
   keep usubjid siteid sitegr1 age agegr1 agegr1n agegr2 agegr2n bmibl bmigr1 bmigr1n weightbl heightbl;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;