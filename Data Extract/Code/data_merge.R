source('package_load.R')

setwd('Data Extract/Data/')

for(i in 1:length(list.files(pattern = ".rda"))){
  load(list.files(pattern = "*.rda")[i])
}

merge <- full_join( rent_price_metro, hc_rest_pop, by = "CBSA") # Zip Metro Map & Rent
#merge <- full_join( hc_rest_pop           , merge, by = "CBSA") # Healthcare/Restaurants/Population
merge <- full_join( industries_pop        , merge, by = "CBSA") # Industries
merge <- full_join( aqi_2019              , merge, by = "CBSA") # Air Quality Index
merge <- full_join( pub_trans             , merge, by = "CBSA") # Public Transportation
merge <- full_join( housing               , merge, by = "CBSA") # Housing Prices
merge <- full_join( covid_14dayavg_msa    , merge, by = "CBSA") # COVID cases / deaths
merge <- full_join( avg_temps_msa         , merge, by = "CBSA") # Avg Temps
merge <- full_join( religion              , merge, by = "CBSA") # Religion
merge <- full_join( traffic_cbsa          , merge, by = "CBSA") # Traffic 
merge <- full_join( trans                 , merge, by = "CBSA") # Transportation Methods
merge <- full_join( rent_price_metro      , merge, by = "CBSA") # Avg Rent Price
merge <- full_join( housing               , merge, by = "CBSA") # Avg Housing Price
merge <- full_join( demograph             , merge, by = "CBSA") # Demographics
merge <- full_join( education             , merge, by = "CBSA") # Education

View(merge)

# Religion doesn't load for some reason. Need to manually enter it via religion.R

save(merge, file = 'merge.rda')
