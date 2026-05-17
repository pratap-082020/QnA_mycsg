* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_TU_LONCEX01;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_TU\SDTM_TU_LONCEX01\SDTM_TU_LONCEX01;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

*==============================================================================;
*Append the required input datasets and create a variable to identify the source of the dataset;
*==============================================================================;

data tu01;
    length tulnkid $10 tuloc $200;
    set tuntsc tutgsc tunw indsname=_x_;
    indsname=scan(upcase(_x_),2,'.');
run;

*==============================================================================;
*Create variables based on raw variables;
*==============================================================================;

*------------------------------------------------------------------------------;
*Common variables are created outside do groups, and dataset
specific variables are created within relevant do groups;
*------------------------------------------------------------------------------;

data tu02;
    length tuloc tumethod tueval tuorres $200;

    set tu01;

    studyid="MYCSG";
    usubjid=cats("MYCSG-",subject);
    domain="TU";
    if recordposition ne . then turefid=cats(upcase(indsname),"-",put(recordposition,z4.));

    tutestcd="TUMIDENT";
    tutest="Tumor Identification";

    tulnkid=tulnkid;
    tuloc=tuloc;
    tulat=tulat;
    tumethod=tumethod;

    tueval=tueval;

    visitnum=folderseq;
    visit=foldername;

    if tudat ne "" then tudtc=put(input(tudat,date11.),yymmdd10.);

    if indsname="TUNTSC" then do;
        tuorres="NON-TARGET";
    end;

    if indsname="TUTGSC" then do;
        tuorres="TARGET";
    end;

    if indsname="TUNW" then do;
        tuorres="NEW";
    end;

    tustresc=tuorres;

run;

/**********************************************************
Calculate study day
**********************************************************/

proc sort data=dm;
    by usubjid;
run;

proc sort data=tu02;
    by usubjid;
run;

data tu03;
    merge tu02(in=a) dm(in=b);
    by usubjid;
    if a and b;

    if length(rfstdtc) ge 10 then rfstdt=input(rfstdtc,yymmdd10.);
    if length(tudtc) ge 10 then tudt=input(tudtc,yymmdd10.);

    if nmiss(tudt,rfstdt)=0 then tudy=tudt-rfstdt+(tudt ge rfstdt);

    format rfstdt tudt date9.;
run;

/**********************************************************
Create TUSEQ variable
**********************************************************/

proc sort data=tu03;
    by usubjid tutestcd tumethod tudtc tulnkid;
run;

data tu04;
    set tu03;
    by usubjid tutestcd tumethod tudtc tulnkid;
    if first.usubjid then tuseq=1;
    else tuseq+1;
run;

/**********************************************************
Keep only required variables and use retain statement to order the variables in the required order
**********************************************************/

%let varlist=STUDYID DOMAIN USUBJID TUSEQ TUREFID TUSPID
TULNKID TUTESTCD TUTEST TUORRES TUSTRESC TULOC TULAT TUMETHOD TUEVAL TUEVALID
VISITNUM VISIT TUDTC TUDY;

data tu;
    retain &varlist.;
    set tu04;
    keep &varlist.;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;