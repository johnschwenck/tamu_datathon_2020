source('package_load.R')

setwd('Data Extract/Data/')

for(i in 1:length(list.files(pattern = ".rda"))){
  load(list.files(pattern = "*.[Rr]da")[i])
}

df_list = list(rent_price_metro, hc_rest_pop, aqi_2019, pub_trans, housing, 
               covid_14dayavg_msa, avg_temps_msa, religion, trans, 
               rent_price_metro, housing, demograph, education)

df_name_list = c("rent_price_metro", "hc_rest_pop", "aqi_2019", "pub_trans", 
                 "housing", "covid_14dayavg_msa", "avg_temps_msa", "religion",
                 "trans", "rent_price_metro", "housing", "demograph", 
                 "education")

merge <- full_join( rent_price_metro      , hc_rest_pop, by = "CBSA") # Zip Metro Map & Rent
merge <- full_join( aqi_2019              , merge, by = "CBSA") # Air Quality Index
merge <- full_join( pub_trans             , merge, by = "CBSA") # Public Transportation
merge <- full_join( housing               , merge, by = "CBSA") # Housing Prices
merge <- full_join( covid_14dayavg_msa    , merge, by = "CBSA") # COVID cases / deaths
merge <- full_join( avg_temps_msa         , merge, by = "CBSA") # Avg Temps
merge <- full_join( religion              , merge, by = "CBSA") # Religion
#merge <- full_join( traffic_cbsa          , merge, by = "CBSA") # Traffic 
merge <- full_join( trans                 , merge, by = "CBSA") # Transportation Methods
merge <- full_join( rent_price_metro      , merge, by = "CBSA") # Avg Rent Price
merge <- full_join( demograph             , merge, by = "CBSA") # Demographics
merge <- full_join( education             , merge, by = "CBSA") # Education

length(merge$CBSA %>% unique)
for(i in seq(length(df_list))){
  print(str_c(df_name_list[i], length(df_list[[i]]$CBSA %>% unique), nrow(df_list[[i]]), sep=" "))
}

View(merge)

rename_fun = function(x){
  if((x %>% str_split(., c("\\(")))[[1]][1] == x){
    return(x)
  }
  else{
    return(((x %>% str_split(., c("\\(")))[[1]][2] %>% str_split(., c("\\)")))[[1]][1] )
  }
}

for(i in seq(length(names(merge)))){
  names(merge)[i] = rename_fun(names(merge)[i])
}

save(merge, file = 'merge_no_ind.rda')


#### Religion works now, updated regex, code below not necessary

merge <- full_join( industries_pop        , merge, by = "CBSA") # Industries
merge_w_ind <- merge 



save(merge_w_ind, file = 'merge_w_ind.rda')

