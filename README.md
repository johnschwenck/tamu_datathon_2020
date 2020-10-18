# Texas A&M Datathon 2020

### Team: 
- Allison Bertie Johnson (allisonbertie@tamu.edu)
- Arjun Ravikumar (arjun.cc@gmail.com)
- Christopher Han (christopherhan@stat.tamu.edu)
- John Schwenck (jschwenck@stat.tamu.edu)

# Variable Descriptions:  

### Housing (2019-2020):

Source: https://www.zillow.com/research/data/  
Raw Data: ZHVI_1.csv, ZHVI_2.csv, ZHVI_3.csv, ZHVI_4.csv, ZHVI_5.csv, ZHVI_condo.csv  
Processed Data: housing.rda 

Variable Descriptions:

- **CBSA**: Core-based statistical area code 
- **one_bed_avg**: Average price in dollars of one bedroom house
- **two_bed_avg**: Average price in dollars of two bedroom house
- **three_bed_avg**: Average price in dollars of three bedroom house
- **four_bed_avg**: Average price in dollars of four bedroom house
- **five_bed_avg**: Average price in dollars of five bedroom house
- **condo_avg**: Average price in dollars of a condo

### Rental Prices (2021 Forecast):

Source: https://www.huduser.gov/portal/datasets/fmr.html#2021_data   
Raw Data: fy2021-safmrs.xlsx  
Processed Data: rent_metro.rda

Variable Descriptions:

- **CBSA**: Core-based statistical area code 
- **one_bed_rent**: Fair Market Rent for one bedroom apartment
- **two_bed_rent**: Average price in dollars of two bedroom apartment
- **three_bed_rent**: Average price in dollars of three bedroom apartment
- **four_bed_rent**: Average price in dollars of four bedroom apartment
- **five_bed_rent**: Average price in dollars of five bedroom apartment

### Air Quality Index (2019): 

Source: https://aqs.epa.gov/aqsweb/airdata/download_files.html#Annual   
Raw Data: annual_aqi_by_cbsa_2019.csv   
Processed Data: air_quality.rda   

Variable Descriptions:  

- **City, State**: City and State for each entry
- **CBSA**:  Core-based statistical area code 
- **Median AQI**: Median Air Quality Index

### Public Transportation (2018): 

Source: https://api.census.gov/data/2018/acs/acs5/variables.html    
Raw Data:     
Census API key needed    
pub_trans = get_acs(variables = "B08006_008", 
                    geography="metropolitan statistical area/micropolitan statistical area")    
Processed Data: pub_trans.rda   

Variable Description: 

- **CBSA**: Core-based statistical area code  
- **NAME**: City, State Abbr. Area Type 
- **Avg_User**: Average number of users   

### Daily Average of Temperatures (2011):

Source: https://wonder.cdc.gov/controller/datarequest/D60     
Raw Data: max_avg_temps2011.txt and min_avg_temps2011.txt     
Processed Data: avg_temps_msa.rda     

Variable Description:

- **CBSA**: Core-based statistical area code 
- **mean(Avg.Min.Temp)**: mean average of minimum air temperature for each CBSA 
- **mean(Avg.Max.Temp)**: mean average of maximum air temperature for each CBSA 

### Covid Cases Report (2020):

Source      
Raw Data: us_covid_counties.csv     
Processed Data: covid_14dayavg.rda      

Variable Description: 

- **CBSA**: Core-based statistical area code  
- **mean(cases)**: Average number of Covid-19 cases from the date of the search
- **mean(deaths)**: Average number of Covid-19 related deaths from the date of the search
