* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: ADaM_C1006_L105;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.ADaM\ADaM_C1006\ADaM_C1006_L105\ADaM_C1006_L105;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

data adoe01;
   set oe;

   paramcd=oetestcd;
   param=oetest||" ("||strip(oestresu)||")";
   aval=oestresn;

   avisit=visit;
   avisitn=visitnum;
   basetype=strip(oetpt) || " Baseline";

   if avisitn=1 and aval ne . then ablfl="Y";
run;

*==============================================================================;
*Populate timepoint matching baseline values;
*==============================================================================;

*------------------------------------------------------------------------------;
*subset the baseline visit;
*------------------------------------------------------------------------------;

data base01;
   set adoe01;
   where ablfl="Y";
   base=aval;
   keep usubjid basetype paramcd base;
run;

*------------------------------------------------------------------------------;
*Pull baseline into all records of that subject/param/matched timepoint;
*------------------------------------------------------------------------------;

proc sort data=adoe01 out=adoe02;
   by usubjid basetype paramcd;
run;

proc sort data=base01;
   by usubjid basetype paramcd;
run;

data adoe03;
   merge adoe02(in=a) base01(in=b);
   by usubjid basetype paramcd;

run;

*==============================================================================;
*Calculate chg, pchg;
*==============================================================================;

data adoe04;
   set adoe03;

   if avisitn gt 1 then do;
      if nmiss(aval,base)=0 then do;
         chg=aval-base;
         if base ne 0 then pchg=round(chg/base*100,0.01);
      end;
   end;
run;

*==============================================================================;
*Keep only required variables;
*==============================================================================;

data adoe;
   set adoe04;
   keep usubjid paramcd param aval avisitn avisit basetype ablfl base oetpt chg pchg;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;