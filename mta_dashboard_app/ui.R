
shinyUI(fluidPage(
    titlePanel("MTA Performance Data"),
    
        sidebarLayout(
        sidebarPanel(
            pickerInput(
                "line", "Line:",
                choices = lines,
                options = list(`actions-box` = TRUE),
                multiple = T,
                selected = "A"
            ),
            dateRangeInput(
                "date_range",
                "Date Range:",
                start = "2018-06-01",
                end = "2019-06-01",
                min = "2015-01-01",
                format = "mm/yy"
            ),
            width = 2
            
        ),
        
        mainPanel(fluidRow(
            column(
                6,
                plotOutput("plat_time"),
                plotOutput("train_time"),
                plotOutput("incidents")
            ),
            
            column(
                6,
               plotOutput("trip_time"),
               plotOutput("el_es"),
               plotOutput("serv_del"))
        ))
    )
))
