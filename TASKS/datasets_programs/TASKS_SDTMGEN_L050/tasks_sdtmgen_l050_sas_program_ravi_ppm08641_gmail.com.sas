* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: TASKS_SDTMGEN_L050;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

* Important: Replace <path> with the folder where you saved the downloaded lesson files.;
* Important: On Windows SAS, use backslash as the folder separator.;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.TASKS\TASKS_SDTMGEN\TASKS_SDTMGEN_L050\TASKS_SDTMGEN_L050;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
Convert raw date values to ISO8601 format
=========================================================*/

/*----------------------------------------------------------
Extract day portion - convert it to numeric - convert it to two character wide character day

Extract month portion - convert it to two character wide month

Extract year

Concatenate the day, month and year portions to create ISO format date using hyphen as delimiter

Concatenate the time portion to the date portion using T as delimiter
----------------------------------------------------------*/

data ae01;
   set ae;

   stdayn=input(scan(aestdat_raw,1,' '),?? best.);
   if stdayn ne . then stday=put(stdayn,z2.);
   else stday="-";

   stmonthc=upcase(scan(aestdat_raw,2,' '));
   if stmonthc="JAN" then stmonth="01";
   else if stmonthc="FEB" then stmonth="02";
   else if stmonthc="MAR" then stmonth="03";
   else if stmonthc="APR" then stmonth="04";
   else if stmonthc="MAY" then stmonth="05";
   else if stmonthc="JUN" then stmonth="06";
   else if stmonthc="JUL" then stmonth="07";
   else if stmonthc="AUG" then stmonth="08";
   else if stmonthc="SEP" then stmonth="09";
   else if stmonthc="OCT" then stmonth="10";
   else if stmonthc="NOV" then stmonth="11";
   else if stmonthc="DEC" then stmonth="12";
   else stmonth="-";

   styear=scan(aestdat_raw,3,' ');
   if styear="" then styear="-";

   aestdate=catx("-",styear,stmonth,stday);

   aestdtc=catx("T",aestdate,aesttm);
   if aestdtc="-----" then aestdtc="";
   if substrn(strip(reverse(aestdtc)),1,4)="----" then aestdtc=substrn(aestdtc,1,length(aestdtc)-4);
   if substrn(strip(reverse(aestdtc)),1,2)="--" then aestdtc=substrn(aestdtc,1,length(aestdtc)-2);

run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;