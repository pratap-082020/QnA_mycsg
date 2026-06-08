* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: ADaM_C1004_L111;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.ADaM\ADaM_C1004\ADaM_C1004_L111\ADaM_C1004_L111;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

*==============================================================================;
*Create a copy of the input dataset;
*==============================================================================;

data vs;
    set advs;
run;

*=============================================================================;
*Sort the input data for processing;
*=============================================================================;
proc sort data=vs;
  by usubjid avisitn atpt;
run;

*=============================================================================;
*Transpose the data so that Baseline and End of Test are columns;
*=============================================================================;
proc transpose data=vs out=vs_trans (drop=_name_) prefix=spo2_;
  by usubjid avisitn avisit adt ady trtsdt;
  id atpt;
  var aval;
run;

*=============================================================================;
*Create new parameter for SpO2 Decay;
*=============================================================================;
data vs_decay;
  set vs_trans;

  length paramcd $8 param $200;
  if not missing(spo2_Baseline) and not missing(spo2_End_of_Test) then do;
    paramcd = "SPO2DECY";
    param   = "SpO2 Decay (%)";
    paramn  = 2;
    aval    = spo2_Baseline - spo2_End_of_Test;
    output;
  end;
run;

*=============================================================================;
*Append to original vs dataset;
*=============================================================================;
data vs_final;
  set vs vs_decay;
run;

*=============================================================================;
*keep only required variables
*=============================================================================;

data output;
    set vs_final;
    keep usubjid avisitn avisit adt ady trtsdt paramcd param paramn aval atpt;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;