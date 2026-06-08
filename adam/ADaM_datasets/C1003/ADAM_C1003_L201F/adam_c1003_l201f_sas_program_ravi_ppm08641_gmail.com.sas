* ============================================================;
* Downloaded from myCSG lesson content;
* Lesson: ADAM_C1003_L201F;
* Content Type: sas_program;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;


*==============================================================================;
*program for the task;
*==============================================================================;

data adcm04;
	set adcm03;
	length prefl ontrtfl $1;

	*------------------------------------------------------------------------------;
	*PREFL;
	*------------------------------------------------------------------------------;
	if nmiss(astdtm,trtsdtm)=0 and astdtm lt trtsdtm then
		prefl='Y';
	else if nmiss(astdt,trtsdt)=0 and astdt lt trtsdt then
		prefl='Y';
	else if trtsdt ne . and astdt=. then
		prefl='Y';

	*------------------------------------------------------------------------------;
	*ONTRTFL;
	*------------------------------------------------------------------------------;
	if nmiss(astdtm,trtsdtm,trtedtm)=0 and (astdtm lt trtsdtm and aendt=.) then
		ontrtfl='Y';
	else if nmiss(astdtm,trtsdtm,trtedtm)=0 and (astdtm lt trtsdtm and aendtm ne . and aendtm ge trtsdtm) then
		ontrtfl='Y';
	else if nmiss(astdtm,trtsdtm,trtedtm)=0 and (astdtm lt trtsdtm and aendtm ne . and aendtm lt trtsdtm) then
		ontrtfl=' ';
	else if nmiss(astdtm,trtsdtm,trtedtm)=0 and astdtm ge trtsdtm and astdtm le trtedtm then
		ontrtfl='Y';
	else if nmiss(astdtm,trtsdtm,trtedtm)=0 and astdtm ge trtsdtm and astdtm gt trtedtm then
		ontrtfl=' ';
	else if nmiss(astdt,trtsdt,trtedt)=0 and (astdt lt trtsdt and aendt=.) then
		ontrtfl='Y';
	else if nmiss(astdt,trtsdt,trtedt)=0 and (astdt lt trtsdt and aendt ne . and aendt ge trtsdt) then
		ontrtfl='Y';
	else if nmiss(astdt,trtsdt,trtedt)=0 and astdt ge trtsdt and astdt le trtedt then
		ontrtfl='Y';
	else if trtsdt ne . and astdt=. and aendt=. then
		ontrtfl='Y';
	else if trtsdt ne . and astdt=. and aendt ne . and aendt ge trtsdt then
		ontrtfl='Y';

	* quick check flags vs expected; prefl_ok = (coalescec(prefl,' ') = coalescec(exp_prefl,' ')); ontrt_ok = (coalescec(ontrtfl,' ') = coalescec(exp_ontrtfl,' '));
run;

* ============================================================;
* End of downloaded content;
* Downloaded By: Ravi;
* Email: ppm08641@gmail.com;
* ============================================================;