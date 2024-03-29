library(tidyverse)
library(lubridate)
library(zoo)
library(reshape2)
library(shiny)
library(dygraphs)
library(scales)
library(plotly)
library(shinyWidgets)


fix_date = function(df) {
  return (df %>% mutate(Date = (parse_date_time(month, "%Y-%m"))))
}

setwd("data/")

plat_time = fix_date(read_csv("Additional Platform Time.csv"))


train_time = fix_date(read_csv("Additional Train Time.csv"))

on_time_performance = fix_date(read_csv("Customer Journey Time Performance.csv")) %>% dplyr::rename(on_time_performance = `customer journey time performance`)

el_es_avail = fix_date(read_csv("Elevator and Escalator Availabiltiy.csv"))

incidents = fix_date(read_csv("Major Incidents.csv"))
incident_categories = unique(incidents$category)
tmp = spread(incidents, category, count)
tmp[is.na(tmp)] = 0
incidents = melt(tmp, id.vars = colnames(tmp[1:4]), measure.vars = colnames(tmp[5:10])) %>%
  rename(category = variable, count = value)

serv_del = fix_date(read_csv("Service Delivered.csv"))

station_pes = fix_date(read_csv("Station PES.csv"))

dist_btwn_fail = fix_date(read_csv("Mean Distance Between Failures.csv"))

lines = sort(unique(serv_del$line))
