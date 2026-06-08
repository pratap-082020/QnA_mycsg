setwd("~/Desktop/SAS")

library(chromote)

# =====================================================
# MAIN SAVE LOCATION
# =====================================================

main_dir <- "SAS_Full_Website"

dir.create(main_dir, showWarnings = FALSE)

# =====================================================
# URLS
# =====================================================

urls <- c(
  
  "https://mycsg.in/sas.php?lesson=SAS_INTRO_L101",
  "https://mycsg.in/sas.php?lesson=SAS_INTRO_L102",
  "https://mycsg.in/sas.php?lesson=SAS_INTRO_L105",
  "https://mycsg.in/sas.php?lesson=SAS_INTRO_L106",
  
  "https://mycsg.in/sas.php?lesson=SAS_READRAW_L101",
  "https://mycsg.in/sas.php?lesson=SAS_READRAW_L102",
  
  "https://mycsg.in/sas.php?lesson=SAS_SUBSETTING_L101",
  "https://mycsg.in/sas.php?lesson=SAS_SUBSETTING_L201",
  
  "https://mycsg.in/sas.php?lesson=SAS_APPENDING_L101",
  "https://mycsg.in/sas.php?lesson=SAS_APPENDING_L102",
  "https://mycsg.in/sas.php?lesson=SAS_APPENDING_L103",
  "https://mycsg.in/sas.php?lesson=SAS_APPENDING_L104",
  
  "https://mycsg.in/sas.php?lesson=SAS_MERGING_L101",
  "https://mycsg.in/sas.php?lesson=SAS_MERGING_L103",
  "https://mycsg.in/sas.php?lesson=SAS_MERGING_L104",
  
  "https://mycsg.in/sas.php?lesson=SAS_DATASTEP_L080",
  "https://mycsg.in/sas.php?lesson=SAS_DATASTEP_L085",
  "https://mycsg.in/sas.php?lesson=SAS_DATASTEP_L101",
  "https://mycsg.in/sas.php?lesson=SAS_DATASTEP_L102",
  "https://mycsg.in/sas.php?lesson=SAS_DATASTEP_L103",
  "https://mycsg.in/sas.php?lesson=SAS_DATASTEP_L150",
  "https://mycsg.in/sas.php?lesson=SAS_DATASTEP_L151",
  "https://mycsg.in/sas.php?lesson=SAS_DATASTEP_L201",
  "https://mycsg.in/sas.php?lesson=SAS_DATASTEP_L202",
  
  "https://mycsg.in/sas.php?lesson=SAS_BYGROUPING_L101",
  "https://mycsg.in/sas.php?lesson=SAS_BYGROUPING_L103",
  
  "https://mycsg.in/sas.php?lesson=SAS_PDV_L101",
  "https://mycsg.in/sas.php?lesson=SAS_PDV_L102",
  
  "https://mycsg.in/sas.php?lesson=SAS_FUNCTIONS_L101",
  "https://mycsg.in/sas.php?lesson=SAS_FUNCTIONS_L103",
  "https://mycsg.in/sas.php?lesson=SAS_FUNCTIONS_L104",
  "https://mycsg.in/sas.php?lesson=SAS_FUNCTIONS_L201",
  "https://mycsg.in/sas.php?lesson=SAS_FUNCTIONS_L301",
  
  "https://mycsg.in/sas.php?lesson=SAS_PROCFREQ_L101",
  
  "https://mycsg.in/sas.php?lesson=SAS_PROCMEANS_L101",
  "https://mycsg.in/sas.php?lesson=SAS_PROCMEANS_L102",
  
  "https://mycsg.in/sas.php?lesson=SAS_PROCUNIVARIATE_L101",
  "https://mycsg.in/sas.php?lesson=SAS_PROCUNIVARIATE_L102",
  
  "https://mycsg.in/sas.php?lesson=SAS_PROCSORT_L101",
  "https://mycsg.in/sas.php?lesson=SAS_PROCSORT_L102",
  "https://mycsg.in/sas.php?lesson=SAS_PROCSORT_L103",
  "https://mycsg.in/sas.php?lesson=SAS_PROCSORT_L104",
  
  "https://mycsg.in/sas.php?lesson=SAS_PROCPRINT_L101",
  
  "https://mycsg.in/sas.php?lesson=SAS_PROCTRANSPOSE_L101",
  "https://mycsg.in/sas.php?lesson=SAS_PROCTRANSPOSE_L102",
  
  "https://mycsg.in/sas.php?lesson=SAS_PROCREPORT_L101",
  "https://mycsg.in/sas.php?lesson=SAS_PROCREPORT_L103",
  
  "https://mycsg.in/sas.php?lesson=SAS_PROCIMPORT_L101",
  "https://mycsg.in/sas.php?lesson=SAS_PROCIMPORT_L102",
  
  "https://mycsg.in/sas.php?lesson=SAS_PROCEXPORT_L101",
  
  "https://mycsg.in/sas.php?lesson=SAS_PROCCONTENTS_L101",
  
  "https://mycsg.in/sas.php?lesson=SAS_PROCDATASETS_L101",
  
  "https://mycsg.in/sas.php?lesson=SAS_PROCFORMAT_L101",
  "https://mycsg.in/sas.php?lesson=SAS_PROCFORMAT_L102",
  
  "https://mycsg.in/sas.php?lesson=SAS_PROCCOMPARE_L101",
  "https://mycsg.in/sas.php?lesson=SAS_PROCCOMPARE_L102",
  
  "https://mycsg.in/sas.php?lesson=SAS_PROCSQL_L101",
  "https://mycsg.in/sas.php?lesson=SAS_PROCSQL_L104",
  "https://mycsg.in/sas.php?lesson=SAS_PROCSQL_L105",
  "https://mycsg.in/sas.php?lesson=SAS_PROCSQL_L106",
  
  "https://mycsg.in/sas.php?lesson=SAS_MACVARS_L101",
  "https://mycsg.in/sas.php?lesson=SAS_MACVARS_L103",
  "https://mycsg.in/sas.php?lesson=SAS_MACVARS_L104",
  
  "https://mycsg.in/sas.php?lesson=SAS_MACROS_L101",
  "https://mycsg.in/sas.php?lesson=SAS_MACROS_L102",
  "https://mycsg.in/sas.php?lesson=SAS_MACROS_L103",
  "https://mycsg.in/sas.php?lesson=SAS_MACROS_L104",
  
  "https://mycsg.in/sas.php?lesson=SAS_LOGISSUES_L101",
  "https://mycsg.in/sas.php?lesson=SAS_LOGISSUES_L102",
  
  "https://mycsg.in/sas.php?lesson=SAS_GENERAL_L101",
  
  "https://mycsg.in/sas.php?lesson=SAS_COMMONLOGICS_L101",
  "https://mycsg.in/sas.php?lesson=SAS_COMMONLOGICS_L102",
  
  "https://mycsg.in/sas.php?lesson=SAS_ODS_L101"
  
)

# =====================================================
# SAVE COMPLETE WEBSITE
# =====================================================

save_complete_site <- function(full_url, save_folder){
  
  cat("\n====================================\n")
  cat("Opening:\n", full_url, "\n")
  cat("Saving to:\n", save_folder, "\n")
  cat("====================================\n")
  
  b <- ChromoteSession$new()
  
  try({
    
    # ---------------------------------
    # ENABLE NETWORK
    # ---------------------------------
    
    b$Network$enable()
    
    # ---------------------------------
    # STORE ALL RESPONSES
    # ---------------------------------
    
    all_files <- list()
    
    b$Network$responseReceived(function(msg){
      
      try({
        
        req_url <- msg$response$url
        mime <- msg$response$mimeType
        req_id <- msg$requestId
        
        all_files[[length(all_files)+1]] <<- list(
          url = req_url,
          mime = mime,
          requestId = req_id
        )
        
      }, silent = TRUE)
      
    })
    
    # ---------------------------------
    # OPEN PAGE
    # ---------------------------------
    
    b$Page$navigate(full_url)
    
    Sys.sleep(15)
    
    # ---------------------------------
    # AUTO SCROLL
    # ---------------------------------
    
    b$Runtime$evaluate("

      async function autoScroll(){

        await new Promise((resolve) => {

          let totalHeight = 0;
          let distance = 500;

          let timer = setInterval(() => {

            window.scrollBy(0, distance);

            totalHeight += distance;

            let scrollHeight = Math.max(
              document.body.scrollHeight,
              document.documentElement.scrollHeight
            );

            if(totalHeight >= scrollHeight){

              clearInterval(timer);

              resolve();

            }

          }, 300);

        });

      }

      autoScroll();

    ")
    
    Sys.sleep(15)
    
    # ---------------------------------
    # CREATE SAVE FOLDER
    # ---------------------------------
    
    dir.create(save_folder,
               recursive = TRUE,
               showWarnings = FALSE)
    
    # ---------------------------------
    # SAVE MAIN HTML
    # ---------------------------------
    
    html_content <- b$Runtime$evaluate("
      document.documentElement.outerHTML
    ")
    
    html_text <- html_content$result$value
    
    html_file <- file.path(
      save_folder,
      "index.html"
    )
    
    writeLines(
      html_text,
      html_file,
      useBytes = TRUE
    )
    
    # ---------------------------------
    # RESOURCE FOLDER
    # ---------------------------------
    
    resource_dir <- file.path(
      save_folder,
      "source_files"
    )
    
    dir.create(resource_dir,
               recursive = TRUE,
               showWarnings = FALSE)
    
    # ---------------------------------
    # DOWNLOAD ALL FILES
    # ---------------------------------
    
    for(i in seq_along(all_files)){
      
      item <- all_files[[i]]
      
      try({
        
        u <- item$url
        
        # REMOVE URL PARAMETERS
        clean_name <- sub("\\?.*", "", basename(u))
        
        if(clean_name == "")
          clean_name <- paste0("file_", i)
        
        dest <- file.path(resource_dir, clean_name)
        
        # AVOID DUPLICATES
        if(file.exists(dest)){
          
          ext <- tools::file_ext(clean_name)
          base <- tools::file_path_sans_ext(clean_name)
          
          clean_name <- paste0(
            base,
            "_",
            i,
            ifelse(ext == "", "", paste0(".", ext))
          )
          
          dest <- file.path(resource_dir, clean_name)
          
        }
        
        # DOWNLOAD RESOURCE
        download.file(
          url = u,
          destfile = dest,
          mode = "wb",
          quiet = TRUE
        )
        
        cat("Saved:", clean_name, "\n")
        
      }, silent = TRUE)
      
    }
    
    cat("\nSUCCESS!\n")
    
  }, silent = TRUE)
  
  b$close()
  
}

# =====================================================
# LOOP
# =====================================================

for(base_url in urls){
  
  lesson <- sub(".*lesson=", "", base_url)
  
  folder_path <- file.path(
    main_dir,
    lesson
  )
  
  save_complete_site(
    full_url = base_url,
    save_folder = folder_path
  )
  
}

cat("\nALL WEBSITES SAVED!\n")