# ============================================================
# Downloaded from myCSG lesson content
# Lesson: TFL_TABGEN_L401
# Content Type: r_program
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

library(tidyverse)

rm(list=ls())

grouplabels <- c("1"="Age (years)", "3"="Height (cm)", "2"="Sex, n(%)", "4"="Race, n(%)")

#==============================================================================;
#input data;
#==============================================================================;

adsl<-tribble(
  ~studyid,~usubjid,~trt01pn,~age,~heightbl,~asex,~arace,~fasfl,~trt01p,
  "MYCSG","MYCSG-1001",1,23,165,"Female","Asian","Y","Dose level 1",
  "MYCSG","MYCSG-1002",3,68,NA,"","Black or African American","Y","Dose level 3",
  "MYCSG","MYCSG-1003",3,NA,153,"Male","","Y","Dose level 3",
  "MYCSG","MYCSG-1004",3,35,152,"Female","White","Y","Dose level 3",
  "MYCSG","MYCSG-1006",3,54,172,"Male","Not reported","Y","Dose level 3",
  "MYCSG","MYCSG-1007",3,45,165,"Male","Not reported","N","Dose level 3",
)


#==============================================================================;
#subset required records;
#==============================================================================;

adsl01 <- adsl %>% 
  filter(fasfl=="Y")


#==============================================================================;
#account subjects under individual treatment and total group;
#==============================================================================;

adsl02 <- bind_rows(
  mutate(adsl01,treatment=trt01pn),
  mutate(adsl01,treatment=4)
)

#==============================================================================;
#restructure the data such analysis variables are appearing as rows;
#==============================================================================;

adsl03_cont <- bind_rows(
  mutate(adsl02,group=1,dp=0,result=age),
  mutate(adsl02,group=3,dp=1,result=heightbl),
)


#==============================================================================;
#get descriptive statistics;
#==============================================================================;

stats01 <- adsl03_cont %>% 
  group_by(group,dp,treatment) %>% 
  summarize(
    
    nrecs=n(),
    
    result_n=sum(!is.na(result)),
    result_nmiss=sum(is.na(result)),
    
    result_mean=mean(result,na.rm=TRUE),
    result_sd=sd(result,na.rm=TRUE),
    result_median=median(result,na.rm=TRUE),
    result_q1=quantile(result,0.25,type=2,na.rm=TRUE),
    result_q3=quantile(result,0.75,type=2,na.rm=TRUE),
    result_min=min(result,na.rm=TRUE),
    result_max=max(result,na.rm=TRUE)
    
  ) %>% 
  ungroup() %>% 
  complete(nesting(group,dp),treatment=1:4,fill=list(result_n=0,result_nmiss=0))

#==============================================================================;
#process the statistics;
#==============================================================================;

stats02 <- stats01 %>% 
  mutate(
    
    maxint=str_length(trunc(max(result_max,na.rm = TRUE))),
    minint=str_length(trunc(min(result_min,na.rm = TRUE))),
    
    hint=max(minint,maxint),
    
    intfmt=str_c("%",hint,".0f"),
    asisfmt=if_else(dp==0,str_c("%",hint,".","0f"),
                    str_c("%",hint+dp+1,".",dp,"f")),
    
    plusonefmt=str_c("%",hint+(dp+1)+1,".",dp+1,"f"),
    plustwofmt=str_c("%",hint+(dp+2)+1,".",dp+2,"f"),
    
    n=if_else(is.na(result_n),"",sprintf(intfmt,result_n)),
    nmiss=if_else(is.na(result_nmiss),"",sprintf(intfmt,result_nmiss)),
    
    mean=if_else(is.na(result_mean),"",sprintf(plusonefmt,result_mean)),
    sd=if_else(is.na(result_sd),"",sprintf(plustwofmt,result_sd)),
    
    sd2 = if_else(!is.na(result_mean) & is.na(result_sd), "-", sd),
    sd3 = if_else(sd2!="", str_c(" (",sd2,")"), ""),    
    
    median=if_else(is.na(result_median),"",sprintf(plusonefmt,result_median)),
    q1=if_else(is.na(result_q1),"",sprintf(plusonefmt,result_q1)),
    q3=if_else(is.na(result_q3),"",sprintf(plusonefmt,result_q3)),
    
    min=if_else(is.na(result_min),"",sprintf(asisfmt,result_min)),
    max=if_else(is.na(result_max),"",sprintf(asisfmt,result_max)),
    
    nnmiss=str_c(n," (",str_trim(nmiss),")"),
    meansd=str_c(mean,sd3),
    q1q3=if_else(result_n!=0,str_c(q1,", ",str_trim(q3)),""),
    minmax=if_else(result_n!=0,str_c(min,", ",str_trim(max)),"")
  ) %>% 
  select(group,treatment,nnmiss,meansd,median,q1q3,minmax)


#==============================================================================;
#Transpose the data to make statistics appear as rows;
#==============================================================================;

stats03 <- stats02 %>% 
  pivot_longer(
    cols = c(nnmiss,meansd,median,q1q3,minmax),
    names_to = "name",
    values_to = "col1"
  )


stats04 <- stats03 %>% 
  mutate(
    grouplabel=grouplabels[as.character(group)],
    name=str_to_upper(name),
    statistic=case_when(
      name=="NNMISS" ~ "n (missing)",
      name=="MEANSD" ~ "Mean (SD)",
      name=="MEDIAN" ~ "Median",
      name=="Q1Q3" ~ "Q1, Q3",
      name=="MINMAX" ~ "Min, Max",
    ),
    
    intord=case_when(
      name=="NNMISS" ~ 1,
      name=="MEANSD" ~ 2,
      name=="MEDIAN" ~ 3,
      name=="Q1Q3" ~ 4,
      name=="MINMAX" ~ 5,
    )    
    
  )


#==============================================================================;
#transpose the data to make treatments appear as columns;
#==============================================================================;

stats05 <- stats04 %>% 
  pivot_wider(
    id_cols = c(group,grouplabel,intord,statistic),
    values_from = col1,
    names_from = treatment,
    names_prefix = "trt_"
  )



#==============================================================================;
#manipulate the data values as per presentation requirement;
#==============================================================================;

adsl03_cat <- 
  bind_rows(
    adsl02 %>%   mutate(group=2,statistic=if_else(asex=="","Missing",asex)),
    adsl02 %>%   mutate(group=4,statistic=if_else(arace=="","Missing",arace)),
  )


#==============================================================================;
#Get treatment totals;
#==============================================================================;

trttotals_pre <- adsl02 %>% 
  count(treatment)

dummy_treatments <- tibble(treatment=1:4)


trttotals <- dummy_treatments %>% 
  left_join(trttotals_pre, by="treatment") %>% 
  mutate(
    n=replace_na(n,0)
  ) %>% 
  rename(trttotal=n)

#==============================================================================;
#get the counts;
#==============================================================================;

counts01 <- adsl03_cat %>% 
  count(group,statistic,treatment)


#------------------------------------------------------------------------------;
#create dummy to contain all possible levels;
#------------------------------------------------------------------------------;

dummy01 <- tribble(
  ~group, ~intord, ~statistic,
  2,1,"Male",
  2,2,"Female",
  2,3,"Missing",
  4,1,"Asian",
  4,2,"Black or African American",
  4,3,"White",  
  4,4,"Not reported",  
  4,5,"Missing",  
)


dummy02 <- cross_join(dummy01,dummy_treatments)

#------------------------------------------------------------------------------;
#merge dummy rows with actual counts;
#------------------------------------------------------------------------------;


counts02 <- dummy02 %>% 
  left_join(counts01,by=c("group","statistic","treatment")) %>% 
  mutate(
    n=replace_na(n,0)
  ) %>% 
  rename(count=n)


#==============================================================================;
#calculate percentage;
#==============================================================================;

counts03 <- counts02 %>% 
  left_join(trttotals,by="treatment") %>% 
  mutate(
    percent=if_else(trttotal!=0,count/trttotal*100,NA),
    percentfmt=if_else(percent==100,"%3.0f","%4.1f"),
    
    percentc=if_else(count!=0,str_c(" (",sprintf(percentfmt,percent),")"),""),
    
    cp=if_else(count==0,"  0",str_c(count,percentc))
  )


#==============================================================================;
#restructure the dataset such treatments appear as columns;
#==============================================================================;


counts04 <- counts03 %>% 
  pivot_wider(
    id_cols = c(group,intord,statistic),
    names_from = treatment,
    values_from = cp,
    names_prefix = "trt_"
  ) %>% 
  mutate(
    grouplabel=grouplabels[as.character(group)],
  )


#==============================================================================;
#Combine continuous and categorical variables summary datasets;
#==============================================================================;


all01 <- bind_rows(
  stats05,
  counts04
) %>% 
  arrange(group,intord)




# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================