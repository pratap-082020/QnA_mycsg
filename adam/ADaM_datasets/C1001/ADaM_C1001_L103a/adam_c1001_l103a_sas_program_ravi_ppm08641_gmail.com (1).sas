* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: ADaM_C1001_L103a;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.ADaM\ADaM_C1001\ADaM_C1001_L103a\ADaM_C1001_L103a;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
Process data for first period treatment start
=========================================================*/

proc sort data=ex out=ex_p1_01;
    by usubjid exstdtc;
    where visitnum in (201,202,203,204);
run;

data ex_p1_02;
    set ex_p1_01;
    by usubjid exstdtc;
    if first.usubjid;
    trt01a=extrt;
    tr01sdt=input(substrn(exstdtc,1,10),yymmdd10.);
    format tr01sdt yymmdd10.;
    keep usubjid trt01a tr01sdt;
run;

/*=========================================================
Process data for second period treatment start
=========================================================*/

proc sort data=ex out=ex_p2_01;
    by usubjid exstdtc;
    where visitnum in (205,206,207,208);
run;

data ex_p2_02;
    set ex_p2_01;
    by usubjid exstdtc;
    if first.usubjid;
    trt02a=extrt;
    tr02sdt=input(substrn(exstdtc,1,10),yymmdd10.);
    format tr02sdt yymmdd10.;
    keep usubjid trt02a tr02sdt;
run;

/*=========================================================
Process data for first period treatment end date
=========================================================*/

proc sort data=ex_p1_01 out=en_p1;
    by usubjid exstdtc;
run;

data en_p1;
    set en_p1;
    by usubjid exstdtc;
    if last.usubjid;
    tr01edt=input(substrn(exstdtc,1,10),yymmdd10.);
    format tr01edt yymmdd10.;
    keep usubjid tr01edt;
run;

/*=========================================================
Process data for second period end date
=========================================================*/

proc sort data=ex_p2_01 out=en_p2;
    by usubjid exstdtc;
run;

data en_p2;
    set en_p2;
    by usubjid exstdtc;
    if last.usubjid;
    tr02edt=input(substrn(exstdtc,1,10),yymmdd10.);
    format tr02edt yymmdd10.;
    keep usubjid tr02edt;
run;

/*=========================================================
Process the derived data to create required variables
=========================================================*/

data adsl;
    merge dm(in=a) ex_p1_02 ex_p2_02 en_p1 en_p2;
    by usubjid;
    if a;
    length trtseqa $20;
    if not missing(trt01a) and not missing(trt02a) then
        trtseqa=strip(trt01a)||" - "||strip(trt02a);
    else if not missing(trt01a) then trtseqa=trt01a;

    if nmiss(tr01sdt,tr02sdt) ne 2 then trtsdt=coalesce(tr01sdt,tr02sdt);
    if nmiss(tr02edt,tr01edt) ne 2 then trtedt=coalesce(tr02edt,tr01edt);
    format trtsdt trtedt yymmdd10.;

    length trt01p trt02p $10 trtseqp $20;
    if armcd="SEQ1" then do; trt01p="CSG"; trt02p="Active"; trtseqp="CSG - Active"; end;
    else if armcd="SEQ2" then do; trt01p="Active"; trt02p="CSG"; trtseqp="Active - CSG"; end;

run;

/*=========================================================
Keep only the required variables in final dataset
=========================================================*/

data output;
    retain usubjid trtseqp trtseqa trt01p trt01a trt02p trt02a tr01sdt tr02sdt trtsdt tr01edt tr02edt trtedt armcd;
    set adsl;
    keep usubjid tr: armcd;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;