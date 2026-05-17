* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_TV_LCSG801;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_TV\SDTM_TV_LCSG801\SDTM_TV_LCSG801;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

data tv;
    length STUDYID $10 DOMAIN $2 VISITNUM 8 VISIT $50 VISITDY 8 ARMCD $8 ARM $40
    TVSTRL TVENRL $200;

    studyid="CSG801";
    domain="TV";

    armcd="";
    arm="";

    visitnum=1;
    visit="Visit 1";
    visitdy=-14;
    tvstrl="Start of screening epoch";
    tvenrl="End of all screening procedures";
    output;
    call missing(visitnum,visit,visitdy,tvstrl,tvenrl);

    visitnum=2;
    visit="Visit 2";
    visitdy=1;
    tvstrl="Start of treatment epoch";
    tvenrl="";
    output;
    call missing(visitnum,visit,visitdy,tvstrl,tvenrl);

    visitnum=3;
    visit="Visit 2";
    visitdy=15;
    tvstrl="2 Weeks after start of treatment";
    tvenrl="";
    output;
    call missing(visitnum,visit,visitdy,tvstrl,tvenrl);

    visitnum=4;
    visit="Visit 4";
    visitdy=29;
    tvstrl="4 Weeks after start of treatment";
    tvenrl="";
    output;
    call missing(visitnum,visit,visitdy,tvstrl,tvenrl);

    visitnum=5;
    visit="Visit 5";
    visitdy=43;
    tvstrl="6 Weeks after start of treatment";
    tvenrl="";
    output;
    call missing(visitnum,visit,visitdy,tvstrl,tvenrl);

    visitnum=6;
    visit="Visit 6";
    visitdy=57;
    tvstrl="8 Weeks after start of treatment";
    tvenrl="";
    output;
    call missing(visitnum,visit,visitdy,tvstrl,tvenrl);

    visitnum=7;
    visit="Visit 7";
    visitdy=71;
    tvstrl="10 Weeks after start of treatment";
    tvenrl="";
    output;
    call missing(visitnum,visit,visitdy,tvstrl,tvenrl);

    visitnum=8;
    visit="Visit 8";
    visitdy=85;
    tvstrl="12 Weeks after start of treatment";
    tvenrl="";
    output;
    call missing(visitnum,visit,visitdy,tvstrl,tvenrl);

    visitnum=9;
    visit="Visit 9";
    visitdy=106;
    tvstrl="3 Weeks after end of treatment";
    tvenrl="";
    output;
    call missing(visitnum,visit,visitdy,tvstrl,tvenrl);

run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;