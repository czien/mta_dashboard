

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
                selected = lines
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
                tabPanel("On-Time Performance", plotlyOutput("on_time_performance")),
                tabPanel("Additional Platform Time", plotlyOutput("plat_time")),
                tabPanel("Additional Train Time", plotlyOutput("train_time")),
                tabPanel("Incidents", plotlyOutput("incidents")),
                tabPanel("Service Delivery", plotlyOutput("serv_del")),
                tabPanel("Elevators/Escalators", plotlyOutput("el_es"))
            )
            
    )
)))
