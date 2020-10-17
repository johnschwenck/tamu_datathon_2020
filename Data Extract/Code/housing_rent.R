require(dplyr)
setwd("~/tamu_datathon_2020/data")

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

get_rent_zip <- function(data_folder_path){
  original_path <- getwd()
  setwd(data_folder_path)
  
  rent <- readxl::read_xlsx("fy2021-safmrs.xlsx")
  
  rent_relevant <- c("ZIP\nCode", "HUD Metro Fair Market Rent Area Name", "CBSA","SAFMR\n0BR", "SAFMR\n1BR", "SAFMR\n2BR", "SAFMR\n3BR", "SAFMR\n4BR")
  
  # rent price for each zip code
  rent_price_zip <- rent %>% 
    mutate(CBSA = parse_number(`HUD Area Code`)) %>%
    select(rent_relevant) %>%
    rename(zip = `ZIP\nCode`,
           metro_name = `HUD Metro Fair Market Rent Area Name`,
           one_bed_rent = `SAFMR\n0BR`,
           two_bed_rent = `SAFMR\n1BR`,
           three_bed_rent = `SAFMR\n2BR`,
           four_bed_rent = `SAFMR\n3BR`,
           five_bed_rent = `SAFMR\n4BR`
    )
  setwd(original_path)
  return(rent_price_zip)
}

# average rent prices for each metro area (CBSA)

get_rent_metro <- function(rent_price_zip){
  rent_price_metro <- rent_price_zip %>% 
    group_by(CBSA) %>% 
    summarise_at(c("one_bed_rent", "two_bed_rent", "three_bed_rent", "four_bed_rent", "five_bed_rent"), mean)
  
  return(rent_price_metro)
}
  
rent_price_zip <- get_rent_zip("~/tamu_datathon_2020/data")
rent_price_metro <- get_rent_metro(rent_price_zip)

save(rent_price_zip, file = "rent_zip.rda")
save(rent_price_metro, file = "rent_metro.rda")