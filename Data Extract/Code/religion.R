# Religious Affiliation
source("../../package_load.R")

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

religion <- read.csv("./CSV/religion.csv")
religion <- religion[, c(1,2,3,407,408,409,562:ncol(religion))]

msa_table = read_excel('C:\\Users\\Arjun\\Downloads\\Projects\\devel\\datathon\\county_to_cbsa.xlsx')

msa_table = (msa_table 
             %>% mutate(fips = paste0(`FIPS State Code`, `FIPS County Code`))
             %>% select("CBSA Code", "fips")
             %>% rename("CBSA" = "CBSA Code")
             %>% mutate(CBSA = as.numeric(CBSA)))

religion = religion %>% 
  left_join(zip_metro, by = c("FIPS" = "county_fips")) %>%
  select(c(1:13, last_col())) %>% # select relevant columns
  distinct(FIPS, CBSA, .keep_all = T) # only keep unique combination of FIPS and CBSA

religion = (religion 
            %>% select(-CBSA)
            %>% distinct()
            %>% mutate(fips = str_pad(FIPS, 5, pad="0"))) # remove CBSA and duplicates

religion =  (left_join(religion, msa_table, by="fips")
             %>% drop_na(CBSA)
             %>% group_by(CBSA)
             %>% summarize(sum(TOTCNG), sum(TOTADH), 
                           sum(NONDCNG), sum(NONDADH),
                           mean(TOTRATE), mean(NONDRATE))) # summarize across CBSA

save(religion, file = "religion.rda")

