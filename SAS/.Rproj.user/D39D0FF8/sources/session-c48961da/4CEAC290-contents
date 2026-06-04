# =====================================================
# MAIN DIRECTORY
# =====================================================

main_dir <- "~/Downloads/folder"   # Change if needed
setwd(main_dir)
getwd()


# =====================================================
# LESSON NAMES IN REQUIRED ORDER
# =====================================================

new_names <- c(
  "Index",
  "SAS_INTRO_L101",
  "SAS_INTRO_L102",
  "SAS_INTRO_L105",
  "SAS_INTRO_L106",
  "SAS_READRAW_L101",
  "SAS_READRAW_L102",
  "SAS_SUBSETTING_L101",
  "SAS_SUBSETTING_L201",
  "SAS_APPENDING_L101",
  "SAS_APPENDING_L102",
  "SAS_APPENDING_L103",
  "SAS_APPENDING_L104",
  "SAS_MERGING_L101",
  "SAS_MERGING_L103",
  "SAS_MERGING_L104",
  "SAS_DATASTEP_L080",
  "SAS_DATASTEP_L085",
  "SAS_DATASTEP_L101",
  "SAS_DATASTEP_L102",
  "SAS_DATASTEP_L103",
  "SAS_DATASTEP_L150",
  "SAS_DATASTEP_L151",
  "SAS_DATASTEP_L201",
  "SAS_DATASTEP_L202",
  "SAS_BYGROUPING_L101",
  "SAS_BYGROUPING_L103",
  "SAS_PDV_L101",
  "SAS_PDV_L102",
  "SAS_FUNCTIONS_L101",
  "SAS_FUNCTIONS_L103",
  "SAS_FUNCTIONS_L104",
  "SAS_FUNCTIONS_L201",
  "SAS_FUNCTIONS_L301",
  "SAS_PROCFREQ_L101",
  "SAS_PROCMEANS_L101",
  "SAS_PROCMEANS_L102",
  "SAS_PROCUNIVARIATE_L101",
  "SAS_PROCUNIVARIATE_L102",
  "SAS_PROCSORT_L101",
  "SAS_PROCSORT_L102",
  "SAS_PROCSORT_L103",
  "SAS_PROCSORT_L104",
  "SAS_PROCPRINT_L101",
  "SAS_PROCTRANSPOSE_L101",
  "SAS_PROCTRANSPOSE_L102",
  "SAS_PROCREPORT_L101",
  "SAS_PROCREPORT_L103",
  "SAS_PROCIMPORT_L101",
  "SAS_PROCIMPORT_L102",
  "SAS_PROCEXPORT_L101",
  "SAS_PROCCONTENTS_L101",
  "SAS_PROCDATASETS_L101",
  "SAS_PROCFORMAT_L101",
  "SAS_PROCFORMAT_L102",
  "SAS_PROCCOMPARE_L101",
  "SAS_PROCCOMPARE_L102",
  "SAS_PROCSQL_L101",
  "SAS_PROCSQL_L104",
  "SAS_PROCSQL_L105",
  "SAS_PROCSQL_L106",
  "SAS_MACVARS_L101",
  "SAS_MACVARS_L103",
  "SAS_MACVARS_L104",
  "SAS_MACROS_L101",
  "SAS_MACROS_L102",
  "SAS_MACROS_L103",
  "SAS_MACROS_L104",
  "SAS_LOGISSUES_L101",
  "SAS_LOGISSUES_L102",
  "SAS_GENERAL_L101",
  "SAS_COMMONLOGICS_L101",
  "SAS_COMMONLOGICS_L102",
  "SAS_ODS_L101"
)

# =====================================================
# FIND ALL sas.php FILES
# =====================================================

all_files <- list.files(
  main_dir,
  recursive = TRUE,
  full.names = TRUE
)

cat(all_files, sep = "\n")

folders <- list.dirs(main_dir, recursive = FALSE)

for(f in folders){
  print(list.files(f, full.names = TRUE))
}


php_files <- c()

folders <- list.dirs(main_dir, recursive = FALSE)

for(f in folders){
  
  target <- file.path(f, "sas.php")
  
  if(file.exists(target)){
    php_files <- c(php_files, target)
  }
  
}

length(php_files)
php_files

# =====================================================
# SORT FOLDERS
# mycsg.in
# mycsg.in (1)
# mycsg.in (2)
# ...
# =====================================================

folder_num <- function(x){
  
  parts <- strsplit(dirname(dirname(x)), .Platform$file.sep)[[1]]
  folder <- tail(parts, 1)
  
  if(folder == "mycsg.in"){
    return(0)
  }
  
  if(grepl("\\([0-9]+\\)", folder)){
    return(as.numeric(gsub(".*\\(([0-9]+)\\).*", "\\1", folder)))
  }
  
  return(99999)
}

php_files <- php_files[order(sapply(php_files, folder_num))]

# =====================================================
# VALIDATION
# =====================================================

cat("sas.php files found:", length(php_files), "\n")

if(length(php_files) != length(new_names)){
  stop("Count mismatch between sas.php files and lesson names.")
}

# =====================================================
# CREATE OUTPUT FOLDER
# =====================================================

output_folder <- file.path(main_dir, "ALL_HTML_FILES")

dir.create(
  output_folder,
  recursive = TRUE,
  showWarnings = FALSE
)

# =====================================================
# RENAME TO HTML + COPY
# =====================================================

for(i in seq_along(php_files)){
  
  old_file <- php_files[i]
  
  new_file <- file.path(
    dirname(old_file),
    paste0(new_names[i], ".html")
  )
  
  # Copy sas.php content to html file
  file.copy(
    from = old_file,
    to   = new_file,
    overwrite = TRUE
  )
  
  # Delete old php file
  file.remove(old_file)
  
  # Copy to central folder
  file.copy(
    from = new_file,
    to   = file.path(
      output_folder,
      paste0(new_names[i], ".html")
    ),
    overwrite = TRUE
  )
  
  cat(sprintf("%03d -> %s\n", i, basename(new_file)))
}

cat("\n=================================\n")
cat("Completed Successfully\n")
cat("HTML files created:", length(new_names), "\n")
cat("Output Folder:\n")
cat(output_folder, "\n")
cat("=================================\n")

