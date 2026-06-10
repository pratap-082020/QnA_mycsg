* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: TASKS_SDTMGEN_L108;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

* Important: Replace <path> with the folder where you saved the downloaded lesson files.;
* Important: On Windows SAS, use backslash as the folder separator.;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.TASKS\TASKS_SDTMGEN\TASKS_SDTMGEN_L108\TASKS_SDTMGEN_L108;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

/*=========================================================
Create variables which are directly based on raw data
=========================================================*/
/*----------------------------------------------------------
Create a separate record for each test collected using output statements
----------------------------------------------------------*/
data cv01;
   set echo;
   length cvtestcd $8 ;
   if upcase(echo_yn)="NO" then do;
      cvstat="NOT DONE";
      cvtestcd="CVALL";
      output;
   end;
   else if upcase(echo_yn)="YES" then do;
      cvtestcd="LVEF";
      if missing(lvef) then do;
         cvstat="NOT DONE";
      end;
      else do;
         cvorres=lvef;
         cvorresu="%";
      end;

      output;

      call missing(cvtestcd,cvstat,cvorres,cvorresu);
      cvtestcd="RVEF_E";
      if missing(rvef) then do;
         cvstat="NOT DONE";
      end;
      else do;
         cvorres=rvef;
         cvorresu="%";
      end;

      output;

   end;
run;

/*=========================================================
Create other common variables
=========================================================*/

data cv02;
    set cv01;
    cvstresc=cvorres;
    cvstresu=cvorresu;
    cvstresn=input(cvstresc,??best.);
    if echodat ne "" then cvdtc=put(input(echodat,date11.),yymmdd10.);
run;
data output;
    set cv02;
    keep project subject cvtestcd cvorres cvorresu cvstresn cvstat cvdtc foldername;
run;

proc sort data=output;
    by subject cvtestcd cvdtc;
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;