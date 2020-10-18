library('tidyverse')
library('tidycensus')
library('readxl')

census_api_key("07ef51c4b8508066879116205191a09a92773321")

labor = read_excel('C:/Users/Arjun/Downloads/Projects/devel/datathon/MSA_M2019_dl.xlsx', col_names=T)
labor_healthcare = (labor %>% filter(o_group=="major", occ_code %in% c("29-0000")) 
                    %>% select(area, area_title, tot_emp, loc_quotient))
labor_restaurants = (labor %>% filter(o_group=="major", occ_code %in% c("35-0000")) 
                     %>% select(area, area_title, tot_emp, loc_quotient))

pop = get_acs(geography = "metropolitan statistical area/micropolitan statistical area",
              variables = c("B01003_001E"),
              year = 2018)

# pop = get_decennial(geography = "metropolitan statistical area/micropolitan statistical area",
#                     variables = c("H010001"),
#                     year=2010)
pop = pop %>% rename(area=GEOID) %>% select(area, estimate)

labor_pop = inner_join(labor_healthcare, labor_restaurants, by=c("area", "area_title"), suffix=c("_hc", "_rest"))
labor_pop = labor_pop %>% left_join(pop, by=c("area"))

hc_rest_pop = (labor_pop %>% mutate(tot_emp_hc = as.numeric(tot_emp_hc),
                                 tot_emp_rest = as.numeric(tot_emp_rest),
                                 pca_hc = tot_emp_hc/estimate,
                                 rest_hc = tot_emp_hc/estimate) 
             %>% rename(CBSA = area,
                        CBSA_name = area_title,
                        pop = estimate)
             %>% mutate(CBSA = as.numeric(CBSA)) 
             %>% drop_na)

save(hc_rest_pop, file="Data Extract/Data/healthcare_restaurants_labor.rda")

industries = (labor %>% filter(o_group=="major")
              %>% mutate(tot_emp = as.numeric(tot_emp))
              %>% drop_na(tot_emp)
              %>% group_by(area))
industries_pop = industries %>% left_join(pop, by=c("area"))
industries_pop = (industries_pop %>% mutate(pca = tot_emp/estimate)
                  %>% rename(CBSA = area,
                             CBSA_name = area_title,
                             pop = estimate)
                  %>% mutate(CBSA = as.numeric(CBSA))
                  %>% select())

save(industries_pop, file="Data Extract/Data/industries_labor.rda")
