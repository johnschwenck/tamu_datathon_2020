# Air Quality Index 

aqi_2019 = read.csv("annual_aqi_by_cbsa_2019.csv")
aqi_2019 = aqi_2019[, c(1:3, 13)]
head(aqi_2019)

type(aqi_2019$CBSA.Code)
class(aqi_2019$CBSA.Code)

names(aqi_2019) = c("City, State", "CBSA", 
                    "Year", "Median AQI")
aqi_2019$CBSA = as.numeric(aqi_2019$CBSA)

save(aqi_2019, file='Code\ air_quality.rda')
