# ============================================================
# Downloaded from myCSG lesson content
# Lesson: MACROS_ADaM_L130
# Content Type: r_program
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

# Important: Replace <path> with the folder where you saved the downloaded lesson files.
# Important: In R, use forward slash as the folder separator.

library(tidyverse)
library(rlang)

rm(list=ls())

vs<-tribble(
  ~usubjid,~paramcd,~param,~vsdtc,~aval,~trtsdt,~anrind,
  "1001","SYSBP","Systolic Blood Pressure (mmHg)","2010-01-02",120,18267,"Normal",
  "1001","SYSBP","Systolic Blood Pressure (mmHg)","2010-01-03",120,18267,"Normal",
  "1001","SYSBP","Systolic Blood Pressure (mmHg)","2010-01-04",NA,18267,"",
  "1001","SYSBP","Systolic Blood Pressure (mmHg)","2010-01-05",130,18267,"Normal",
  "1001","SYSBP","Systolic Blood Pressure (mmHg)","2010-01-06",120,18267,"Normal",
  "1001","DIABP","Diastolic Blood Pressure (mmHg)","2010-01-03",80,18267,"Normal",
  "1001","DIABP","Diastolic Blood Pressure (mmHg)","2010-01-04",NA,18267,"",
  "1001","DIABP","Diastolic Blood Pressure (mmHg)","2010-01-05",85,18267,"Normal",
  "1001","DIABP","Diastolic Blood Pressure (mmHg)","2010-01-06",80,18267,"Normal",
)

vs01 <- vs %>% 
  mutate(adt = as.Date(vsdtc,format="%Y-%m-%d"),
         trtsdt = as.Date(trtsdt, origin="1960-01-01"))

#==============================================================================;

#==============================================================================
# Deriving baseline flag, base, chg, pchg, r2base, crity variables
#==============================================================================

# base01 <- adis01 %>% 
#   filter(!is.na(adt) & !is.na(trtsdt) & !is.na(aval) & adt<=trtsdt)
# 
# base02 <- base01 %>% 
#   arrange(usubjid,paramcd,adt) %>% 
#   group_by(usubjid,paramcd) %>% 
#   slice_tail() %>% 
#   ungroup() %>% 
#   mutate(ablfl="Y") %>% 
#   select(usubjid,paramcd,adt,ablfl,base=aval, basec=avalc, bnrind=anrind)
# 
# adis02 <- adis01 %>% 
#   left_join(
#     select(base02,usubjid,paramcd,adt,ablfl),
#     by=c("usubjid","paramcd","adt")
#   )
# 
# adis03 <- adis02 %>% 
#   left_join(
#     select(base02,usubjid,paramcd,base),
#     by=c("usubjid","paramcd")
#   )

#==============================================================================;
#Function definition;
#==============================================================================;

adam_create_ablfl_basevars <- function(indsn,
                                       filtercondition,
                                       sortvars,
                                       groupvars,
                                       sourcevars,
                                       basevars){
  
  base01 <- indsn %>%
    filter(!!!parse_exprs(filtercondition))

  base02 <- base01 %>%
    arrange(!!!parse_exprs(sortvars)) %>%
    group_by(!!!syms(groupvars)) %>%
    slice_tail() %>%
    ungroup() %>%
    mutate(ablfl="Y") 

  for (i in seq_along(sourcevars)){
    base02 <- base02 %>% 
      mutate(
        !!sym(basevars[i]):=!!sym(sourcevars[i])
      )
  }
  
  outdsn1 <- indsn %>%
    left_join(
      select(base02,!!!syms(sortvars),ablfl),
      by=sortvars
    )

  outdsn2 <- outdsn1 %>%
    left_join(
      select(base02,!!!syms(groupvars),!!!syms(basevars)),
      by=groupvars
    )
  
  return(outdsn2)
}

vs02 <- adam_create_ablfl_basevars(
  indsn=vs01,
   filtercondition='!is.na(adt) & !is.na(trtsdt) & !is.na(aval) & adt<=trtsdt',
   sortvars=c("usubjid","paramcd","adt"),
   groupvars=c("usubjid","paramcd"),
   sourcevars=c("aval"),
   basevars=c("base")
)

vs02a <- adam_create_ablfl_basevars(
  indsn=vs01,
  filtercondition='!is.na(adt) & !is.na(trtsdt) & !is.na(aval) & adt<=trtsdt',
  sortvars=c("usubjid","paramcd","adt"),
  groupvars=c("usubjid","paramcd"),
  sourcevars=c("aval","anrind"),
  basevars=c("base","bnrind")
)

vs02b <- adam_create_ablfl_basevars(
  indsn=vs01,
  filtercondition='!is.na(adt) & !is.na(trtsdt) & !is.na(aval) & adt<=trtsdt',
  sortvars=c("usubjid","paramcd","adt"),
  groupvars=c("usubjid","paramcd"),
  sourcevars=c("aval","anrind","adt"),
  basevars=c("base","bnrind","basedt")
)

vs02c <- adam_create_ablfl_basevars(
  indsn=vs01,
  filtercondition='!is.na(adt) & !is.na(trtsdt) & !is.na(aval) & adt<trtsdt',
  sortvars=c("usubjid","paramcd","adt"),
  groupvars=c("usubjid","paramcd"),
  sourcevars=c("aval","anrind","adt"),
  basevars=c("base","bnrind","basedt")
)

# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================