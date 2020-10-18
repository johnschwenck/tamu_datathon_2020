source('package_load.R')

setwd('Data Extract/Data/')

for(i in 1:length(list.files(pattern = ".rda"))){
  load(list.files(pattern = ".rda")[i])
}

merge <- full_join( rent_price_metro , hc_rest_pop, by = "CBSA") # Rent & Healthcare/Restaurants/Population
merge <- full_join( industries_pop   , merge, by = "CBSA") # Industries
merge <- full_join( aqi_2019$CBSA    , merge, by = "CBSA") # Air Quality Index
merge <- full_join( pub_trans$CBSA   , merge, by = "CBSA") # Public Transportation
merge <- full_join( industries_pop   , merge, by = "CBSA")
pub_trans[which(!pub_trans$CBSA %in% merge$CBSA),]
