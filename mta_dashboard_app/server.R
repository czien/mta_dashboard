#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(scales)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    observe({
        line
        updateSelectInput(session, "line",
                          choices = lines)
    })
    
    
    output$plat_time = renderPlot({
        df = plat_time %>% filter(line == input$line & date >= input$date_range[1] & date <= input$date_range[2])
        ggplot(df, aes(date, addl_plat_time, group = period, color = period)) +
            theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
            geom_point() +
            geom_line() +
            scale_x_datetime(date_breaks = "months", labels = date_format("%b %Y"))
    })
    
    output$train_time = renderPlot({
        df = train_time %>% filter(line == input$line & date >= input$date_range[1] & date <= input$date_range[2])
        ggplot(df, aes(date, addl_train_time, group = period, color = period)) +
            theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
            geom_point() +
            geom_line() +
            scale_x_datetime(date_breaks = "months", labels = date_format("%b %Y"))
    })
    
    output$trip_time = renderPlot({
        df = trip_time %>% filter(line == input$line & date >= input$date_range[1] & date <= input$date_range[2])
        ggplot(df, aes(date, addl_trip_time, group = period, color = period)) +
            theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
            geom_point() +
            geom_line() +
            scale_x_datetime(date_breaks = "months", labels = date_format("%b %Y"))
    })
    
    output$el_es = renderPlot({
        df = el_es_avail %>% gather("el_or_es", "value", 2:3) %>%  filter(date >= input$date_range[1] & date <= input$date_range[2])
        ggplot(df, aes(date, value, group = el_or_es, color = el_or_es)) +
            theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
            geom_point() +
            geom_line() +
            scale_x_datetime(date_breaks = "months", labels = date_format("%b %Y"))
            
    })
        
    
    
}
)