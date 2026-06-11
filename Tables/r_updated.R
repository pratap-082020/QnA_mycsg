library(chromote)
library(jsonlite)

# =====================================================
# OUTPUT FOLDER
# =====================================================

main_path <- "Macros"

dir.create(
  main_path,
  recursive = TRUE,
  showWarnings = FALSE
)

# =====================================================
# URLS
# =====================================================

urls <- c(
  "https://mycsg.in/macros.php?area=macros&concept=ADaM&lesson=MACROS_ADaM_L110",
  "https://mycsg.in/macros.php?area=macros&concept=ADaM&lesson=MACROS_ADaM_L120",
  "https://mycsg.in/macros.php?area=macros&concept=ADaM&lesson=MACROS_ADaM_L130",
  "https://mycsg.in/macros.php?area=macros&concept=GEN&lesson=MACROS_GEN_L210",
  "https://mycsg.in/macros.php?area=macros&concept=GEN&lesson=MACROS_GEN_L310",
  "https://mycsg.in/macros.php?area=macros&concept=GEN&lesson=MACROS_GEN_L311",
  "https://mycsg.in/macros.php?area=macros&concept=GEN&lesson=MACROS_GEN_L312",
  "https://mycsg.in/macros.php?area=macros&concept=GEN&lesson=MACROS_GEN_L313",
  "https://mycsg.in/macros.php?area=macros&concept=GEN&lesson=MACROS_GEN_L401",
  "https://mycsg.in/macros.php?area=macros&concept=GEN&lesson=MACROS_GEN_L401",
  "https://mycsg.in/macros.php?area=macros&concept=GEN&lesson=MACROS_GEN_L402",
  "https://mycsg.in/macros.php?area=macros&concept=GEN&lesson=MACROS_GEN_L403",
  "https://mycsg.in/macros.php?area=macros&concept=SDTM&lesson=MACROS_SDTM_L251",
  "https://mycsg.in/macros.php?area=macros&concept=SDTM&lesson=MACROS_SDTM_L261",
  "https://mycsg.in/macros.php?area=macros&concept=SDTM&lesson=MACROS_SDTM_L271",
  "https://mycsg.in/macros.php?area=macros&concept=SDTM&lesson=MACROS_SDTM_L281"
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
  "IMG",
  "SPEC"
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