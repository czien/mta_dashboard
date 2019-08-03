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
    
    theme = theme(axis.text.x = element_text(angle = 90, hjust = 1),
                  legend.position = "bottom")
    
    output$plat_time = renderPlot({
        df = plat_time %>% filter(line == input$line &
                                      date >= input$date_range[1] & date <= input$date_range[2])
        ggplot(df,
               aes(
                   date,
                   addl_plat_time,
                   group = period,
                   color = period
               )) +
            theme +
            geom_point() +
            geom_line() +
            scale_x_datetime(date_breaks = "months", labels = date_format("%b %Y"))
    })
    
    output$train_time = renderPlot({
        df = train_time %>% filter(line == input$line &
                                       date >= input$date_range[1] & date <= input$date_range[2])
        ggplot(df,
               aes(
                   date,
                   addl_train_time,
                   group = period,
                   color = period
               )) +
            theme +
            geom_point() +
            geom_line() +
            scale_x_datetime(date_breaks = "months", labels = date_format("%b %Y"))
    })
    
    output$trip_time = renderPlot({
        df = trip_time %>% filter(line == input$line &
                                      date >= input$date_range[1] & date <= input$date_range[2])
        ggplot(df,
               aes(
                   date,
                   addl_trip_time,
                   group = period,
                   color = period
               )) +
            theme +
            geom_point() +
            geom_line() +
            scale_x_datetime(date_breaks = "months", labels = date_format("%b %Y"))
    })
    
    output$el_es = renderPlot({
        df = el_es_avail %>% gather("el_or_es", "value", 2:3) %>%  filter(date >= input$date_range[1] &
                                                                              date <= input$date_range[2])
        ggplot(df, aes(date, value, group = el_or_es, color = el_or_es)) +
            theme +
            geom_point() +
            geom_line() +
            scale_x_datetime(date_breaks = "months", labels = date_format("%b %Y"))
        
    })
    
    output$incidents = renderPlot({
        df = incidents %>% filter(line == input$line &
                                      date >= input$date_range[1] & date <= input$date_range[2])
        ggplot(df, aes(date, count, group = as.factor(category), fill = as.factor(category))) +
            theme +
            geom_bar(position = "stack", stat = "identity") +
            scale_x_datetime(date_breaks = "months", labels = date_format("%b %Y"))
    })
    
    output$serv_del = renderPlot({
        df = melt(serv_del, id.vars = colnames(serv_del[c(7,3)]), measure.vars = colnames(serv_del[c(4:6)])) %>%
            rename(metric = variable) %>% filter(date >= input$date_range[1] & date <= input$date_range[2])
        
        sched_trains_df =  df %>%  filter(metric %in% c("num_sched_trains", "num_actual_trains"))
        serv_del_df = df %>% filter(metric == "service delivered")
        
        ggplot(df, aes(date, value, group = as.factor(metric), fill = as.factor(metric))) +
            theme +
            geom_bar(data=sched_trains_df, position = "identity", stat = "identity") +
            coord_cartesian(ylim = c(2500,3500)) +
            scale_x_datetime(date_breaks = "months", labels = date_format("%b %Y"))
    })
    
})