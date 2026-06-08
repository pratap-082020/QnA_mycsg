* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: ADaM_C1007_L101;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.ADaM\ADaM_C1007\ADaM_C1007_L101\ADaM_C1007_L101;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
Read input datasets
=========================================================*/

data vs01;
   set vs;
   format adt trtsdt date9.;
run;

/*=========================================================
Check the interval in which the ADY falls and assign AVISIT/AVISITN/AWTARGET/AWLO/AWHI
=========================================================*/

data vs02;
   set vs01;
   length avisit $30;
   awu="Days";
   if 2 le ady le 11 then do;
      avisit="Week 1";
      avisitn=1;
      awlo=2;
      awhi=11;
      awtarget=7;
   end;
   else if 12 le ady le 18 then do;
      avisit="Week 2";
      avisitn=2;
      awlo=12;
      awhi=18;
      awtarget=14;
   end;
   else if 19 le ady le 25 then do;
      avisit="Week 3";
      avisitn=3;
      awlo=19;
      awhi=25;
      awtarget=21;
   end;
   else if 26 le ady le 32 then do;
      avisit="Week 4";
      avisitn=4;
      awlo=26;
      awhi=32;
      awtarget=28;
   end;
   else if 33 le ady le 39 then do;
      avisit="Week 5";
      avisitn=5;
      awlo=33;
      awhi=39;
      awtarget=35;
   end;

run;

/*=========================================================
Keep only the required variables and order the variables in a logical sequence
=========================================================*/

data output;
   retain usubjid paramcd param paramn avisitn avisit adt ady aval awtarget awlo awhi  awu trtsdt visitnum visit;
   set vs02;
   keep usubjid paramcd param paramn avisitn avisit adt ady aval awtarget awlo awhi  awu trtsdt visitnum visit;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;