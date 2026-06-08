* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: ADaM_C1004_L101;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.ADaM\ADaM_C1004\ADaM_C1004_L101\ADaM_C1004_L101;

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
run;

/*=========================================================
Create variables and paramters which are directly based on source records
=========================================================*/

data vs01;
   set vs;
   length paramcd $8 param $200;
   paramcd=vstestcd;
   param=strip(vstest)||" ("||strip(vsstresu)||")";
   if length(vsdtc) ge 10 then adt=input(substrn(vsdtc,1,10),yymmdd10.);
   aval=vsstresn;
   format adt date9.;
run;

/*=========================================================
Create the new parameter- log10(weight)
=========================================================*/
/*----------------------------------------------------------
Notice the usage of same dataset twice on set statement 
Also notice the subsetting of 'WEIGHT' parameter in the second instance.
----------------------------------------------------------*/
data vs02;
   set vs01(in=a)
       vs01(where=(paramcd="WEIGHT") in=b);

   if b then do;
      if aval gt 0 then aval=round(log10(aval),0.01);
      paramcd="L10WT";
      param="Log10(Weight (kg))";
   end;
run;

/*=========================================================
Keep only the required variables and order the variables in logical sequence
=========================================================*/
data output;
   retain usubjid paramcd param adt aval;
   set vs02;
   keep usubjid paramcd param adt aval;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;