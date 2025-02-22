#Albane Keraudren-Riguidel

library(dplyr)
library(readr)
library(base)
library(purrr)
library(xfun)
library(data.table)

#import file
setwd("C:/~/COVID-19-master/csse_covid_19_data/csse_covid_19_time_series")
time_series_covid19_confirmed_global <- read_csv("time_series_covid19_confirmed_global.csv")
View(time_series_covid19_confirmed_global)

#create data-frame with only data about Belgium, Germany, Metropolitan France, and Luxembourg
covid19_BEDEFRLUIT <- time_series_covid19_confirmed_global %>% 
  filter(`Country/Region`=="Belgium" | `Country/Region`=="Germany" | (`Country/Region`=="France" & is.na(`Province/State`)) | `Country/Region`=="Luxembourg"  | `Country/Region`=="Italy") %>% 
  select(-`Province/State`)
View(covid19_BEDEFRLUIT)

#transform data-frame to data-table, and transposes it to switch columns with rows
covid19 <- transpose(as.data.table(covid19_BEDEFRLUIT))
View(covid19)
#put countries as name of columns and clear 3 first rows
setnames(covid19, unlist(covid19[1,]))
covid19 <- covid19[-1,]
covid19 <- covid19[-1,]
covid19 <- covid19[-1,]

#create column of dates that disappeared during the transposition process
start_date <- as.Date("22/01/2020", format = "%d/%m/%Y")
end_date <- as.Date("09/03/2023", format = "%d/%m/%Y")
covid19 <- covid19 %>% mutate(Date = seq(start_date, end_date, by = "1 day"))

#rearrange columns
covid19 <- covid19 %>% select(Date, everything())
View(covid19)

write.csv(covid19, "covid19_final_with_italy.csv")

View(covid19)

