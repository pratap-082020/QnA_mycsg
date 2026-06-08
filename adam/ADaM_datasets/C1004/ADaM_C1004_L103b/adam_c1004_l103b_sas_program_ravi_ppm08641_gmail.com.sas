* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: ADaM_C1004_L103b;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.ADaM\ADaM_C1004\ADaM_C1004_L103b\ADaM_C1004_L103b;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
Read input datasets
=========================================================*/

data lb01;
   set lb;
run;

data dm01;
   set dm;
run;

/*=========================================================
Create variables and parameters which are directly based on source records
=========================================================*/

data lb02;
   set lb01;
   length paramcd $8 param $200;
   paramcd=lbtestcd;
   param=strip(lbtest)||" ("||strip(lbstresu)||")";
   if length(lbdtc) ge 10 then adt=input(substrn(lbdtc,1,10),yymmdd10.);
   aval=lbstresn;
   format adt date9.;
run;

/*=========================================================
Create the new parameter- HDLLDL
=========================================================*/

/*----------------------------------------------------------
Subset the input parameters: LDL and HDL
----------------------------------------------------------*/

proc sort data=lb02 out=ratio01;
   by usubjid adt visitnum visit;
   where paramcd in ("LDL" "HDL");
run;

/*----------------------------------------------------------
Transpose the data such that LDL and HDL collected at a timepoint are available side by side
----------------------------------------------------------*/

proc transpose data=ratio01 out=ratio02(drop=_:);
   by usubjid adt visitnum visit;
   id paramcd;
   var aval;
run;

/*----------------------------------------------------------
Derive AVAL for HDLLDL
----------------------------------------------------------*/
data ratio03;
   set ratio02;
   length paramcd $8 param $200 paramtyp $7;
   if hdl ne . and ldl ne . then do;
      aval=round(hdl/ldl,0.01);
   end;
   paramcd="HDLLDL";
   param="HDL LDL Ratio (Ratio)";
   paramtyp="DERIVED";
run;

/*=========================================================
Combine the derived paramter records with records of source parameters
=========================================================*/

data lb03;
   set lb02 ratio03;
run;
proc sort data=lb03;
   by usubjid paramcd adt;
run;

/*=========================================================
Keep only the required variables and order the variables in a logical sequence
=========================================================*/

data output;
   retain usubjid paramcd param adt aval;
   set lb03;
   keep usubjid paramcd param adt aval;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;