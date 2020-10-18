# Religious Affiliation
source("package_load.R")

# Description:
# Data File: RCMSCY10(Description Only Codebook)

# 1) TOTCNG - All denominations/groups--Total number of congregations (2010)
# 2) TOTADH - All denominations/groups--Total number of adherents (2010)
# 3) TOTRATE - All denominations/groups--Rates of adherence per 1,000 population (2010)
# 407) NONDCNG - Non-denominational--Total number of congregations (2010)
# 408) NONDADH - Non-denominational--Total number of adherents (2010)
# 409) NONDRATE - Non-denominational--Rates of adherence per 1,000 population (2010)
# 562) FIPS - FIPS code
# 563) STCODE - State code
# 564) STABBR - State abbreviation
# 565) STNAME - State name
# 566) CNTYCODE - County code
# 567) CNTYNAME - County name
# 568) POP2010 - Population in 2010

religion <- read.csv("./Data Extract/Data/CSV/religion.csv")
religion <- religion[, c(1,2,3,407,408,409,562:ncol(religion))]

religion = religion %>% rename("CBSA" = "FIPS")

save(religion, file = "Data Extract/Data/religion.Rda")


