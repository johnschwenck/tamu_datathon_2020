require(dplyr)

# FUNCTION: get zipcode merged with Metro code

get_zip_metro <- function(data_folder_path){
  original_path <- getwd()
  setwd(data_folder_path)
  uszipz <- read.csv("uszipz.csv")
  rel <- read.csv("zcta_cbsa_rel_10.txt")
  
  relevant <- c("zip", "city", "state_id", "population", "county_fips", "county_name")
  uszip <- uszipz[, relevant]
  merged <- uszip %>% left_join(rel, by = c("zip" = "ZCTA5")) %>% select(c(relevant, "CBSA"))
  
  setwd(original_path)
  return(merged)
}

# example using function

zip_metro <- get_zip_metro("~/tamu_datathon_2020/data")

setwd("~/tamu_datathon_2020")
save(zip_metro, file = "zip_metro.rda")
