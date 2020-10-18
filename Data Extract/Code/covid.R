library(tidyverse)
library(readr)
library(readxl)

covid = read_csv('C:\\Users\\Arjun\\Downloads\\Projects\\devel\\datathon\\us_covid_counties.csv')
msa_table = read_excel('C:\\Users\\Arjun\\Downloads\\Projects\\devel\\datathon\\county_to_cbsa.xlsx')

covid = covid %>% filter(date > today()-14)
msa_table = (msa_table 
             %>% mutate(fips = paste0(`FIPS State Code`, `FIPS County Code`))
             %>% select("CBSA Code", "CBSA Title", "fips"))

covid_msa_ts = (left_join(covid, msa_table, by="fips")
             %>% drop_na(`CBSA Code`)
             %>% mutate(CBSA = as.numeric(`CBSA Code`))
             %>% select(-`CBSA Code`)
             %>% group_by(date, CBSA))

covid_msa = (left_join(covid, msa_table, by="fips")
             %>% drop_na(`CBSA Code`)
             %>% mutate(CBSA = as.numeric(`CBSA Code`))
             %>% select(-`CBSA Code`)
             %>% group_by(CBSA))

covid_timeseries_msa = covid_msa_ts %>% summarize(mean(cases), mean(deaths))
covid_14dayavg_msa = covid_msa %>% summarize(mean(cases), mean(deaths))

save(covid_14dayavg_msa, file='Data Extract/Data/covid_14dayavg.rda')
