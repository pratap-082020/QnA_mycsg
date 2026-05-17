* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_SU_L101;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_SU\SDTM_SU_L101\SDTM_SU_L101;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

*==============================================================================;
*Append the input datasets and create necessary variables;
*==============================================================================;

data su01;
    set
    sucaf(in=incaf)
    sualc(in=inalc)
    sutob(in=intob)
    ;
*==============================================================================;
*Variables with common derivation across datasets;
*==============================================================================;

    studyid="MYCSG";
    domain="SU";
    usubjid="MYCSG-"||strip(subject);
*------------------------------------------------------------------------------;
*start and end dates;
*------------------------------------------------------------------------------;
    length stday1 $2;
    styear=scan(sustdat,3,'-');
    stmon=scan(sustdat,2,'-');
    stday=scan(sustdat,1,'-');

    if stmon not in ("","UN") then stmon1=put(month(input(cats("1",stmon,"1960"),date9.)),z2.);
    if stday="UN" then stday1="";
    else stday1=stday;

    sustdtc=catx("-",styear,stmon1,stday1);

    length enday1 $2;
    enyear=scan(suendat,3,'-');
    enmon=scan(suendat,2,'-');
    enday=scan(suendat,1,'-');

    if enmon not in ("","UN") then enmon1=put(month(input(cats("1",enmon,"1960"),date9.)),z2.);
    if enday="UN" then enday1="";
    else enday1=enday;

    suendtc=catx("-",enyear,enmon1,enday1);

*------------------------------------------------------------------------------;
*SUSTRTPT and SUENRTPT;
*------------------------------------------------------------------------------;

    length sustrtpt suenrtpt $20;

    if suncf="Former" then do;
        sustrtpt="BEFORE";
        suenrtpt="BEFORE";
    end;
    if suncf="Current" then do;
        sustrtpt="BEFORE";
        suenrtpt="ONGOING";
    end;

    if sustrtpt ne "" then susttpt="SCREENING";
    if suenrtpt ne "" then suentpt="SCREENING";

*==============================================================================;
*Dataset specific variables;
*==============================================================================;

*------------------------------------------------------------------------------;
*Alcohol;
*------------------------------------------------------------------------------;

    length sucat sutrt $30;

    if inalc then do;
        sucat="ALCOHOL";

        *row for parent category yes/no;
        sutrt="ALCOHOL";
        supresp="Y";
        if suncf in ("Former" "Current") then suoccur="Y";
        else if suncf="Never" then suoccur="N";
        output;
        call missing(supresp,suoccur,sutrt);

        *rows for type - only when used;
        if sudstxt_beer ne "" then do;
            sutrt="BEER";
            sudose=input(sudstxt_beer,??best.);
            sudosfrq=scan(sudosfrq_beer,1,'-');
            output;
            call missing(sutrt,sudose,sudosfrq);
        end;

        if sudstxt_wine ne "" then do;
            sutrt="WINE";
            sudose=input(sudstxt_wine,??best.);
            sudosfrq=scan(sudosfrq_wine,1,'-');
            output;
            call missing(sutrt,sudose,sudosfrq);
        end;

        if sudstxt_spirits ne "" then do;
            sutrt="SPIRITS";
            sudose=input(sudstxt_spirits,??best.);
            sudosfrq=scan(sudosfrq_spirits,1,'-');
            output;
            call missing(sutrt,sudose,sudosfrq);
        end;
    end;
*------------------------------------------------------------------------------;
*Tobacco;
*------------------------------------------------------------------------------;

    if intob then do;
        sucat="TOBACCO";

        *row for parent category yes/no;
        sutrt="TOBACCO";
        supresp="Y";
        if suncf in ("Former" "Current") then suoccur="Y";
        else if suncf="Never" then suoccur="N";
        output;
        call missing(supresp,suoccur,sutrt);

        *rows for type - only when used;
        if sudstxt_cigarettes ne "" then do;
            sutrt="CIGARETTES";
            sudose=input(sudstxt_cigarettes,??best.);
            sudosfrq=scan(sudosfrq_cigarettes,1,'-');
            output;
            call missing(sutrt,sudose,sudosfrq);
        end;

        if sudstxt_cigars ne "" then do;
            sutrt="CIGARS";
            sudose=input(sudstxt_cigars,??best.);
            sudosfrq=scan(sudosfrq_cigars,1,'-');
            output;
            call missing(sutrt,sudose,sudosfrq);
        end;

        if sudstxt_pipefuls ne "" then do;
            sutrt="PIPE";
            sudose=input(sudstxt_pipefuls,??best.);
            sudosfrq=scan(sudosfrq_pipefuls,1,'-');
            output;
            call missing(sutrt,sudose,sudosfrq);
        end;

    end;
*------------------------------------------------------------------------------;
*Caffeine;
*------------------------------------------------------------------------------;

    if incaf then do;
        sucat="CAFFEINE";

        *row for parent category yes/no;
        sutrt="CAFFEINE";
        supresp="Y";
        if suncf in ("Former" "Current") then suoccur="Y";
        else if suncf="Never" then suoccur="N";
        output;
        call missing(supresp,suoccur,sutrt);

        *rows for type - only when used;
        if sudstxt_coffee ne "" then do;
            sutrt="COFFEE";
            sudose=input(sudstxt_coffee,??best.);
            sudosfrq=scan(sudosfrq_coffee,1,'-');
            output;
            call missing(sutrt,sudose,sudosfrq);
        end;

        if sudstxt_soda ne "" then do;
            sutrt="SODA";
            sudose=input(sudstxt_soda,??best.);
            sudosfrq=scan(sudosfrq_soda,1,'-');
            output;
            call missing(sutrt,sudose,sudosfrq);
        end;

        if sudstxt_tea ne "" then do;
            sutrt="TEA";
            sudose=input(sudstxt_tea,??best.);
            sudosfrq=scan(sudosfrq_tea,1,'-');
            output;
            call missing(sutrt,sudose,sudosfrq);
        end;
    end;

run;

*==============================================================================;
*Derive study day;
*==============================================================================;

proc sort data=su01 out=su02;
    by usubjid sucat sutrt sustdtc;
run;

data su03;
   set su02;
   by usubjid sucat sutrt sustdtc;
   if first.usubjid then suseq=1;
   else suseq+1;
run;

*==============================================================================;
*Keep only required variables;
*==============================================================================;

%let keepvars=STUDYID DOMAIN USUBJID SUSEQ SUTRT SUCAT SUPRESP SUOCCUR SUDOSE
SUDOSFRQ SUSTDTC SUENDTC SUSTRTPT SUSTTPT SUENRTPT SUENTPT;

data su;
    retain &keepvars.;
    set su03;
    keep &keepvars.;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;