* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: SDTM_TE_LCSG801;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.SDTM\SDTM_TE\SDTM_TE_LCSG801\SDTM_TE_LCSG801;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

*==============================================================================;
*Create trial elements dataset;
*==============================================================================;

data te;
    length STUDYID $10 DOMAIN $2 ETCD $8 ELEMENT TESTRL TEENRL $200 TEDUR $10;

    studyid="CSG801";
    domain="TE";

    etcd="SCRN";
    element="Screening";
    testrl="Informed consent";
    teenrl="Screening assessments are complete; up to 4 Weeks after start of the element";
    tedur="P4W";
    output;
    call missing(etcd,element,testrl,teenrl,tedur);

    etcd="CSG300";
    element="CSG801 300 mg Q2W";
    testrl="First dose of CSG801, where dose is 300 mg";
    teenrl="12 Weeks after start of the element";
    tedur="P12W";
    output;
    call missing(etcd,element,testrl,teenrl,tedur);

    etcd="CSG600";
    element="CSG801 600 mg Q2W";
    testrl="First dose of CSG801, where dose is 600 mg";
    teenrl="12 Weeks after start of the element";
    tedur="P12W";
    output;
    call missing(etcd,element,testrl,teenrl,tedur);

    etcd="PBO";
    element="Placebo Q2W";
    testrl="First dose of placebo";
    teenrl="12 Weeks after start of the element";
    tedur="P12W";
    output;
    call missing(etcd,element,testrl,teenrl,tedur);

    etcd="FU";
    element="Follow-up";
    testrl="One day after last dose of study drug";
    teenrl="3 Weeks after start of the element";
    tedur="P3W";
    output;
    call missing(etcd,element,testrl,teenrl,tedur);

run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;