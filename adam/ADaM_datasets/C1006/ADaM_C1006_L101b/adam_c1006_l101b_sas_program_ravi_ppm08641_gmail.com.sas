* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: ADaM_C1006_L101b;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.ADaM\ADaM_C1006\ADaM_C1006_L101b\ADaM_C1006_L101b;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

*==============================================================================;
*Derive ablfl;
*==============================================================================;

*------------------------------------------------------------------------------;
*Subset eligible records;
*------------------------------------------------------------------------------;

data base01;
    set advs;
    where aval ne . and ((. lt adt le trtsdt and atm=.) or (. lt adtm lt trtsdtm and atm ne .));

run;

*------------------------------------------------------------------------------;
*Select the latest record;
*------------------------------------------------------------------------------;

proc sort data=base01;
    by usubjid paramcd adt adtm;
run;

data base02;
    set base01;
    by usubjid paramcd adt adtm;
    if last.paramcd;
    keep usubjid paramcd adt adtm;
run;

*------------------------------------------------------------------------------;
*Flag ablfl on the chosen required in parent dataset;
*------------------------------------------------------------------------------;

proc sort data=advs out=advs01;
    by usubjid paramcd adt adtm;
run;

data advs02;
    merge advs01(in=a) base02(in=b);
    by usubjid paramcd adt adtm;
    if b then ablfl="Y";
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;