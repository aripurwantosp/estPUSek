library(shinythemes)
library(shinyjs)
library(magrittr)
library(ggplot2)
library(googleVis)
# library(DT)

# Define server logic required to draw a histogram
function(input, output, session) {

  # Tab hasil proyeksi ----

  ## main ----
  ### selected input ----
  sel.indicator <- reactive({as.integer(input$indicator)}) #selected indicator
  sel.age <- reactive({input$sel_age})
  sel.year <- reactive({input$year})
  sel.prov <- reactive({as.integer(input$sel_prov)}) #selected province

  # indicator.fun <- reactive({ind.fun(sel.indicator())}) #selected indicator fun
  data.env <- function() estPUSek:::estPUSek.data.env #global data

  ### load data ----
  indicator_data <- reactive({ #indicator data
    estPUSek:::load.data.by.ind(sel.indicator(), sel.age())
  })

  data_by_year <- reactive({ #indicator data by year
    estPUSek:::data.by.year(indicator_data(), sel.year())
  })

  trends_data <- reactive({ #data for tredns
    estPUSek:::data.by.prov(indicator_data(), sel.prov())
  })

  struct_data <- reactive({ #data for structure
    df <-  estPUSek:::load.data.by.ind(sel.indicator())
    df <-  estPUSek:::data.by.year(df, sel.year())
    estPUSek:::data.by.prov(df, sel.prov())
  })

  ### reactive data ----
  data.for.table <- reactiveVal(data.frame(values = numeric()))

  ### indicator settings ----
  sel.ind.has.neg.val <- reactive({ #indicator has negative value
    estPUSek:::ind.settings()$has.neg.val[sel.indicator()]
  })

  sel.ind.has.struct <- reactive({ #available age structure
    estPUSek:::ind.settings()$has.struct[sel.indicator()]
  })

  ## sidebar ----

  # province selection
  output$prov_selection <- renderUI({
    province <- structure(
      data.env()$prov_code$kode_bps,
      names = data.env()$prov_code$prov_bps
    )
    do.call('selectInput', list('sel_prov', 'Provinsi:', province,
                                selected = province[1], multiple = TRUE, selectize = FALSE
    ))
  })

  output$age_sel <- renderUI({
    # if(indicator.fun() %in% ind.fun(4:12)){
    if(sel.indicator() %in% c(4:12)){
      age <- c(
        '7-12',
        '13-15',
        '16-18',
        '19-23'
      )
    }else{
      age <- structure(
        seq(0,80),
        names = c(paste0(seq(0,79)),'80+')
      )
    }

    #if inidcator is jumlah
    if(sel.indicator() %in% c(1:6)){
      multiple <- TRUE
      selectize = TRUE
    }else{
      multiple <- FALSE
      selectize = FALSE
    }

    selectInput('sel_age', 'Umur:', age, multiple = multiple,
                selected = age[1], selectize = selectize)
  })

  output$indicator_desc <- renderText({
    paste0('<small>', ind.definition(sel.indicator()), '</small>')
  })

  ## heat map ----
  output$heatmap <- renderPlot({
    df <- indicator_data()
    df <- df[df$kode_provinsi != 0, ]
    df <- df[!is.na(df$values), ]
    ref_code_prov <- estPUSek:::estPUSek.data.env$prov_code[,c('kode_bps','prov_bps')]
    df$provinsi <- factor(df$kode_provinsi,
                          levels = ref_code_prov$kode_bps[-1],
                          labels = ref_code_prov$prov_bps[-1])
    xlabel <- seq(2020,2050) %>%
      replace(., . %%5 != 0, '')
    # color condition
    if(sel.ind.has.neg.val()){
      cols <- c('blue','white','red')
    }else{
      cols <- c('white','red')
    }

    plt <- ggplot(df, aes(tahun, provinsi)) +
      geom_tile(aes(fill = values)) +
      labs(x='Tahun', y='Provinsi', fill = 'Nilai') +
      scale_fill_gradientn(colors = cols) +
      scale_x_continuous(breaks = seq(2020,2050),
                         labels = xlabel) +
      theme_minimal() +
      theme(panel.grid = element_blank(),
            axis.ticks = element_line(color='gray20', linewidth = .2),
            legend.position = 'bottom',
            legend.title = element_text(size=10),
            legend.title.position = 'top')

    plt
  })

  ## map ----
  year.output <- reactive(paste('Tahun:', sel.year()))
  output$map_year <- renderText(year.output())

  output$map <- renderGvis({
    df <- data_by_year()
    df <- df[df$kode_provinsi != 0, ]
    iso_code_prov <- estPUSek:::estPUSek.data.env$prov_code[,c('kode_bps','iso_code')]
    df <- dplyr::left_join(df, iso_code_prov, by=c('kode_provinsi'='kode_bps'))
    gvisGeoChart(df, locationvar='iso_code',
                 colorvar='values', chartid='map',
                 options=list(height=450, width=900,
                              region = 'ID', dataMode='regions',
                              resolution = 'provinces'
                 ))
  })

  ## tabel ----
  exclude.id <- reactive({input$exclude_id})
  output$table_year <- renderText(year.output())
  output$table <- DT::renderDT({
    df <- data_by_year()
    if(exclude.id()){
      df <- df[df$kode_provinsi != 0, ]
    }
    code_prov <- estPUSek:::estPUSek.data.env$prov_code[,c('kode_bps','iso_code','prov_bps')]
    df <- dplyr::left_join(df, code_prov, by=c('kode_provinsi'='kode_bps')) %>%
      dplyr::select(kode_provinsi,iso_code,prov_bps,values)
    data.for.table(df)
    datatable(df) %>%
      formatRound('values', digits = 3)
  })

  output$download_table <- downloadHandler(
    filename <- function() {paste0(ind.fun(sel.indicator()),'_',sel.year(),'.csv') },
    content <- function(file) {
      tbl <- data.for.table()
      write.csv(tbl, file, row.names = FALSE)
    }
  )

  ## trends & struktur ----

  ### trends ----

  output$trends_plot <- renderPlot({
    df <- trends_data()
    plt <- ggplot(df, aes(tahun, values)) +
      geom_line() +
      labs(x = 'Tahun', y = 'Nilai')
    if(sel.ind.has.neg.val()){
      plt <- plt +
        geom_hline(yintercept = 0, color = 'red', linetype='dashed')
    }

    plt
  })

  output$trends_table <- renderTable({
    df <- data.rbind(trends_data(), 'tahun', 'values')
    df
  })

  ### struktur ----
  output$structure_plot <- renderPlot({
    if(sel.ind.has.struct()){
      df <- struct_data()
      xlabel <- c(paste0(seq(0,75,5)),"80+")
      plt <- ggplot(df, aes(umur, values)) +
        geom_line() +
        labs(x = 'Umur', y = 'Nilai') +
        scale_x_continuous(breaks = seq(0, 80, 5),
                           labels = xlabel)
    }else{
      df <- data.frame(x=0, y=0, lab='Tidak berlaku untuk indikator ini')
      plt <- ggplot(df, aes(x=x, y=y, label=lab)) +
        geom_text() + scale_y_continuous(name='') +
        scale_x_continuous(name='')
    }
    plt
  })

  output$structure_table <- renderTable({
    if(sel.ind.has.struct()){
      df <- data.rbind(struct_data(), 'umur', 'values')
      l <- length(df)
      colnames(df)[l] <- '80+'
      df
    }
  })


  # Tab custom ----

  ## sidebar ----

  ## main ----
  ### selected input/parameter ----
  sel.input.mode <- reactive({as.integer(input$input_mode)}) #selected input mode
  sel.oag <- reactive({as.integer(input$oag)}) #selected oag
  sel.method <- reactive({
    idx <- as.integer(input$interp_method)
    names(estPUSek:::estPUSek.data.env$list.interp.method[idx])
  })

  ### data ----
  data.age5 <- reactiveVal(data.frame(Jumlah = numeric()))
  data.age1 <- reactiveVal(data.frame(Umur = seq(0,80), Jumlah = 0))
  data.sap <- reactiveVal(data.frame(Umur = character(), Jumlah = numeric(),
                                     Persen = numeric()))

  ### init data ----
  observeEvent(input$init_data, {
    if(sel.input.mode() == 1){
      df <-  estPUSek:::init.age5(sel.oag())
    }else{ #for input file mode
      data.file <- input$file_input #choosen file
      data.ext <- tools::file_ext(data.file$name) #extension
      df <- switch(data.ext,
                   csv = read.csv(data.file$datapath, sep=';'),
                   xlsx = readxl::read_xlsx(data.file$datapath, sheet=1),
                   xls = readxl::read_xls(data.file$datapath, sheet=1),
                   validate('Jenis file tidak didukung, mendukung file .csv, .xlsx, .xls')
                   )
      df <-  estPUSek:::init.age5(sel.oag(), df$Jumlah)
    }
    data.age5(df) #update data.age5

    #update data.age1
    pop1 <- data.frame(Umur = seq(0,sel.oag()), Jumlah = 0)
    data.age1(pop1)

    #update data.sap
    sap <- data.frame(Umur=c('7-12','13-15','16-18','19-23'),
                      Jumlah = 0, Persen = 0)
    data.sap(sap)
  })


  ### estimate ----
  observeEvent(input$estimate, {
    # read input data
    df.age5 <- data.age5()

    # estimate using sprague
    pop1 <-  estPUSek::age5_to_age1(sel.oag(), as.numeric(df.age5$Jumlah))
    df.age1 <- data.frame(Umur = seq(0, sel.oag()), Jumlah = pop1)
    data.age1(df.age1)
    df.sap <-  estPUSek:::agg.sap(df.age1)
    data.sap(df.sap)
    # glimpse(df.age5)
  })

  ### age5 input ----
  output$age5table <- DT::renderDT({
    df <- data.age5()
    datatable(
      df,
      rownames = TRUE,
      selection = 'none',
      editable = TRUE,
      options = list(autoWidth = FALSE,
                     dom ='ft',
                     scrollX = FALSE, scrollY=450,
                     pageLength = 20,
                     info = FALSE,
                     lengthChange = FALSE,
                     searching = FALSE,
                     ordering = FALSE)
    ) %>%
      formatStyle(0, target = 'row', fontWeight = 'bold') %>%
      formatStyle(0, width = '50px') %>%
      formatStyle(1, width = '175px') %>%
      formatStyle(c(0,1),
                  `text-align` = 'right',
                  border = '1px solid #ddd')
  }, server = FALSE)

  #### update age5 ----
  observeEvent(input$age5table_cell_edit, {
    info <- input$age5table_cell_edit
    str(info)
    new_data <- data.age5()
    new_data[info$row, info$col] <- info$value
    data.age5(new_data)
  })

  ### sap results ----
  # absolute
  output$sap_table <- DT::renderDT({
    df <- data.sap() %>% dplyr::select(-Persen)
    df <- tibble::column_to_rownames(df,'Umur')
    datatable(
      df,
      rownames = TRUE,
      selection = 'none',
      editable = FALSE,
      options = list(autoWidth = FALSE,
                     dom ='ft',
                     pageLength = 20,
                     info = FALSE,
                     lengthChange = FALSE,
                     searching = FALSE,
                     ordering = FALSE)
    ) %>%
      formatStyle(0, target = 'row', fontWeight = 'bold') %>%
      formatStyle(0, width = '50px') %>%
      formatStyle(1, width = '150px',
                  background = styleColorBar(range(df$Jumlah, na.rm = TRUE), 'lightblue'),
                  backgroundColor = styleInterval(0, c('white', 'lightblue'))) %>%
      formatRound(1, digits = 3) %>%
      formatStyle(c(0,1),
                  `text-align` = 'right',
                  border = '1px solid #ddd')

  })

  # percent
  output$sap_table2 <- DT::renderDT({
    df <- data.sap() %>% dplyr::select(-Jumlah)
    df <- tibble::column_to_rownames(df,'Umur')
    datatable(
      df,
      rownames = TRUE,
      selection = 'none',
      editable = FALSE,
      options = list(autoWidth = FALSE,
                     dom ='ft',
                     pageLength = 20,
                     info = FALSE,
                     lengthChange = FALSE,
                     searching = FALSE,
                     ordering = FALSE)
    ) %>%
      formatStyle(0, target = 'row', fontWeight = 'bold') %>%
      formatStyle(0, width = '50px') %>%
      formatStyle(1, width = '150px',
                  background = styleColorBar(range(df$Persen, na.rm = TRUE), 'lightblue'),
                  backgroundColor = styleInterval(0, c('white', 'lightblue'))) %>%
      formatRound(1, digits = 3) %>%
      formatStyle(c(0,1),
                  `text-align` = 'right',
                  border = '1px solid #ddd')

  })

  ### download results ----
  output$download_sap <- downloadHandler(
    filename <- function() { paste0('umur_sekolah', '_', Sys.time(), '.csv') },
    content <- function(file) {
      tbl <- data.sap()
      write.csv(tbl, file, row.names = FALSE)
    }
  )

  output$download_age1 <- downloadHandler(
    filename <- function() { paste0('umur_1_tahunan', '_', Sys.time(), '.csv') },
    content <- function(file) {
      tbl <- data.age1()
      write.csv(tbl, file, row.names = FALSE)
    }
  )

  ### age1 results ----
  output$age1_plot <- renderPlot({
    df <- data.age1()
    xlabel <- c(paste0(seq(0,sel.oag()-5,5)),paste0(sel.oag(),'+'))
    plt <- ggplot(df, aes(Umur, Jumlah)) +
      geom_line() +
      labs(x = 'Umur', y = 'Jumlah') +
      scale_x_continuous(breaks = seq(0, sel.oag(), 5),
                         labels = xlabel)
    plt
  })

  output$age1_table <- renderTable({
    df <- data.rbind(data.age1(), 'Umur', 'Jumlah')
    l <- length(df)
    colnames(df)[l] <- paste0(sel.oag(),'+')
    df
  })



}
