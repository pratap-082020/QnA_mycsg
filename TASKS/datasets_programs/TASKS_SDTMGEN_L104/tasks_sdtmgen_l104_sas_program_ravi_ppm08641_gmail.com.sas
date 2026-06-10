* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: TASKS_SDTMGEN_L104;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;

* Important: Replace <path> with the folder where you saved the downloaded lesson files.;
* Important: On Windows SAS, use backslash as the folder separator.;

/*=========================================================
Include the data file
=========================================================*/
%let root2=&root.TASKS\TASKS_SDTMGEN\TASKS_SDTMGEN_L104\TASKS_SDTMGEN_L104;

%include "&root2._data.sas";

options validvarname=upcase;
/*=========================================================
Programming for the Task
=========================================================*/

*==============================================================================;
*Fetch VISITNUM, VISIT and VISITDY;
*==============================================================================;

proc sql;
   create table echo01 as
      select a.*,b.visitnum,b.visit, b.visitdy
      from echo as a
      left join
      visit_mapping as b
      on a.folderseq=b.collected_visitnum and upcase(a.foldername)=upcase(b.collected_visit)
     order by pt,folderseq
      ;
quit;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;