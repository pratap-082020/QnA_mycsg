# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_TLB_L104
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

adlb<-tribble(
~usubjid,~avisitn,~anrind,~bnrind,~trt01an,~paramcd,~param,~avisit,~saffl,~paramn,
"101",1,"LOW","LOW",1,"NEUT","Neutrophils (10(*ESC*)6/L)","Month 1","Y",1,
"101",2,"NORMAL","LOW",1,"NEUT","Neutrophils (10(*ESC*)6/L)","Month 2","Y",1,
"101",3,"HIGH","LOW",1,"NEUT","Neutrophils (10(*ESC*)6/L)","Month 3","Y",1,
"102",1,"LOW","NORMAL",1,"NEUT","Neutrophils (10(*ESC*)6/L)","Month 1","Y",1,
"102",2,"NORMAL","NORMAL",1,"NEUT","Neutrophils (10(*ESC*)6/L)","Month 2","Y",1,
"102",3,"HIGH","NORMAL",1,"NEUT","Neutrophils (10(*ESC*)6/L)","Month 3","Y",1,
"103",1,"LOW","HIGH",2,"NEUT","Neutrophils (10(*ESC*)6/L)","Month 1","Y",1,
"103",2,"NORMAL","HIGH",2,"NEUT","Neutrophils (10(*ESC*)6/L)","Month 2","Y",1,
"103",3,"HIGH","HIGH",2,"NEUT","Neutrophils (10(*ESC*)6/L)","Month 3","Y",1,
"104",1,"NORMAL","NORMAL",2,"NEUT","Neutrophils (10(*ESC*)6/L)","Month 1","Y",1,
"104",2,"NORMAL","NORMAL",2,"NEUT","Neutrophils (10(*ESC*)6/L)","Month 2","Y",1,
"104",3,"NORMAL","NORMAL",2,"NEUT","Neutrophils (10(*ESC*)6/L)","Month 3","Y",1,
)

adsl<-tribble(
~usubjid,~trt01an,~saffl,
"101",1,"Y",
"102",1,"Y",
"103",2,"Y",
"104",2,"Y",
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================