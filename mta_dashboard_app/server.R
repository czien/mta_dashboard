





shinyServer(function(input, output, session) {
    observe({
        updatePickerInput(session, "line",
                          choices = lines,
                          selected = lines)
    })
    
    
    theme = theme(axis.text.x = element_text(angle = 90, hjust = 1),
                  legend.position = "bottom")
    
    output$plat_time = renderPlot({
        df = plat_time %>% filter(line %in% input$line &
                                      date >= input$date_range[1] &
                                      date <= input$date_range[2]) %>%
            group_by(date, period) %>%
            summarise(addl_plat_time = mean(addl_plat_time)) %>%
            mutate(period = period)
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
        df = train_time %>% filter(line %in% input$line &
                                       date >= input$date_range[1] &
                                       date <= input$date_range[2]) %>%
            group_by(date, period) %>%
            summarise(addl_train_time = mean(addl_train_time)) %>%
            mutate(period = period)
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
    
    output$on_time_performance = renderPlot({
        df = on_time_performance %>% filter(line %in% input$line &
                                      date >= input$date_range[1] &
                                      date <= input$date_range[2]) %>%
            group_by(date, period) %>%
            summarise(on_time_performance = mean(on_time_performance)) %>%
            mutate(period = period)
        ggplot(df,
               aes(
                   date,
                   on_time_performance,
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
                                                                              date <= input$date_range[2]) %>%
            group_by(date, el_or_es) %>%
            summarise(value = mean(value))
        ggplot(df, aes(date, value, group = el_or_es, color = el_or_es)) +
            theme +
            geom_point() +
            geom_line() +
            scale_x_datetime(date_breaks = "months", labels = date_format("%b %Y"))
        
    })
    
    output$incidents = renderPlot({
        df = incidents %>% filter(line %in% input$line &
                                      date >= input$date_range[1] &
                                      date <= input$date_range[2]) %>%
            group_by(date, category) %>%
            summarise(count = sum(count))
        ggplot(df,
               aes(
                   date,
                   count,
                   group = as.factor(category),
                   fill = as.factor(category)
               )) +
            theme +
            geom_bar(position = "stack", stat = "identity") +
            scale_x_datetime(date_breaks = "months", labels = date_format("%b %Y"))
        
    })
    
    
    output$serv_del = renderPlot({
        df = serv_del[,-6] %>%
            mutate(dif = num_sched_trains - num_actual_trains) %>%
            gather("metric", "value", 5, 7) %>%
            group_by(date, metric) %>%
            summarise(value = sum(value)) %>%
            filter(date >= input$date_range[1] &
                       date <= input$date_range[2])
        trains_vec = df$value[df$metric == "num_actual_trains"]
        difs_vec = df$value[df$metric == "dif"]
        ggplot(df,
               aes(
                   date,
                   value,
                   group = as.factor(metric),
                   fill = as.factor(metric)
               )) +
            theme +
            scale_x_datetime(date_breaks = "months", labels = date_format("%b %Y")) +
            geom_area() +
            coord_cartesian(ylim = c(min(trains_vec)*.85, max(trains_vec + difs_vec)*1.1))
        
    })
    
})
