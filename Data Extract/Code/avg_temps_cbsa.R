library(tidyverse)
library(readr)
library(readxl)

load('Data Extract/Data/avg_temps_2011.rda')
msa_table = read_excel('C:\\Users\\Arjun\\Downloads\\Projects\\devel\\datathon\\List12.xlsx')

msa_table = (msa_table 
             %>% mutate(fips = paste0(`FIPS State Code`, `FIPS County Code`))
             %>% select("CBSA Code", "fips")
             %>% rename("CBSA" = "CBSA Code")
             %>% mutate(CBSA = as.numeric(CBSA)))

avg_temps = (avg_temps
             %>% mutate(fips = str_pad(`County.Code`, 5, pad="0"))
             %>% select(fips, Avg.Min.Temp, Avg.Max.Temp))

avg_temps_msa = (left_join(avg_temps, msa_table, by="fips")
                 %>% drop_na(CBSA)
                 %>% group_by(CBSA)
                 %>% summarize(mean(Avg.Min.Temp), mean(Avg.Max.Temp)))

save(avg_temps_msa, file='Data Extract/Data/avg_temps_2011.rda')
