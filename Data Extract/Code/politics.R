# Political Affiliation
source("package_load.R")

politics <- read.csv("./Data Extract/Data/CSV/politics.csv")

politics$Clinton.. <- as.numeric(politics$Clinton..)
politics$Clinton.. <- politics$Clinton.. / 100

politics$Trump.. <- as.numeric(politics$Trump..)
politics$Trump.. <- politics$Trump.. / 100

politics$Obama.. <- as.numeric(politics$Obama..)
politics$Obama.. <- politics$Obama.. / 100

politics$Romney.. <- as.numeric(politics$Romney..)
politics$Romney.. <- politics$Romney.. / 100

politics$Affil <- ifelse(is.na(str_extract(politics$PVI, "D")), "Rep","Dem")

politics$PVI_std <- as.numeric(substring(politics$PVI, 3))
politics$PVI_std <- ifelse(is.na(politics$PVI_std), 0, politics$PVI_std)
