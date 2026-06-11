# ============================================================
# Downloaded from myCSG lesson content
# Lesson: MACROS_GEN_L310
# Content Type: r_data
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================

demog<-tribble(
~study,~pt,~sex,
"CSG001","1001","Male",
"CSG001","1002","Female",
"CSG001","1003","Male",
"CSG001","1004","Male",
"CSG001","1005","Male",
"CSG001","1006","Female",
"CSG001","1007","Male",
"CSG001","1008","Female",
)

medhis<-tribble(
~study,~pt,~mhvt,
"CSG001","1004","Hypercholesterolemia",
"CSG001","1005","Atrial Fibrillation",
"CSG001","1006","Headaches",
"CSG001","1007","Anemia",
"CSG001","1008","Bilateral Lower Exteremity Edema",
)

conmeds<-tribble(
~study,~pt,~cmvt,
"CSG001","1004","OMEPRAZOLE",
"CSG001","1006","PARACETAMOL",
"CSG001","1007","LOPERAMIDE",
)



# ============================================================
# End of downloaded content
# Downloaded By: Ravi
# Email: ppm08641@gmail.com
# ============================================================