# Approach:
- Identify region of interest (U.S)
- Decide on the granularity (Metropolitan Area/ CBSA code)
- Identify variables of interest
- Obtain relevant dataset for each variable (API, government, other websites)
- Process each dataset to obtain relevant columns
- Map each dataset from zip code/city/county level to Metropolitan area through CBSA ID
- Join all the mapped datasets into one table containing CBSA ID, and all relevant columns
- Analyze dataset using hieratical clustering 
