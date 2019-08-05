

shinyUI(fluidPage(
    titlePanel("MTA Performance Data"),
    sidebarLayout(
        sidebarPanel(
            pickerInput(
                "line",
                "Line:",
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
        
        mainPanel(
            tabsetPanel(
                tabPanel("On-Time Performance", plotOutput("on_time_performance")),
                tabPanel("Additional Platform Time", plotOutput("plat_time")),
                tabPanel("Additional Train Time", plotOutput("train_time")),
                tabPanel("Incidents", plotOutput("incidents")),
                tabPanel("Service Delivery", plotOutput("serv_del")),
                tabPanel("Elevators/Escalators", plotOutput("el_es"))
            )
            
    )
)))
