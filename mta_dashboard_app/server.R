






shinyServer(function(input, output, session) {
  observe({
    updatePickerInput(session, "line",
                      choices = lines,
                      selected = lines)
  })
  
  
  theme = theme(axis.text.x = element_text(angle = 90, hjust = 1),
                legend.position = "bottom")
  theme_palette = "Set1"
  
  output$plat_time = renderPlotly({
    df = plat_time %>% filter(line %in% input$line &
                                date >= input$date_range[1] &
                                date <= input$date_range[2]) %>%
      group_by(date, period) %>%
      summarise(`additional platform time` = mean(`additional platform time`)) %>%
      mutate(period = period)
    g = ggplot(df,
           aes(date,
               `additional platform time`,
               color = period)) +
      theme +
      scale_color_brewer(palette = theme_palette) +
      geom_point() +
      geom_line() +
      scale_x_datetime(date_breaks = "months", labels = date_format("%b %Y")) +
      labs(x = "Date", y = "Extra Platform Time (minutes)")
    
    ggplotly(g) %>% 
      layout(legend = list(orientation = "h",
                           y = -.5, x = 1)) 
  })
  
  output$train_time = renderPlotly({
    df = train_time %>% filter(line %in% input$line &
                                 date >= input$date_range[1] &
                                 date <= input$date_range[2]) %>%
      group_by(date, period) %>%
      summarise(`additional train time` = mean(`additional train time`)) %>%
      mutate(period = period)
    g = ggplot(df,
           aes(date,
               `additional train time`,
               group = period,
               color = period)) +
      theme +
      scale_color_brewer(palette = theme_palette) +
      geom_point() +
      geom_line() +
      scale_x_datetime(date_breaks = "months", labels = date_format("%b %Y"))
    
    ggplotly(g) %>% 
      layout(legend = list(orientation = "h",
                           y = -.5, x = 1)) 
  })

  output$on_time_performance = renderPlotly({
    df = on_time_performance %>% filter(line %in% input$line &
                                          date >= input$date_range[1] &
                                          date <= input$date_range[2]) %>%
      group_by(date, period) %>%
      summarise(on_time_performance = mean(on_time_performance)) %>%
      mutate(period = period)
    g = ggplot(df,
           aes(
             date,
             on_time_performance,
             group = period,
             color = period
           )) +
      theme +
      scale_color_brewer(palette = theme_palette) +
      geom_point() +
      geom_line() +
      scale_x_datetime(date_breaks = "months", labels = date_format("%b %Y"))
    
    ggplotly(g) %>% 
      layout(legend = list(orientation = "h",
                           y = -.5, x = 1)) 
  })
  
  output$el_es = renderPlotly({
    df = el_es_avail %>% gather("el_or_es", "value", 2:3) %>%  filter(date >= input$date_range[1] &
                                                                        date <= input$date_range[2]) %>%
      group_by(date, el_or_es) %>%
      summarise(value = mean(value))
    g = ggplot(df, aes(date, value, group = el_or_es, color = el_or_es)) +
      theme +
      scale_color_brewer(palette = theme_palette) +
      geom_point() +
      geom_line() +
      scale_x_datetime(date_breaks = "months", labels = date_format("%b %Y"))
    
    ggplotly(g) %>% 
      layout(legend = list(orientation = "h",
                           y = -.5, x = 1)) 
  })
  
  output$incidents = renderPlotly({
    df = incidents %>% filter(line %in% input$line &
                                date >= input$date_range[1] &
                                date <= input$date_range[2]) %>%
      group_by(date, category) %>%
      summarise(count = sum(count))
    g = (ggplot(df,
           aes(
             date,
             count,
             group = as.factor(category),
             fill = as.factor(category)
           )) +
      theme +
      scale_fill_brewer(palette = theme_palette) +
      geom_area(position = "stack", stat = "identity") +
      scale_x_datetime(date_breaks = "months", labels = date_format("%b %Y")))
    
    ggplotly(g) %>% 
      layout(legend = list(orientation = "h",
                          y = -.5, x = 1)) 
  })
  
  
  output$serv_del = renderPlotly({
    df = serv_del[, -6] %>%
      mutate(dif = num_sched_trains - num_actual_trains) %>%
      gather("metric", "value", 5, 7) %>%
      group_by(date, metric) %>%
      summarise(value = sum(value)) %>%
      filter(date >= input$date_range[1] &
               date <= input$date_range[2])
    trains_vec = df$value[df$metric == "num_actual_trains"]
    difs_vec = df$value[df$metric == "dif"]
    g = ggplot(df,
           aes(
             date,
             value,
             group = as.factor(metric),
             fill = as.factor(metric)
           )) +
      theme +
      scale_fill_brewer(palette = theme_palette) +
      scale_x_datetime(date_breaks = "months", labels = date_format("%b %Y")) +
      geom_area() +
      coord_cartesian(ylim = c(min(trains_vec) * .85, max(trains_vec + difs_vec) *
                                 1.1))
    ggplotly(g) %>% 
      layout(legend = list(orientation = "h",
                           y = -.5, x = 1)) 
  })
  
})
