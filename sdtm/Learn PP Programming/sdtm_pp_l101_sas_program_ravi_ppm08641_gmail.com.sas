* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_PP_L101;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_PP\SDTM_PP_L101\SDTM_PP_L101;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

*==============================================================================;
*Create variables which are directly based on raw variables;
*==============================================================================;

data pp01;
    set pparam;

    studyid="MYCSG";
    usubjid=cats("MYCSG-",subject);
    domain="PP";
    ppgrpid=grpid;
    pptestcd=scan(param,1,'(');

    length pptest $40;
    if pptestcd="TMAX" then pptest="Time of CMAX";
    else if pptestcd="CMAX" then pptest="Max Conc";
    else if pptestcd="AUCALL" then pptest="AUC All";
    else if pptestcd="LAMZHL" then pptest="Half-Life Lambda z";
    else if pptestcd="VZO" then pptest="Vz Obs";

    ppcat=scan(grpid,2,'_');
    pporres=result;
    pporresu=scan(result,2,'()');

    ppstresc=pporres;
    ppstresn=input(ppstresc,??best.);
    ppstresu=pporresu;
    ppspec=spec;

    length grpid1 $6;
    grpid1=scan(grpid,1,'_');

run;

*==============================================================================;
*Derive PPRFTDTC;
*==============================================================================;

proc sort data=pcon out=pcon1(keep=subject grpid dosing_time) nodupkey;
   by subject grpid dosing_time;
run;

proc sort data=pp01;
   by subject grpid1;
run;

data pp02;
   merge pp01(in=a)
         pcon1(in=b rename=(grpid=grpid1 dosing_time=pprftdtc));
   by subject grpid1;

   if a;
run;

*==============================================================================;
*Create SEQ variable;
*==============================================================================;

proc sort data=pp02;
   by usubjid ppcat pptestcd ppgrpid ;
   where  ;
run;

data pp03;
   set pp02;
   by usubjid ppcat pptestcd ppgrpid;
   if first.usubjid then ppseq=1;
   else ppseq+1;
run;

*==============================================================================;
*Keep only requried variables;
*==============================================================================;

%let keepvars=STUDYID DOMAIN USUBJID PPSEQ PPGRPID PPTESTCD PPTEST PPCAT
PPORRES PPORRESU PPSTRESC PPSTRESN PPSTRESU PPSPEC PPRFTDTC
;

data pp;
    retain &keepvars.;
    set pp03;
    keep &keepvars.;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;