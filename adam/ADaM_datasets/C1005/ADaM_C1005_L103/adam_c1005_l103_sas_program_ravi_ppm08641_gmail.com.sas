* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: ADaM_C1005_L103;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.ADaM\ADaM_C1005\ADaM_C1005_L103\ADaM_C1005_L103;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

*==============================================================================;
*Read input data;
*==============================================================================;

data eg01;
    set adeg;
run;

*==============================================================================;
*create average record - make sure that all applicable variables are used in grouping;
*==============================================================================;

proc sql;
    create table avg01 as
        select studyid,usubjid,paramcd,param,avisitn,avisit,adt,ady,mean(aval) as mean,
        count(*) as count
        from eg01
        group by studyid,usubjid,paramcd,param,avisitn,avisit,adt,ady
    ;
quit;

data avg02;
    set avg01;
    dtype="AVERAGE";
    aval=round(mean,0.01);
run;

*==============================================================================;
*Append the average record to parent dataset;
*==============================================================================;

data eg02;
    set eg01 avg02;
run;

proc sort data=eg02;
    by usubjid paramcd adt dtype atm;
run;

data output;
    retain studyid usubjid paramcd param avisitn avisit adt atm ady aval dtype;
    set eg02;
    keep studyid usubjid paramcd param avisitn avisit adt atm ady aval dtype;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;