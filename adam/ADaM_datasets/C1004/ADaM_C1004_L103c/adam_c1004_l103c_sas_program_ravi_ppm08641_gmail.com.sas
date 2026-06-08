* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: ADaM_C1004_L103c;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.ADaM\ADaM_C1004\ADaM_C1004_L103c\ADaM_C1004_L103c;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
Read input datasets
=========================================================*/

data qs01;
   set qs;
run;

/*=========================================================
Process the data to create analysis variables, and create score variable for use in creation of derived parameter
=========================================================*/

data qs02;
    set qs01;
    length paramcd $8 param avalc $200;

    paramcd=qstestcd;
    if upcase(strip(qstest))= "MOBILITY" then param ="Mobility";
    else if upcase(strip(qstest))= "SELF-CARE" then param ="Self-care";
    else if upcase(strip(qstest))= "USUAL ACTIVITIES" then param ="Usual activities";
    else if upcase(strip(qstest))= "PAIN / DISCOMFORT" then param ="Pain/discomfort";
    else if upcase(strip(qstest))= "ANXIETY / DEPRESSION" then param ="Anxiety/depression";
    else if upcase(strip(qstest))= "YOUR HEALTH TODAY" then param ="Your health today";

    aval=qsstresn;
    paramn=input(substrn(qstestcd,length(qstestcd)-1,2),best.);

    if paramn ne 6 then do;
        avalc=scan(qsstresc,2,'-');
    end;
    else avalc=qsstresc;

    *scoring for composite health index;

    if aval ne . then do;
        if paramn=1 then do;
            score=((aval=1)*0+(aval=2)*0.051 +(aval=3)*0.063 +(aval=4)*0.212 +(aval=5)*0.275);
        end;
        else if paramn=2 then do;
            score=((aval=1)*0+(aval=2)*0.057 +(aval=3)*0.076 +(aval=4)*0.181 +(aval=5)*0.217);
        end;
        else if paramn=3 then do;
            score=((aval=1)*0+(aval=2)*0.051 +(aval=3)*0.067 +(aval=4)*0.174 +(aval=5)*0.190);
        end;
        else if paramn=4 then do;
            score=((aval=1)*0+(aval=2)*0.060 +(aval=3)*0.075 +(aval=4)*0.276 +(aval=5)*0.341);
        end;
        else if paramn=5 then do;
            score=((aval=1)*0+(aval=2)*0.079 +(aval=3)*0.104 +(aval=4)*0.296 +(aval=5)*0.301);
        end;
    end;

    adt=input(substrn(qsdtc,1,10),??yymmdd10.);

    format adt date9.;
run;

/*=========================================================
Creation of derived parameter, CHI
=========================================================*/

/*----------------------------------------------------------
Transpose the SCORE variable such that score of all parameters at a timepoint are present on a single record
----------------------------------------------------------*/

proc sort data=qs02 out=derived01;
    by usubjid adt visitnum visit ;
run;

proc transpose data=derived01 out=derived02(drop=_:);
    by usubjid adt visitnum visit ;
    where paramn in (1:5);
    var score;
    id paramcd;
run;

/*----------------------------------------------------------
Create the aval and other variables
----------------------------------------------------------*/

data derived03;
    set derived02;
    length paramcd $8 param $200 avalc $200 paramtyp $7;
    if nmiss(eq5d5l01,eq5d5l02,eq5d5l03,eq5d5l04,eq5d5l05)= 0 then do;
        aval=round(1-0.9675*sum(eq5d5l01,eq5d5l02,eq5d5l03,eq5d5l04,eq5d5l05),0.001);
    end;
    paramcd="CHI";
    paramn=7;
    param='Composite health index';
    paramtyp="DERIVED";
    if not missing(aval) then avalc=strip(put(aval,best.));
run;

/*=========================================================
Combine derived parameter with source records
=========================================================*/

data qs03;
    set qs02 derived03;
run;

proc sort data=qs03;
   by usubjid adt paramn;
run;

/*=========================================================
Keep the required variables and arrange the variables in a logical sequence
=========================================================*/

data output;
   retain usubjid paramn param paramcd paramtyp adt aval avalc visitnum visit score;
   set qs03;
   keep usubjid paramn param paramcd paramtyp adt aval avalc visitnum visit score;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;