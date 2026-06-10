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
  "https://mycsg.in/tasks.php?area=tasks&concept=SDTMGEN&lesson=TASKS_SDTMGEN_L040",
  "https://mycsg.in/tasks.php?area=tasks&concept=SDTMGEN&lesson=TASKS_SDTMGEN_L050",
  "https://mycsg.in/tasks.php?area=tasks&concept=SDTMGEN&lesson=TASKS_SDTMGEN_L070a",
  "https://mycsg.in/tasks.php?area=tasks&concept=SDTMGEN&lesson=TASKS_SDTMGEN_L070a1",
  "https://mycsg.in/tasks.php?area=tasks&concept=SDTMGEN&lesson=TASKS_SDTMGEN_L071",
  "https://mycsg.in/tasks.php?area=tasks&concept=SDTMGEN&lesson=TASKS_SDTMGEN_L072",
  "https://mycsg.in/tasks.php?area=tasks&concept=SDTMGEN&lesson=TASKS_SDTMGEN_L073",
  "https://mycsg.in/tasks.php?area=tasks&concept=SDTMGEN&lesson=TASKS_SDTMGEN_L074",
  "https://mycsg.in/tasks.php?area=tasks&concept=SDTMGEN&lesson=TASKS_SDTMGEN_L075",
  "https://mycsg.in/tasks.php?area=tasks&concept=SDTMGEN&lesson=TASKS_SDTMGEN_L080",
  "https://mycsg.in/tasks.php?area=tasks&concept=SDTMGEN&lesson=TASKS_SDTMGEN_L101",
  "https://mycsg.in/tasks.php?area=tasks&concept=SDTMGEN&lesson=TASKS_SDTMGEN_L104",
  "https://mycsg.in/tasks.php?area=tasks&concept=SDTMGEN&lesson=TASKS_SDTMGEN_L108",
  "https://mycsg.in/tasks.php?area=tasks&concept=SDTMGEN&lesson=TASKS_SDTMGEN_L109",
  "https://mycsg.in/tasks.php?area=tasks&concept=SDTMGEN&lesson=TASKS_SDTMGEN_L110",
  "https://mycsg.in/tasks.php?area=tasks&concept=SDTMGEN&lesson=TASKS_SDTMGEN_L110a",
  "https://mycsg.in/tasks.php?area=tasks&concept=SDTMGEN&lesson=TASKS_SDTMGEN_L111",
  "https://mycsg.in/tasks.php?area=tasks&concept=SDTMGEN&lesson=TASKS_SDTMGEN_L112",
  "https://mycsg.in/tasks.php?area=tasks&concept=SDTMGEN&lesson=TASKS_SDTMGEN_L150",
  "https://mycsg.in/tasks.php?area=tasks&concept=SDTMGEN&lesson=TASKS_SDTMGEN_L160",
  "https://mycsg.in/tasks.php?area=tasks&concept=SDTMGEN&lesson=TASKS_SDTMGEN_L201",
  "https://mycsg.in/tasks.php?area=tasks&concept=SDTMGEN&lesson=TASKS_SDTMGEN_L221",
  "https://mycsg.in/tasks.php?area=tasks&concept=SDTMGEN&lesson=TASKS_SDTMGEN_L801F",
  "https://mycsg.in/tasks.php?area=tasks&concept=BL&lesson=TASKS_BL_L101",
  "https://mycsg.in/tasks.php?area=tasks&concept=BL&lesson=TASKS_BL_L102",
  "https://mycsg.in/tasks.php?area=tasks&concept=BL&lesson=TASKS_BL_L103",
  "https://mycsg.in/tasks.php?area=tasks&concept=BL&lesson=TASKS_BL_L104",
  "https://mycsg.in/tasks.php?area=tasks&concept=BL&lesson=TASKS_BL_L105",
  "https://mycsg.in/tasks.php?area=tasks&concept=BL&lesson=TASKS_BL_L106",
  "https://mycsg.in/tasks.php?area=tasks&concept=BL&lesson=TASKS_BL_L107",
  "https://mycsg.in/tasks.php?area=tasks&concept=HIS&lesson=TASKS_HIS_L1001",
  "https://mycsg.in/tasks.php?area=tasks&concept=HIS&lesson=TASKS_HIS_L1003",
  "https://mycsg.in/tasks.php?area=tasks&concept=HIS&lesson=TASKS_HIS_L1004",
  "https://mycsg.in/tasks.php?area=tasks&concept=HIS&lesson=TASKS_HIS_L1005",
  "https://mycsg.in/tasks.php?area=tasks&concept=HIS&lesson=TASKS_HIS_L1006",
  "https://mycsg.in/tasks.php?area=tasks&concept=HIS&lesson=TASKS_HIS_L1007",
  "https://mycsg.in/tasks.php?area=tasks&concept=HIS&lesson=TASKS_HIS_L1008",
  "https://mycsg.in/tasks.php?area=tasks&concept=HIS&lesson=TASKS_HIS_L1009",
  "https://mycsg.in/tasks.php?area=tasks&concept=HIS&lesson=TASKS_HIS_L2001",
  "https://mycsg.in/tasks.php?area=tasks&concept=HIS&lesson=TASKS_HIS_L2011",
  "https://mycsg.in/tasks.php?area=tasks&concept=HIS&lesson=TASKS_HIS_L2021",
  "https://mycsg.in/tasks.php?area=tasks&concept=HIS&lesson=TASKS_HIS_L2031",
  "https://mycsg.in/tasks.php?area=tasks&concept=HIS&lesson=TASKS_HIS_L2041",
  "https://mycsg.in/tasks.php?area=tasks&concept=Lab&lesson=TASKS_Lab_L101",
  "https://mycsg.in/tasks.php?area=tasks&concept=Lab&lesson=TASKS_Lab_L102",
  "https://mycsg.in/tasks.php?area=tasks&concept=Lab&lesson=TASKS_Lab_L103",
  "https://mycsg.in/tasks.php?area=tasks&concept=Lab&lesson=TASKS_Lab_L201",
  "https://mycsg.in/tasks.php?area=tasks&concept=Lab&lesson=TASKS_Lab_L202",
  "https://mycsg.in/tasks.php?area=tasks&concept=Lab&lesson=TASKS_Lab_L203",
  "https://mycsg.in/tasks.php?area=tasks&concept=Lab&lesson=TASKS_Lab_L204",
  "https://mycsg.in/tasks.php?area=tasks&concept=Lab&lesson=TASKS_Lab_L205",
  "https://mycsg.in/tasks.php?area=tasks&concept=Lab&lesson=TASKS_Lab_L206",
  "https://mycsg.in/tasks.php?area=tasks&concept=Lab&lesson=TASKS_Lab_L207",
  "https://mycsg.in/tasks.php?area=tasks&concept=Lab&lesson=TASKS_Lab_L208",
  "https://mycsg.in/tasks.php?area=tasks&concept=Lab&lesson=TASKS_Lab_L209",
  "https://mycsg.in/tasks.php?area=tasks&concept=Lab&lesson=TASKS_Lab_L210",
  "https://mycsg.in/tasks.php?area=tasks&concept=Lab&lesson=TASKS_Lab_L211",
  "https://mycsg.in/tasks.php?area=tasks&concept=Lab&lesson=TASKS_Lab_L212",
  "https://mycsg.in/tasks.php?area=tasks&concept=Lab&lesson=TASKS_Lab_L213",
  "https://mycsg.in/tasks.php?area=tasks&concept=Lab&lesson=TASKS_Lab_L214",
  "https://mycsg.in/tasks.php?area=tasks&concept=Lab&lesson=TASKS_Lab_L215",
  "https://mycsg.in/tasks.php?area=tasks&concept=Lab&lesson=TASKS_Lab_L216",
  "https://mycsg.in/tasks.php?area=tasks&concept=Lab&lesson=TASKS_Lab_L217",
  "https://mycsg.in/tasks.php?area=tasks&concept=Lab&lesson=TASKS_Lab_L218",
  "https://mycsg.in/tasks.php?area=tasks&concept=Lab&lesson=TASKS_Lab_L219",
  "https://mycsg.in/tasks.php?area=tasks&concept=Lab&lesson=TASKS_Lab_L220",
  "https://mycsg.in/tasks.php?area=tasks&concept=Lab&lesson=TASKS_Lab_L221",
  "https://mycsg.in/tasks.php?area=tasks&concept=Lab&lesson=TASKS_Lab_L222",
  "https://mycsg.in/tasks.php?area=tasks&concept=Lab&lesson=TASKS_Lab_L223",
  "https://mycsg.in/tasks.php?area=tasks&concept=Lab&lesson=TASKS_Lab_L224",
  "https://mycsg.in/tasks.php?area=tasks&concept=Lab&lesson=TASKS_Lab_L225",
  "https://mycsg.in/tasks.php?area=tasks&concept=Lab&lesson=TASKS_Lab_L226",
  "https://mycsg.in/tasks.php?area=tasks&concept=Lab&lesson=TASKS_Lab_L227",
  "https://mycsg.in/tasks.php?area=tasks&concept=Lab&lesson=TASKS_Lab_L228",
  "https://mycsg.in/tasks.php?area=tasks&concept=Lab&lesson=TASKS_Lab_L229",
  "https://mycsg.in/tasks.php?area=tasks&concept=Lab&lesson=TASKS_Lab_L230"
)

# =====================================================
# TABS
# =====================================================

sections <- c(
  "LD",
  "SPEC",
  "SASPROG",
  "SASDATA",
  "TIDYVERSEPROG",
  "RTVDATA"
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

