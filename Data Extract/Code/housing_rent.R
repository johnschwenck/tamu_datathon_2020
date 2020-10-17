require(dplyr)

# FUNCTION: get housing prices
get_housing <- function(data_folder_path){
  original_path <- getwd()
  setwd(data_folder_path)
  ZHVI_1 <- read.csv("ZHVI_1.csv")
  ZHVI_2 <- read.csv("ZHVI_2.csv")
  ZHVI_3 <- read.csv("ZHVI_3.csv")
  ZHVI_4 <- read.csv("ZHVI_4.csv")
  ZHVI_5 <- read.csv("ZHVI_5.csv")
  ZHVI_condo <- read.csv("ZHVI_condo.csv")
  
  # get average housing price for each county (only unique values, hence averaged over different zip code within county)
  ZHVI_1_rel <- ZHVI_1 %>% 
    mutate(county = str_replace(CountyName," County", "")) %>%
    select(c("county", last_col(12):last_col())) %>%
    mutate(one_bed_avg = round(rowMeans(select(.,starts_with("X")), na.rm = TRUE))) %>%
    select(c("county", "one_bed_avg")) %>% group_by(county) %>% summarize(one_bed_avg = round(mean(one_bed_avg)))
  
  ZHVI_2_rel <- ZHVI_2 %>% 
    mutate(county = str_replace(CountyName," County", "")) %>%
    select(c("county", last_col(12):last_col())) %>%
    mutate(two_bed_avg = rowMeans(select(.,starts_with("X")), na.rm = TRUE)) %>%
    select(c("county", "two_bed_avg")) %>% group_by(county) %>% summarize(two_bed_avg = round(mean(two_bed_avg)))
  
  ZHVI_3_rel <- ZHVI_3 %>% 
    mutate(county = str_replace(CountyName," County", "")) %>%
    select(c("county", last_col(12):last_col())) %>%
    mutate(three_bed_avg = rowMeans(select(.,starts_with("X")), na.rm = TRUE)) %>%
    select(c("county", "three_bed_avg")) %>% group_by(county) %>% summarize(three_bed_avg = round(mean(three_bed_avg)))
  
  ZHVI_4_rel <- ZHVI_4 %>% 
    mutate(county = str_replace(CountyName," County", "")) %>%
    select(c("county", last_col(12):last_col())) %>%
    mutate(four_bed_avg = rowMeans(select(.,starts_with("X")), na.rm = TRUE)) %>%
    select(c("county", "four_bed_avg")) %>% group_by(county) %>% summarize(four_bed_avg = round(mean(four_bed_avg)))
  
  ZHVI_5_rel <- ZHVI_5 %>% 
    mutate(county = str_replace(CountyName," County", "")) %>%
    select(c("county", last_col(12):last_col())) %>%
    mutate(fiveplus_bed_avg = rowMeans(select(.,starts_with("X")), na.rm = TRUE)) %>%
    select(c("county", "fiveplus_bed_avg")) %>% group_by(county) %>% summarize(fiveplus_bed_avg = round(mean(fiveplus_bed_avg)))
  
  ZHVI_condo_rel <- ZHVI_condo %>% 
    mutate(county = str_replace(CountyName," County", "")) %>%
    select(c("county", last_col(12):last_col())) %>%
    mutate(condo_avg = rowMeans(select(.,starts_with("X")), na.rm = TRUE)) %>%
    select(c("county", "condo_avg")) %>% group_by(county) %>% summarize(condo_avg = round(mean(condo_avg)))
  
  housing <- ZHVI_1_rel %>% 
    left_join(ZHVI_2_rel, by = "county") %>%
    left_join(ZHVI_3_rel, by = "county") %>%
    left_join(ZHVI_4_rel, by = "county") %>%
    left_join(ZHVI_5_rel, by = "county") %>%
    left_join(ZHVI_condo_rel, by = "county")
  setwd(original_path)
  return(housing)
}

# Example using functions

housing <- get_housing("~/tamu_datathon_2020/data")
setwd("~/tamu_datathon_2020/Data Extract/data")
save(housing, file = "housing.rda")