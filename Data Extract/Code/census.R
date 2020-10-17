source("package_load.R")

drive_auth()
gdrive_path = 'https://drive.google.com/drive/folders/1pn8WQuZ0EVBQ-4F4CN9NewINWVCtvo1m?usp=sharing'
drive_ls(gdrive_path)

# Census Data
options(tigris_use_cache = TRUE)
#census_api_key("9080c0a6748ee902d3ab1f59571efa6416a7e3bf") 

# Load a table of all data variables
acs_variables <- load_variables(2018, "acs5", cache = T)

# Obtain all necessary variables for model:
# - Median Age (Total)
# - Median Income
# - 
education <- get_acs(geography = "county",
          variables = c(edu_level = "B15003_001",
                      edu_hs_only = "B15003_017",
                      edu_ged_only = "B15003_018",
                      edu_bs = "B15003_022",
                      edu_ms = "B15003_023",
                      edu_prof = "B15003_024",
                      edu_phd = "B15003_025"),
        state = "NJ",
        #geometry = T, # Add this last for plotting, but this makes the processing SLOW
        year = 2018)



# Transportation Statistics --> FIX: the time to work numbers don't make sense (they are in minutes)
trans <- get_acs(geography = "county",
                     variables = c(public_trans_qty = "B08101_025",
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
                                   
                                   avg_time_to_work_all = "B08134_001"),
                     state = "NJ",
                     #geometry = T, # Add this last for plotting, but this makes the processing SLOW
                     year = 2018)
# Add B08006_008E: all public transportation



demogr <- get_acs(geography = "county",
                 variables = c(total_pop = "B01003_001",
                               med_age_total = "B01002_001",
                               med_income = "B19013_001"),
                 state = "NJ",
                 #geometry = T, # Add this last for plotting, but this makes the processing SLOW
                 year = 2018)




