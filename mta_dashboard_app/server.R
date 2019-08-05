


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
                                Date >= input$date_range[1] &
                                Date <= input$date_range[2]) %>%
      group_by(Date, period) %>%
      summarise(`additional platform time` = mean(`additional platform time`)) %>%
      mutate(period = period)
    g = ggplot(df,
               aes(Date,
                   `additional platform time`,
                   color = period)) +
      theme +
      scale_color_brewer(palette = theme_palette) +
      geom_point() +
      geom_line() +
      scale_x_datetime(date_breaks = "months", labels = date_format("%b %Y")) +
      labs(x = "Date", y = "Extra Platform Time (minutes)")
    
    ggplotly(g) %>%
      layout(legend = list(
        orientation = "h",
        y = -.5,
        x = 0.4
      ))
  })
  
  output$train_time = renderPlotly({
    df = train_time %>% filter(line %in% input$line &
                                 Date >= input$date_range[1] &
                                 Date <= input$date_range[2]) %>%
      group_by(Date, period) %>%
      summarise(`additional train time` = mean(`additional train time`)) %>%
      mutate(period = period)
    g = ggplot(df,
               aes(Date,
                   `additional train time`,
                   color = period)) +
      theme +
      scale_color_brewer(palette = theme_palette) +
      geom_point() +
      geom_line() +
      scale_x_datetime(date_breaks = "months", labels = date_format("%b %Y")) +
      labs(x = "Date", y = "Average Extra Train Time (Minutes)")
    
    ggplotly(g) %>%
      layout(legend = list(
        orientation = "h",
        y = -.5,
        x = 0.4
      ))
  })
  
  output$on_time_performance = renderPlotly({
    df = on_time_performance %>% filter(line %in% input$line &
                                          Date >= input$date_range[1] &
                                          Date <= input$date_range[2]) %>%
      group_by(Date, period) %>%
      summarise(on_time_performance = mean(on_time_performance)) %>%
      mutate(period = period)
    g = ggplot(df,
               aes(Date,
                   on_time_performance,
                   color = period)) +
      theme +
      scale_color_brewer(palette = theme_palette) +
      geom_point() +
      geom_line() +
      scale_x_datetime(date_breaks = "months", labels = date_format("%b %Y")) +
      labs(x = "Date", y = "On-Time Performance Ratio")
    
    ggplotly(g) %>%
      layout(legend = list(
        orientation = "h",
        y = -.5,
        x = 0.4
      ))
  })
  
  output$el_es = renderPlotly({
    df = el_es_avail %>% gather("el_or_es", "value", 2:3) %>%  filter(Date >= input$date_range[1] &
                                                                        Date <= input$date_range[2]) %>%
      group_by(Date, el_or_es) %>%
      summarise(value = mean(value))
    g = ggplot(df, aes(Date, value, color = el_or_es)) +
      theme +
      scale_color_brewer(palette = theme_palette) +
      geom_point() +
      geom_line() +
      scale_x_datetime(date_breaks = "months", labels = date_format("%b %Y")) +
      labs(x = "Date", y = "% Functional")
    
    ggplotly(g) %>%
      layout(legend = list(
        orientation = "h",
        y = -.5,
        x = 0.3
      ))
  })
  
  output$incidents = renderPlotly({
    df = incidents %>% filter(line %in% input$line &
                                Date >= input$date_range[1] &
                                Date <= input$date_range[2]) %>%
      mutate(category = as.factor(category)) %>%
      group_by(Date, category) %>%
      summarise(count = sum(count))
    g = (
      ggplot(df,
             aes(Date,
                 count,
                 fill = category)) +
        theme +
        scale_fill_brewer(palette = theme_palette) +
        geom_area(position = "stack", stat = "identity") +
        scale_x_datetime(date_breaks = "months", labels = date_format("%b %Y"))
    ) +
      labs(x = "Date", y = "Count")
    
    ggplotly(g) %>%
      layout(legend = list(
        orientation = "h",
        y = -.5,
        x = 1
      ))
  })
  
  
  output$serv_del = renderPlotly({
    df = serv_del[, -6] %>%
      mutate(
        Delta = num_sched_trains - num_actual_trains,
        `Trains Run` = num_actual_trains,
        Line = line
      ) %>%
      filter(Line %in% input$line & Date >= input$date_range[1] &
               Date <= input$date_range[2]) %>%
      gather("Metric", "Value", 7, 8) %>%
      group_by(Date, Metric) %>%
      summarise(Value = sum(Value))
    
    
    trains_vec = df$Value[df$Metric == "Trains Run"]
    difs_vec = df$Value[df$Metric == "Delta"]
    g = ggplot(df,
               aes(Date,
                   Value,
                   fill = Metric)) +
      theme +
      scale_fill_brewer(palette = theme_palette) +
      scale_x_datetime(date_breaks = "months", labels = date_format("%b %Y")) +
      geom_area() +
      coord_cartesian(ylim = c(min(trains_vec) * .85, max(trains_vec + difs_vec) *
                                 1.1)) +
      labs(x = "Date", y = "Trains Run vs. Scheduled")
    ggplotly(g) %>%
      layout(legend = list(
        orientation = "h",
        y = -.5,
        x = 0.3
      ))
  })
  
})
