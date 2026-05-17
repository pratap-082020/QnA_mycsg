* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_TA_LCSG801;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_TA\SDTM_TA_LCSG801\SDTM_TA_LCSG801;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

data ta;
    length STUDYID $10 DOMAIN $2 ARMCD $8 ARM $40 TAETORD 8 ETCD $8 ELEMENT TABRANCH TATRANS EPOCH $200;
    studyid="CSG801";
    domain="TA";

    *------------------------------------------------------------------------------;
    *Arm 1 - 300 mg;
    *------------------------------------------------------------------------------;

    armcd="CSG300";
    arm="CSG801 300 mg Q2W";

    *element 1;

    taetord=1;
    etcd="SCRN";
    element="Screening";
    tabranch="Randomized to CSG801 300 mg Q2W";
    tatrans="";
    epoch="SCREENING";
    output;
    call missing(taetord,etcd,element,tabranch,tatrans,epoch);

    *element 2;

    taetord=2;
    etcd="CSG300";
    element="CSG801 300 mg Q2W";
    tabranch="";
    tatrans="";
    epoch="TREATMENT";
    output;
    call missing(taetord,etcd,element,tabranch,tatrans,epoch);

    *element 3;
    taetord=3;
    etcd="FU";
    element="Follow-up";
    tabranch="";
    tatrans="";
    epoch="FOLLOW-UP";
    output;
    call missing(taetord,etcd,element,tabranch,tatrans,epoch);

    *------------------------------------------------------------------------------;
    *Arm 2 - 600 mg;
    *------------------------------------------------------------------------------;

    armcd="CSG600";
    arm="CSG801 600 mg Q2W";

    *element 1;

    taetord=1;
    etcd="SCRN";
    element="Screening";
    tabranch="Randomized to CSG801 600 mg Q2W";
    tatrans="";
    epoch="SCREENING";
    output;
    call missing(taetord,etcd,element,tabranch,tatrans,epoch);

    *element 2;

    taetord=2;
    etcd="CSG600";
    element="CSG801 600 mg Q2W";
    tabranch="";
    tatrans="";
    epoch="TREATMENT";
    output;
    call missing(taetord,etcd,element,tabranch,tatrans,epoch);

    *element 3;
    taetord=3;
    etcd="FU";
    element="Follow-up";
    tabranch="";
    tatrans="";
    epoch="FOLLOW-UP";
    output;
    call missing(taetord,etcd,element,tabranch,tatrans,epoch);

    *------------------------------------------------------------------------------;
    *Arm 3 - Placebo;
    *------------------------------------------------------------------------------;

    armcd="PBO";
    arm="Placebo Q2W";

    *element 1;

    taetord=1;
    etcd="SCRN";
    element="Screening";
    tabranch="Randomized to Placebo Q2W";
    tatrans="";
    epoch="SCREENING";
    output;
    call missing(taetord,etcd,element,tabranch,tatrans,epoch);

    *element 2;

    taetord=2;
    etcd="PBO";
    element="Placebo Q2W";
    tabranch="";
    tatrans="";
    epoch="TREATMENT";
    output;
    call missing(taetord,etcd,element,tabranch,tatrans,epoch);

    *element 3;
    taetord=3;
    etcd="FU";
    element="Follow-up";
    tabranch="";
    tatrans="";
    epoch="FOLLOW-UP";
    output;
    call missing(taetord,etcd,element,tabranch,tatrans,epoch);

run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;