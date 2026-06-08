# =========================================================
# CREATE ONLY FOLDERS
# =========================================================

# Set working directory
getwd()

setwd("~/Downloads/adam/chapter")

# Main folder
main_path <- "chapter"

# All lessons
lessons <- c(
  
  "ADaM_C1001_L101",
  "ADaM_C1001_L102",
  "ADaM_C1001_L102a",
  "ADaM_C1001_L103",
  "ADaM_C1001_L103a",
  "ADaM_C1001_L103b",
  "ADaM_C1001_L104",
  "ADaM_C1001_L105",
  "ADaM_C1001_L106",
  
  "ADaM_C1002_L101",
  "ADaM_C1002_L102",
  "ADaM_C1002_L102a",
  "ADaM_C1002_L103",
  
  "ADaM_C1003_L101",
  "ADaM_C1003_L102",
  "ADaM_C1003_L102a",
  "ADaM_C1003_L103",
  "ADaM_C1003_L103a",
  "ADAM_C1003_L201F",
  
  "ADaM_C1004_L101",
  "ADaM_C1004_L102",
  "ADaM_C1004_L103",
  "ADaM_C1004_L103a",
  "ADaM_C1004_L103b",
  "ADaM_C1004_L103c",
  "ADaM_C1004_L111",
  
  "ADaM_C1005_L101",
  "ADaM_C1005_L101a",
  "ADaM_C1005_L101b",
  "ADaM_C1005_L102",
  "ADaM_C1005_L103",
  
  "ADaM_C1006_L101",
  "ADaM_C1006_L101a",
  "ADaM_C1006_L101b",
  "ADaM_C1006_L102",
  "ADaM_C1006_L102a",
  "ADaM_C1006_L102b",
  "ADaM_C1006_L102c",
  "ADaM_C1006_L102d",
  "ADaM_C1006_L105",
  
  "ADaM_C1007_L101",
  "ADaM_C1007_L102",
  
  "ADaM_C1008_L101",
  
  "ADaM_C1009_L101",
  "ADaM_C1009_L102",
  "ADaM_C1009_L103",
  "ADaM_C1009_L104",
  "ADaM_C1009_L105",
  "ADaM_C1009_L106",
  
  "ADaM_C1010_L101",
  "ADaM_C1010_L102",
  "ADaM_C1010_L103",
  "ADaM_C1010_L103a",
  "ADaM_C1010_L111",
  "ADaM_C1010_L121",
  "ADaM_C1010_L131",
  "ADaM_C1010_L141",
  "ADaM_C1010_L151",
  
  "ADaM_C1011_L101",
  "ADaM_C1011_L101a",
  "ADaM_C1011_L101b",
  "ADaM_C1011_L101c",
  "ADaM_C1011_L101d",
  "ADaM_C1011_L201",
  
  "ADaM_C1012_L101",
  "ADaM_C1012_L102",
  
  "ADaM_C1013_L101",
  "ADaM_C1013_L102",
  "ADaM_C1013_L103",
  
  "ADaM_C1016_L101",
  
  "ADaM_ADSL_L1101",
  
  "ADaM_ADAE_L1101",
  
  "ADaM_ADCM_L1101",
  "ADaM_ADCM_LCMSUM01",
  
  "ADaM_ADEG_L1101",
  
  "ADaM_ADEXSUM_L1101",
  
  "ADaM_ADIS_LVAC01",
  
  "ADaM_ADPC_LOD101",
  
  "ADaM_ADQS_L1101",
  "ADaM_ADQS_LEASI01",
  
  "ADaM_ADRS_L1101",
  
  "ADaM_ADVS_L1101",
  
  "ADaM_BDS_LADICE01"
)

# =========================================================
# CREATE MAIN FOLDER
# =========================================================

dir.create(
  main_path,
  recursive = TRUE,
  showWarnings = FALSE
)

# =========================================================
# CREATE SUBFOLDERS
# =========================================================

for(folder in lessons){
  
  dir.create(
    file.path(main_path, folder),
    recursive = TRUE,
    showWarnings = FALSE
  )
  
  cat(
    "Created Folder:",
    folder,
    "\n"
  )
  
}

# =========================================================
# VERIFY
# =========================================================

list.files(main_path)