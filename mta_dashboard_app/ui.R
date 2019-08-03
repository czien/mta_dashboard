#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dygraphs)


# Define UI for application that draws a histogram
shinyUI(fluidPage(
    # Application title
    titlePanel("MTA Performance Data"),
    
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            selectInput(
                inputId = "line",
                label = "Line",
                choices = lines,
                verbatimTextOutput('line')
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
        
        # Show a plot of the generated distribution
        mainPanel(fluidRow(
            column(
                6,
                plotOutput("plat_time"),
                plotOutput("train_time"),
                plotOutput("incidents")
            ),
            
            column(6,
                   plotOutput("trip_time"),
                   plotOutput("el_es"),
                   plotOutput("serv_del"))
        ))
    )
))
