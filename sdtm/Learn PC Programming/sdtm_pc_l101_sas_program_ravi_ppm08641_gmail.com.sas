* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_PC_L101;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_PC\SDTM_PC_L101\SDTM_PC_L101;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

*==============================================================================;
*Create variables which are directly based on raw variables;
*==============================================================================;

data pc01;
    set pcon;

    studyid="MYCSG";
    usubjid=cats("MYCSG-",subject);
    domain="PC";
    pcgrpid=grpid;
    pctestcd="DRUGA";
    pctest="Drug A";
    pcorres=result;
    pcorresu=unit;
    pcstresc=pcorres;
    pcstresn=input(pcstresc,??best.);
    pcstresu=pcorresu;
    pcspec=spec;
    pclloq=0.1;
    pculoq=20;
    visitnum=folderseq;
    visit=scan(foldername,1,'-');

    pcdtc=catx("T",put(input(pcdat_raw,date11.),yymmdd10.),pctim);
    pctpt=pctpt;

    length pceltm $20;
    if pctpt="PREDOSE" then do; pctptnum=0; pceltm="-PT15M"; end;
    else if pctpt="1H30MIN" then do; pctptnum=1.5; pceltm="PT1H30M"; end;
    else if pctpt="6H" then do; pctptnum=6; pceltm="PT6H"; end;
    else if pctpt="24H" then do; pctptnum=24; pceltm="PT24H"; end;

    pctptref=catx(" ",GRPID,"dose");
    pcrftdtc=dosing_time;

run;

*==============================================================================;
*Create SEQ variable;
*==============================================================================;

proc sort data=pc01;
   by usubjid pctestcd pcdtc;
   where  ;
run;

data pc02;
   set pc01;
   by usubjid pctestcd pcdtc;
   if first.usubjid then pcseq=1;
   else pcseq+1;
run;

*==============================================================================;
*Keep only required variables;
*==============================================================================;

%let keepvars=STUDYID DOMAIN USUBJID PCSEQ PCGRPID PCTESTCD PCTEST PCORRES PCORRESU
PCSTRESC PCSTRESN PCSTRESU PCSPEC PCLLOQ PCULOQ VISITNUM VISIT PCDTC PCTPT PCTPTNUM
PCELTM PCTPTREF PCRFTDTC
;

data pc;
    retain &keepvars.;
    set pc02;
    keep &keepvars.;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;