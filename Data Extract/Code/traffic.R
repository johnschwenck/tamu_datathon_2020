require(dplyr)

get_traffic <- function(data_folder_path){
  original_path <- getwd()
  setwd(data_folder_path)
  
  t <- readxl::read_xlsx("traffic_urban_mobility.xlsx")
  
  traffic <- t %>% filter(Year %in% c(2016,2017)) %>%
    select("Urban Area", "Primary", "Year","Annual Hours of Delay") %>%
    rename(msa = `Urban Area`,
           state = Primary,
           annual_delay_person_hr = `Annual Hours of Delay`
    ) %>%
    group_by(msa) %>% 
    mutate(annual_delay_person_hr = round(mean(as.numeric(annual_delay_person_hr)))) %>%
    distinct(msa, .keep_all = T) 
  
  list12 <- readxl::read_xls("List12.xls", skip = 2)[,c(1,4)] 
  
  # remove last word to get rid of state
  list12 <- list12 %>% mutate(name = str_remove(`CBSA Title`, ",")) %>%
    distinct(`CBSA Title`, .keep_all = T)
  
  # remove last word to get rid of state from both traffic and list12
  traffic$name <- str_remove(traffic$msa, "\\s*[\\w-]*$")
  list12$name <- str_remove(list12$name, "\\s*[\\w-]*$")
  
  # shenanigans to make this work
  traffic$a <- substr(traffic$msa, 1 , 6)
  list12$a <- substr(list12$name, 1, 6)
  
  traffic_cbsa <- traffic %>% left_join(list12, by = c("a" = "a")) %>%
    select(`CBSA Code`, annual_delay_person_hr)
  
  traffic_cbsa <- traffic_cbsa[-c(2,3),]
  traffic_cbsa <- traffic_cbsa[!is.na(traffic_cbsa$`CBSA Code`),]
  traffic_cbsa <- traffic_cbsa %>% rename(CBSA = `CBSA Code`) %>% mutate(CBSA = as.numeric(CBSA), annual_delay_person_hr = as.numeric(annual_delay_person_hr))

  setwd(original_path)
  return(traffic_cbsa)
}

traffic_cbsa <- get_traffic(getwd())

save(traffic_cbsa, file = "traffic.rda")
