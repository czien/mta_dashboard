library(tidyverse)
library(lubridate)
library(zoo)

setwd("data/")

plat_time = read_csv("Additional Platform Time.csv")
plat_time = plat_time %>% dplyr::rename(addl_plat_time = `additional platform time`)
plat_time = plat_time %>% mutate(date = (parse_date_time(month, "%Y-%m")))

train_time = read_csv("Additional Train Time.csv")
train_time = train_time %>% dplyr::rename(addl_train_time = `additional train time`)
train_time = train_time %>% mutate(date = (parse_date_time(month, "%Y-%m")))

trip_time = read_csv("Customer Journey Time Performance.csv")
trip_time = trip_time %>% dplyr::rename(addl_trip_time = `customer journey time performance`)
trip_time = trip_time %>% mutate(date = (parse_date_time(month, "%Y-%m")))

incidents = read_csv("Major Incidents.csv")

dist_btwn_fail = read_csv("Mean Distance Between Failures.csv")

serv_del = read_csv("Service Delivered.csv")

station_pes = read_csv("Station PES.csv")

el_es_avail = read_csv("Elevator and Escalator Availabiltiy.csv")

lines = sort(unique(serv_del$line))

