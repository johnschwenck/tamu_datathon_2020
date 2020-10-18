source("package_load.R")

drive_auth()
gdrive_path = 'https://drive.google.com/drive/folders/1pn8WQuZ0EVBQ-4F4CN9NewINWVCtvo1m?usp=sharing'
drive_ls(gdrive_path)

# Census Data
options(tigris_use_cache = TRUE)
#census_api_key("9080c0a6748ee902d3ab1f59571efa6416a7e3bf") 

# Load a table of all data variables
acs_variables <- load_variables(2018, "acs1", cache = T)

# All FIPS codes
fips_codes

# Obtain all necessary variables for model:
# - Education
# - Transportation
# - Demographics
#   - Total Population
#   - Median Age (Total)
#   - Median Income



usa <- c(
  'AL',
  'AK',
  'AZ',
  'AR',
  'CA',
  'CO',
  'CT',
  'DE',
  'FL',
  'GA',
  'HI',
  'ID',
  'IL',
  'IN',
  'IA',
  'KS',
  'KY',
  'LA',
  'ME',
  'MD',
  'MA',
  'MI',
  'MN',
  'MS',
  'MO',
  'MT',
  'NE',
  'NV',
  'NH',
  'NJ',
  'NM',
  'NY',
  'NC',
  'ND',
  'OH',
  'OK',
  'OR',
  'PA',
  'RI',
  'SC',
  'SD',
  'TN',
  'TX',
  'UT',
  'VT',
  'VA',
  'WA',
  'WV',
  'WI',
  'WY'
)





# Education
edu_vars = c(
  #edu_level = "B15003_001",
  edu_hs_only = "B15003_017",
  edu_ged_only = "B15003_018",
  edu_bs = "B15003_022",
  edu_ms = "B15003_023",
  edu_prof = "B15003_024",
  edu_phd = "B15003_025"
)

education <- get_acs(geography = "metropolitan statistical area/micropolitan statistical area",
                     variables = edu_vars,
                     state = usa[1],
                     #geometry = T, # Add this last for plotting, but this makes the processing SLOW
                     year = 2016,
                     survey = "acs5")

for(i in 2:length(usa)){
  education <- rbind(education,
                     get_acs(geography = "metropolitan statistical area/micropolitan statistical area",
                             variables = edu_vars,
                             state = usa[i],
                             #geometry = T, # Add this last for plotting, but this makes the processing SLOW
                             year = 2016,
                             survey = "acs5"))
}

education$CBSA <- as.numeric(substr(as.character(education$GEOID),start = 3, nchar(as.character(education$GEOID)) ))

save(education, file = 'C:\\Users\\John\\Documents\\GitHub\\tamu_datathon_2020\\Data Extract\\Data\\education.rda')









# Transportation Statistics --> FIX: the time to work numbers don't make sense (they are in minutes)

trans_vars = c(
  public_trans_qty = "B08101_025",
  public_trans_time = "B08134_061",
  
  priv_trans_all_qty = "B08101_009",
  priv_trans_all_time = "B08134_011",
  
  priv_trans_alone_qty = "B08101_009",
  priv_trans_alone_time = "B08134_021",
  
  priv_trans_carpool_qty = "B08301_004",
  priv_trans_carpool_time = "B08134_031",
  
  walked_qty = "B08101_033",
  walked_time = "B08134_101",
  
  bike_cab_other_qty = "B08101_041",
  bike_cab_other_time = "B08134_111",
  
  work_from_home_qty = "B08101_049",
  
  avg_time_to_work_all = "B08134_001"
)
# Add B08006_008E: all public transportation



trans <- get_acs(geography = "metropolitan statistical area/micropolitan statistical area",
                     variables = trans_vars,
                     state = usa[1],
                     #geometry = T, # Add this last for plotting, but this makes the processing SLOW
                     year = 2016,
                     survey = "acs5")

for(i in 2:length(usa)){
  trans <- rbind(trans,
                     get_acs(geography = "metropolitan statistical area/micropolitan statistical area",
                             variables = trans_vars,
                             state = usa[i],
                             #geometry = T, # Add this last for plotting, but this makes the processing SLOW
                             year = 2016,
                             survey = "acs5"))
}

trans$CBSA <- as.numeric(substr(as.character(trans$GEOID),start = 3, nchar(as.character(trans$GEOID)) ))

save(trans, file = 'C:\\Users\\John\\Documents\\GitHub\\tamu_datathon_2020\\Data Extract\\Data\\transportation.rda')









# Demographic Variables
demograph_vars = c(
  total_pop = "B01003_001",
  med_age_total = "B01002_001",
  med_income = "B19013_001"
)

# demogr <- get_acs(geography = "metropolitan statistical area/micropolitan statistical area",
#                  variables = c(demogr_vars),
#                  state = "NJ",
#                  geometry = T, # Add this last for plotting, but this makes the processing SLOW
#                  year = 2018)


demograph <- get_acs(geography = "metropolitan statistical area/micropolitan statistical area",
                 variables = demograph_vars,
                 state = usa[1],
                 #geometry = T, # Add this last for plotting, but this makes the processing SLOW
                 year = 2016,
                 survey = "acs5")

for(i in 2:length(usa)){
  demograph <- rbind(demograph,
                 get_acs(geography = "metropolitan statistical area/micropolitan statistical area",
                         variables = demograph_vars,
                         state = usa[i],
                         #geometry = T, # Add this last for plotting, but this makes the processing SLOW
                         year = 2016,
                         survey = "acs5"))
}

demograph$CBSA <- as.numeric(substr(as.character(demograph$GEOID),start = 3, nchar(as.character(demograph$GEOID)) ))

save(demograph, file = 'C:\\Users\\John\\Documents\\GitHub\\tamu_datathon_2020\\Data Extract\\Data\\demographics.rda')



# 
# 
# 
# counties <- fips_codes %>%
#   filter(state %in% usa)
# 
# demogr_all <- map2(
#   counties$state_code, counties$county_code,
#   ~ get_acs(
#     geography = "metropolitan statistical area/micropolitan statistical area",
#     variables = demogr_vars,
#     state = .x,
#     county = .y,
#     year = 2018,
#     survey = "acs5",
#     geometry = TRUE
#   )
# ) %>%
#   print()
# 
# demographics <- reduce(demogr_all, rbind) %>%
#   print()


# 
# 
# #############################################
# 
# f1 = function(state, county){
#   print(paste0(state, " : ", county))
#   get_acs(
#     geography = "metropolitan statistical area/micropolitan statistical area",
#     variables = demogr_vars,
#     state = state,
#     #county = county,
#     year = 2018,
#     survey = "acs5",
#     geometry = TRUE
#   )
# }
# 
# demogr_all_test <- map2(
#   counties$state_code[1], counties$county_code[1],
#   ~ f1(.x, .y)
# ) %>%
#   print()
# 
