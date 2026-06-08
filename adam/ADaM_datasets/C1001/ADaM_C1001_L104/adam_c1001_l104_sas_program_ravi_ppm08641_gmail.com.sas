* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: ADaM_C1001_L104;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.ADaM\ADaM_C1001\ADaM_C1001_L104\ADaM_C1001_L104;

%include "&root2._data.sas";

options validvarname=upcase;

/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
Read input datasets
=========================================================*/
data dm01;
   set dm;
run;

data vs01;
   set vs;
run;

/*=========================================================
Identify the closest record on or before reference start date records
=========================================================*/

/*----------------------------------------------------------
Subset the records which are prior to reference start date with non-missing result
----------------------------------------------------------*/
/*----------------------------------------------------------
Subset only the tests of interest
----------------------------------------------------------*/

data vs02;
   merge vs01(in=a) dm01(in=b);
   by usubjid;
   if a and b;
   if vstestcd in ("HEIGHT" "WEIGHT");
   if "" lt vsdtc le rfstdtc;
   if vsstresn ne .;
run;

/*----------------------------------------------------------
Pick the latest record from the available pre reference start date
----------------------------------------------------------*/

proc sort data=vs02;
   by usubjid vstestcd vsdtc;
run;

data vs03;
   set vs02;
   by usubjid vstestcd vsdtc;
   if last.vstestcd;
run;

/*=========================================================
Transpose the dataset such that individual parameters become variables
=========================================================*/

/*----------------------------------------------------------
Notice the usage of suffix= option on proc transpose statement
----------------------------------------------------------*/

proc transpose data=vs03 out=trans01(drop=_:) suffix=BL;
   by usubjid;
   id vstestcd;
   var vsstresn;
run;

/*=========================================================
Bring the newly created baseline variables back into parent dataset
=========================================================*/

data vs04;
   merge dm01(in=a) trans01(in=b);
   by usubjid;
   if a;
run;

/*=========================================================
Keep only the required variables and order the variable appropriately
=========================================================*/
data output;
   retain usubjid rfstdtc heightbl weightbl;
   set vs04;
   keep usubjid rfstdtc heightbl weightbl;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;