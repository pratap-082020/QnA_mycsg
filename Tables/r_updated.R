library(chromote)
library(jsonlite)

# =====================================================
# OUTPUT FOLDER
# =====================================================

main_path <- "TFL_PDFs"

dir.create(
  main_path,
  recursive = TRUE,
  showWarnings = FALSE
)

# =====================================================
# URLS
# =====================================================

urls <- c(
  "https://mycsg.in/tfl.php?area=tfl&concept=TABGEN&lesson=TFL_TABGEN_L201",
  "https://mycsg.in/tfl.php?area=tfl&concept=TABGEN&lesson=TFL_TABGEN_L202",
  "https://mycsg.in/tfl.php?area=tfl&concept=TABGEN&lesson=TFL_TABGEN_L301",
  "https://mycsg.in/tfl.php?area=tfl&concept=TABGEN&lesson=TFL_TABGEN_L302",
  "https://mycsg.in/tfl.php?area=tfl&concept=TABGEN&lesson=TFL_TABGEN_L401",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L100",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L101",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L102",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L103",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L103a",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L103b",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L104",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L105",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L105a",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L105a1",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L106",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L107",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L107a",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L108",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L108a",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L109",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L110",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L111",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L112",
  "https://mycsg.in/tfl.php?area=tfl&concept=TAE&lesson=TFL_TAE_L113",
  "https://mycsg.in/tfl.php?area=tfl&concept=TCM&lesson=TFL_TCM_L101",
  "https://mycsg.in/tfl.php?area=tfl&concept=TCM&lesson=TFL_TCM_L102",
  "https://mycsg.in/tfl.php?area=tfl&concept=TDM&lesson=TFL_TDM_L100",
  "https://mycsg.in/tfl.php?area=tfl&concept=TDM&lesson=TFL_TDM_L101",
  "https://mycsg.in/tfl.php?area=tfl&concept=TDS&lesson=TFL_TDS_L101",
  "https://mycsg.in/tfl.php?area=tfl&concept=TDS&lesson=TFL_TDS_L102",
  "https://mycsg.in/tfl.php?area=tfl&concept=TDS&lesson=TFL_TDS_L102a",
  "https://mycsg.in/tfl.php?area=tfl&concept=TEG&lesson=TFL_TEG_L101",
  "https://mycsg.in/tfl.php?area=tfl&concept=TEG&lesson=TFL_TEG_L102",
  "https://mycsg.in/tfl.php?area=tfl&concept=TEG&lesson=TFL_TEG_L103",
  "https://mycsg.in/tfl.php?area=tfl&concept=TEG&lesson=TFL_TEG_L104",
  "https://mycsg.in/tfl.php?area=tfl&concept=TEG&lesson=TFL_TEG_L105",
  "https://mycsg.in/tfl.php?area=tfl&concept=TEG&lesson=TFL_TEG_L106",
  "https://mycsg.in/tfl.php?area=tfl&concept=TEG&lesson=TFL_TEG_L106a",
  "https://mycsg.in/tfl.php?area=tfl&concept=TEG&lesson=TFL_TEG_L106b",
  "https://mycsg.in/tfl.php?area=tfl&concept=TEX&lesson=TFL_TEX_L101",
  "https://mycsg.in/tfl.php?area=tfl&concept=TLB&lesson=TFL_TLB_L101",
  "https://mycsg.in/tfl.php?area=tfl&concept=TLB&lesson=TFL_TLB_L102",
  "https://mycsg.in/tfl.php?area=tfl&concept=TLB&lesson=TFL_TLB_L103",
  "https://mycsg.in/tfl.php?area=tfl&concept=TLB&lesson=TFL_TLB_L104",
  "https://mycsg.in/tfl.php?area=tfl&concept=TLB&lesson=TFL_TLB_L105",
  "https://mycsg.in/tfl.php?area=tfl&concept=TLB&lesson=TFL_TLB_L106",
  "https://mycsg.in/tfl.php?area=tfl&concept=TMH&lesson=TFL_TMH_L101",
  "https://mycsg.in/tfl.php?area=tfl&concept=TPC&lesson=TFL_TPC_L101",
  "https://mycsg.in/tfl.php?area=tfl&concept=TPE&lesson=TFL_TPE_L101",
  "https://mycsg.in/tfl.php?area=tfl&concept=TPP&lesson=TFL_TPP_L101",
  "https://mycsg.in/tfl.php?area=tfl&concept=TRS&lesson=TFL_TRS_L103"
)

# =====================================================
# TABS
# =====================================================

sections <- c(
  "LD",
  "SASVID",
  "SASPROG",
  "SASDATA",
  "TIDYVERSEPROG",
  "CD",
  "IMG"
)

# =====================================================
# START CHROME
# =====================================================

b <- ChromoteSession$new()

# Normal browser size
b$Emulation$setDeviceMetricsOverride(
  width = 1366,
  height = 3366,
  deviceScaleFactor = 1,
  mobile = FALSE
)

# =====================================================
# PROCESS LESSONS
# =====================================================

for(main_url in urls){
  
  lesson <- sub(".*lesson=", "", main_url)
  
  lesson_folder <- file.path(
    main_path,
    lesson
  )
  
  dir.create(
    lesson_folder,
    recursive = TRUE,
    showWarnings = FALSE
  )
  
  cat(
    "\n====================================\n",
    "Processing:", lesson,
    "\n====================================\n"
  )
  
  for(section in sections){
    
    pdf_file <- file.path(
      lesson_folder,
      paste0(section, ".pdf")
    )
    
    cat(
      "Downloading:",
      section,
      "\n"
    )
    
    try({
      
      # =====================================
      # OPEN PAGE
      # =====================================
      
      b$Page$navigate(main_url)
      
      Sys.sleep(1)
      
      # =====================================
      # OPEN TAB USING HASH
      # =====================================
      
      b$Runtime$evaluate(
        sprintf(
          "location.hash='%s';",
          section
        )
      )
      
      # =====================================
      # CLICK TAB IF PRESENT
      # =====================================
      
      b$Runtime$evaluate(
        sprintf("
        document.querySelectorAll('a').forEach(function(x){

          var txt = (x.innerText || '').toUpperCase();

          if(txt.includes('%s')){
            x.click();
          }

        });
        ", toupper(section))
      )
      
      Sys.sleep(1)
      
      # =====================================
      # EXPAND SCROLLABLE CONTAINERS
      # =====================================
      
      b$Runtime$evaluate("
      document.querySelectorAll('*').forEach(function(el){

        el.style.maxHeight='none';
        el.style.overflow='visible';
        el.style.overflowY='visible';
        el.style.overflowX='visible';

      });
      ")
      
      # =====================================
      # REDUCE ZOOM
      # =====================================
      
      b$Runtime$evaluate("
      document.body.style.zoom='70%';
      ")
      
      # =====================================
      # FORCE FULL RENDER
      # =====================================
      
      b$Runtime$evaluate("
      window.scrollTo(0,document.body.scrollHeight);
      ")
      
      Sys.sleep(1)
      
      b$Runtime$evaluate("
      window.scrollTo(0,0);
      ")
      
      Sys.sleep(1)
      
      # =====================================
      # PDF
      # =====================================
      
      pdf_data <- b$Page$printToPDF(
        printBackground = TRUE,
        preferCSSPageSize = TRUE,
        scale = 0.7,
        landscape = FALSE,
        marginTop = 0.2,
        marginBottom = 0.2,
        marginLeft = 0.2,
        marginRight = 0.2
      )
      
      writeBin(
        jsonlite::base64_dec(
          pdf_data$data
        ),
        pdf_file
      )
      
      cat(
        "Saved:",
        pdf_file,
        "\n"
      )
      
    }, silent = TRUE)
    
  }
  
}

cat(
  "\n====================================\n",
  "DONE",
  "\n====================================\n"
)