* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_TR_LONCEX06;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_TR\SDTM_TR_LONCEX06\SDTM_TR_LONCEX06;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

*==============================================================================;
*Combine the input datasets and create common variables;
*==============================================================================;

data tr01;
    length foldername $30 tulnkid trlnkgrp tumstate_trorres tuloc $200;
    set tuntsc tunt tutgsc tutg tunw indsname=_x;
    studyid="MYCSG";
    usubjid=cats("MYCSG-",subject);
    domain="TR";
    indsname=scan(_x,2,'.');
    visitnum=folderseq;
    visit=foldername;
    trlnkid=tulnkid;
    trspid=tuspid;
    trlnkgrp=foldername;
    trmethod=tumethod;
    treval=tueval;
    length trrefid $30;
    trrefid=catx("-",indsname,put(recordposition,z4.));
    if tudat ne "" then trdtc=put(input(tudat,date11.),yymmdd10.);
run;

*==============================================================================;
*Create rows for tests based on the respective input datasets and variables;
*==============================================================================;

data tr02;
    set tr01;
    length trtestcd $8 trtest $40 trgrpid $10 trorres $200;

*------------------------------------------------------------------------------;
*Non-target lesions at screening;
*------------------------------------------------------------------------------;

    if indsname="TUNTSC" then do;
        trgrpid="NON-TARGET";
        trtestcd="TUMSTATE";
        trtest="Tumor State";
        trorres="PRESENT";
        trstresc=trorres;
        output;
        call missing(trgrpid,trlnkid,trtestcd,trtest,trorres,trstresc);
    end;

*------------------------------------------------------------------------------;
*Non-target lesions postbaseline;
*------------------------------------------------------------------------------;

    if indsname="TUNT" then do;
        trgrpid="NON-TARGET";
        trtestcd="TUMSTATE";
        trtest="Tumor State";
        if not missing(trineval) then trstat="NOT DONE";
        trorres=tumstate_trorres;
        trstresc=trorres;
        output;
        call missing(trgrpid,trlnkid,trtestcd,trtest,trstat,trorres,trstresc,trreasnd);
    end;

*------------------------------------------------------------------------------;
*Target lesions - screening and postbaseline;
*------------------------------------------------------------------------------;

   if indsname in ("TUTGSC" "TUTG") then do;
        trgrpid="TARGET";
        trtestcd="DIAMETER";
        trtest="Diameter";

        if trtoosm ne "" then trorres="TOO SMALL TO MEASURE";
        else if not missing(ldiam_trorres) then trorres=cats(ldiam_trorres);
        if trorres ne "" then trorresu=ldiam_trorresu;

        if trorres="TOO SMALL TO MEASURE" then trstresc="5";
        else trstresc=trorres;

        trstresu=trorresu;

        if not missing(trineval) then do;
            trstat="NOT DONE";
            trreasnd=trreasnd;
        end;
        output;
        call missing(trlnkid,trtestcd,trtest,trstat,trreasnd,trorres,trstresc,trorresu,trstresu);
    end;
*------------------------------------------------------------------------------;
*New lesions;
*------------------------------------------------------------------------------;

    if indsname="TUNW" then do;
        trgrpid="NEW";
        trtestcd="TUMSTATE";
        trtest="Tumor State";
        if not missing(trineval) then trstat="NOT DONE";
        trorres=tumstate_trorres;
        trstresc=trorres;
        output;   
    end;

run;

*==============================================================================;
*Calculate study day;
*==============================================================================;

proc sort data=dm;
    by usubjid;
run;

proc sort data=tr02;
    by usubjid;
run;

data tr03;
    merge tr02(in=a) dm(in=b);
    by usubjid;
    if a and b;

    if length(rfstdtc) ge 10 then rfstdt=input(rfstdtc,yymmdd10.);
    if length(trdtc) ge 10 then trdt=input(trdtc,yymmdd10.);

    if nmiss(trdt,rfstdt)=0 then trdy=trdt-rfstdt+(trdt ge rfstdt);

    format rfstdt trdt date9.;
run;

*==============================================================================;
*Create TRSEQ variable;
*==============================================================================;

proc sort data=tr03;
    by usubjid trgrpid trtestcd trdtc trlnkid;
run;

data tr04;
    set tr03;
    by usubjid trgrpid trtestcd trdtc trlnkid;
    if first.usubjid then trseq=1;
    else trseq+1;

    trstresn=input(trstresc,??best.);
run;

*==============================================================================;
*Keep only required variables and use retain statement to order the variables in the required order;
*==============================================================================;

%let varlist=STUDYID DOMAIN USUBJID TRSEQ TRGRPID TRSPID TRLNKID TRLNKGRP
TRTESTCD TRTEST TRORRES TRORRESU TRSTRESC TRSTRESN TRSTRESU
TRSTAT TRREASND TRMETHOD TREVAL VISITNUM VISIT TRDTC TRDY
;

data tr;
    retain &varlist.;
    set tr04;
    keep &varlist.;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;