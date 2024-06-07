library(shinythemes)
library(shinydashboard)
library(shinyjs)

addResourcePath('images', system.file('images', package = 'estPUSek'))

fluidPage(
  theme = shinytheme("yeti"),
  titlePanel(
    title = HTML(
      "<h3>estPUSek:</h3><h5>Estimasi jumlah penduduk umur sekolah & satu tahunan</h5>"
    )
  ),

  tabsetPanel(
    # Tab hasil proyeksi ----
    tabPanel(
      "Hasil Proyeksi",
      br(),

      ## sidebar ----
      sidebarLayout(
        fluid = FALSE,
        sidebarPanel(
          width = 4,
          selectInput('indicator', h5('Indikator:'),
                      estPUSek:::estPUSek.data.env$indicators),
          fluidRow(column(4, offset = 1, uiOutput('age_sel'))),
          htmlOutput('indicator_desc'),
          hr(),
          sliderInput(
            "year",
            h5('Tahun:'),
            min = 2020,
            max = 2050,
            step = 1,
            value = 2020
          ),
          hr(),
          HTML("<p><small><b>Sumber Data:</b> <a href='https://www.bps.go.id/id/publication/2023/05/16/fad83131cd3bb9be3bb2a657/proyeksi-penduduk-indonesia-2020-2050-hasil-sensus-penduduk-2020.html'>Kementerian PPN/Bappenas, Badan Pusat Statistik, BKKBN, Kementerian Kesehatan, & UNFPA. (2023). Proyeksi Penduduk Indonesia 2020-2050: Hasil Sensus Penduduk 2020. BPS.</a> </small></p>"),
          HTML("<p><small><b>Metodologi & Aplikasi:</b> <a href='https://orcid.org/0000-0002-4862-5523'>Ari Purwanto Sarwo Prasojo</a>, Kelompok Riset Population Data Science, Pusat Riset Kependudukan, Badan Riset dan Inovasi Nasional.</small></p>")
        ),

        ## main panel ----
        mainPanel(width = 8,
                  fluidRow(
                    tabsetPanel(
                      id = "tab_proj",

                      ### Heat map ----
                      tabPanel(
                        'Heat map',
                        value = 1,
                        br(),
                        fluidRow(column(6, offset = 5, h5(
                          'Heat map: Provinsi x Tahun'
                        ))),
                        column(12, offset = .5, plotOutput('heatmap')),


                        hr(),
                      ),

                      ### Map ----
                      tabPanel(
                        'Map',
                        value = 2,
                        fluidRow(column(6, offset = 5, textOutput('map_year'))),
                        hr(),
                        htmlOutput('map'),
                        hr(),
                      ),

                      ### Tabel ----
                      tabPanel(
                        'Tabel',
                        value = 3,
                        fluidRow(
                          column(6, checkboxInput('exclude_id', 'Tanpa Indonesia'))
                        ),
                        fluidRow(
                          column(3, offset=5, textOutput('table_year')),
                          column(1, offset=1, downloadLink("download_table", "Download"))
                        ),
                        hr(),
                        DT::dataTableOutput('table')
                      ),

                      ### Trends & Struktur ----
                      tabPanel(
                        'Trends & Struktur',
                        value = 4,
                        tags$head(tags$style(type = "text/css", "#sel_prov { height: 450px}")),
                        br(),
                        fluidRow(column(3, uiOutput('prov_selection')),
                                 column(
                                   9,
                                   tabsetPanel(
                                     #### Trends ----
                                     tabPanel(
                                       'Trends',
                                       tags$head(
                                         tags$style(type =
                                                      "text/css", "#trends_table { overflow-x: scroll}")
                                       ),
                                       plotOutput('trends_plot'),
                                       # br(),
                                       tableOutput('trends_table')
                                     ),

                                     #### Struktur ----
                                     tabPanel(
                                       'Struktur',
                                       tags$head(
                                         tags$style(type =
                                                      "text/css", "#structure_table { overflow-x: scroll}")
                                       ),
                                       plotOutput('structure_plot'),
                                       # br(),
                                       tableOutput('structure_table')
                                     ),
                                     type = "pills"
                                   )
                                 ))
                      )
                    )
                  ))

      )
    ),

    # Tab panel custom ----
    tabPanel(
      "Custom",
      br(),

      ## sidebar ----
      sidebarLayout(
        fluid = FALSE,
        sidebarPanel(
          width = 3,
          selectInput("input_mode", h5("Mode input data:"),
                      estPUSek:::estPUSek.data.env$list.input.mode, selected = 1),
          conditionalPanel(condition = 'input.input_mode == 2',
                           fileInput('file_input',h5('Pilih file:'),
                                     accept = c('.csv','.xlsx','.xls'))),
          selectInput('oag',h5('Kelompok umur terbuka:'),
                      estPUSek:::estPUSek.data.env$list.oag, selected = 80),

          # hr(),
          # radioButtons("interp_method",h5("Metode:"),inline=TRUE,
          #              estPUSek:::estPUSek.data.env$list.interp.method, selected = 1),
          fluidRow(
            column(3, actionButton('init_data','Init data',
                                   icon=icon('refresh'))),
            column(3, offset=1, actionButton('estimate','Estimasi',
                                             icon=icon('play')))
          ),
          hr(),
          HTML("<p><small><b>Metodologi & Aplikasi:</b> <a href='https://orcid.org/0000-0002-4862-5523'>Ari Purwanto Sarwo Prasojo</a>, Kelompok Riset Population Data Science, Pusat Riset Kependudukan, Badan Riset dan Inovasi Nasional.</small></p>")
        ),

        ## main panel ----
        mainPanel(
          # tags$head(
          #   tags$style(type =
          #                "text/css", "age1_table { overflow-x: scroll}")
          # ),
          fluidPage(
            fluidRow(
              column(3,
                     h5('Input umur 5 tahunan:'),
                     DT::dataTableOutput('age5table')),
              column(3,
                     fluidRow(
                       h5('Umur sekolah:'),
                       DT::dataTableOutput('sap_table'),
                       DT::dataTableOutput('sap_table2'),
                       hr(),
                       downloadLink('download_sap', 'Ekspor umur sekolah'),
                       br(),
                       downloadLink('download_age1', 'Ekspor umur 1 tahunan')
                       )
                     ),

              column(6,
                     h5('Umur 1 tahunan:'),
                     fluidRow(
                       plotOutput('age1_plot',width='525px'),
                       box(style='overflow-x: scroll;width:525px',
                         tableOutput('age1_table')
                       )

                     )
                     )

            ),
            hr(),
          )
        )
      )
      ),

    # Tab panel Bantuan ----
    tabPanel("Bantuan",
             includeHTML("help.html")
             # img(src = 'images/csv_example.png', alt = 'Contoh format file input .csv')
             )
  )
)
