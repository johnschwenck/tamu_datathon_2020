# Procedure:

For the 2020 TAMU Datathon, our team chose to collaborated on creating a city search tool. The city search tool matches users based on a multitude of criteria with an ideal city or area that best fits their specifications. Over 10 different data sets were utilized to collect the most current data, spanning from recent air quality reports to covid-19 cases reported in the past 14 days. After thoroughly cleaning the data sets and merging all desired variables, our team applyed clustering techniques to organize outcomes based on selectable criteria. The user can visit the city search dashboard that we have created which asethetically formats the results of their criteria searches. 

Dashboard:  
Devpost: 

### Outline of approach:
- Identify region of interest (U.S)
- Decide on the granularity (Metropolitan Area/ CBSA code)
- Identify variables of interest
- Obtain relevant dataset for each variable (API, government, other websites)
- Process each dataset to obtain relevant columns
- Map each dataset from zip code/city/county level to Metropolitan area through CBSA ID
- Join all the mapped datasets into one table containing CBSA ID, and all relevant columns
- Analyze dataset using hieratical clustering 
- Utilize Power BI to create visuals 

