# Public transportation data 
# Source: 
library(tidycensus)
library(tidyverse)
options(tigris_use_cache = TRUE)
census_api_key("9080c0a6748ee902d3ab1f59571efa6416a7e3bf", install = T)

# public trans: B08006_009E
pub_trans = get_acs(variables = "B08006_008", 
                    geography="metropolitan statistical area/micropolitan statistical area") 

pub_trans = pub_trans %>% rename("CBSA" = "GEOID", "Avg_User" = "estimate")
pub_trans = pub_trans[,c(1,2,4)]

max(pub_trans$Avg_User, na.rm = TRUE)
min(pub_trans$Avg_User, na.rm = TRUE)
median(pub_trans$Avg_User, na.rm = TRUE)
mean(pub_trans$Avg_User, na.rm = TRUE)

save(pub_trans, file="pub_trans.rda")

