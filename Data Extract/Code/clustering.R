library('tidyverse')
library('googlesheets4')

drive_auth()
sheet1 = read_sheet("https://docs.google.com/spreadsheets/d/14vhMIdmZDV1Byz60ZbXbku4WedpkjHK8zlxawvU_CkA")



setwd('Data Extract/Data/')

load('merge_no_ind.rda')

merge_data = (merge 
              %>% select(-CBSA, -NAME, -`CBSA_name`,
                         -`City, State`, -`Year`,
                         -`pca_hc`, -`rest_hc`,
                         -`public_trans_time`,
                         -`priv_trans_all_time`,
                         -`priv_trans_carpool_time`,
                         -`walked_time`,
                         -`bike_cab_other_time`,
                         -`pop`, -`Avg_User`)
              %>% drop_na
              %>% data.frame)

merge_data = merge_data %>% mutate(edu_hs_only = edu_hs_only/total_pop,
                                   edu_ged_only = edu_ged_only/total_pop,
                                   edu_bs = edu_bs/total_pop,
                                   edu_ms = edu_ms/total_pop,
                                   edu_prof = edu_prof/total_pop,
                                   edu_phd = edu_phd/total_pop,
                                   priv_trans_all_qty = priv_trans_all_qty/total_pop,
                                   public_trans_qty = public_trans_qty/total_pop,
                                   walked_qty = walked_qty/total_pop,
                                   bike_cab_other_qty = bike_cab_other_qty/total_pop,
                                   work_from_home_qty = work_from_home_qty/total_pop,
                                   TOTCNG = TOTCNG/total_pop,
                                   TOTADH = TOTADH/total_pop,
                                   NONDCNG = NONDCNG/total_pop,
                                   NONDADH = NONDADH/total_pop,
                                   cases = cases/total_pop,
                                   deaths = deaths/total_pop,
                                   pca_hc = tot_emp_hc/total_pop,
                                   rest_hc = tot_emp_hc/total_pop,
                                   avg_time_to_work_all = log(avg_time_to_work_all),
                                   priv_trans_alone_time = log(priv_trans_alone_time),
                                   total_pop = log(total_pop),
                                   mean_temp = (Avg.Min.Temp + Avg.Max.Temp)/2,
                                   house_avg = (one_bed_avg + 0.5*two_bed_avg + 
                                                0.3333*three_bed_avg + 0.25*four_bed_avg +
                                                0.2*fiveplus_bed_avg)/(1+0.5+0.3333+0.25+0.2),
                                   rent_avg = (one_bed_rent + 0.5*two_bed_rent + 
                                               0.3333*three_bed_rent + 0.25*four_bed_rent +
                                               0.2*five_bed_rent)/(1+0.5+0.3333+0.25+0.2))
rownames(merge_data) = (merge %>% drop_na)$CBSA

all_cl = kmeans(merge_data, centers=20)
table(all_cl$cluster)

user_input_vars = c("Education", "Population", "Median Age", 
                    "Ease of Walking", "Ease of Biking", "Ease of Public Transportation",
                    "Work From Home?", "Religious Belief", "Weather", "COVID Cases/Deaths",
                    "Housing Price", "Rent", "Air Quality",
                    "Healthcare Access", "Restaurants and Bars", "Traffic")



# CHANGE THIS TO SIMULATE USER INPUT
user_sample = sample(0:3, length(user_input_vars), replace=T)

user_obs = rep(0, length(names(merge_data)))

education_q_1 = c(0.2, 0.2, 0.4, 0.6, 0.8, 0.8)
if(user_sample[1] == 1){
  user_obs[1:6] = map2(1-education_qtrend, merge_data[,1:6],
                       ~ quantile(.y, .x)) %>% unlist %>% unname 
} else if(user_sample[1] == 2){
  user_obs[1:6] = map2(rep(0.5, 6), merge_data[,1:6],
                       ~ quantile(.y, .x)) %>% unlist %>% unname
} else if(user_sample[1] == 3){
  user_obs[1:6] = map2(education_qtrend, merge_data[,1:6],
                       ~ quantile(.y, .x)) %>% unlist %>% unname
}

input_vars_1 = list("7"=user_sample[3],
                       "8"=user_sample[2],
                       "10"=case_when(user_sample[4]<=1 & user_sample[5]<=1 & user_sample[6]<=1 ~ 3,
                                    user_sample[4]==2 | user_sample[5]==2 | user_sample[6]==2 ~ 2,
                                    TRUE ~ 1),
                       "11"=user_sample[6],
                       "12"=user_sample[4],
                       "13"=user_sample[5],
                       "14"=user_sample[7],
                       "15"=user_sample[16],
                       "22"=user_sample[8],
                       "26"=user_sample[10],
                       "34"=user_sample[13],
                       "44"=user_sample[14],
                       "45"=user_sample[15],
                       "46"=user_sample[9],
                       "47"=user_sample[11],
                       "48"=user_sample[12])

permanent_filter = c(9, 16, 17, 18, 19, 20, 21, 23, 24, 25, 27, 28, 29, 30, 
                     31, 32, 33, 35, 36, 37, 38, 39, 40, 41, 42, 43)

input_vars_q_1 = c("D", "D", "D", "D", "D", "D", "D", "I",
                   "D", "I", "D", "D", "D", "D", "I", "I")
mirror_input_vars_1 = rep(0, length(input_vars_1))

for(i in seq(length(input_vars_q_1))){
  if(input_vars_q_1[i] == "D"){
    user_obs[as.integer(names(input_vars_1)[i])] = (quantile(merge_data[,as.integer(names(input_vars_1)[i])], 
                                                               0.25*input_vars_1[i] %>% unname %>% unlist))
  }
  else {
    mirror_input_vars_1[i] = case_when(input_vars_1[i]==1 ~ 3,
                                       input_vars_1[i]==3 ~ 1,
                                       TRUE ~ 2)
    user_obs[as.integer(names(input_vars_1)[i])] = quantile(merge_data[,as.integer(names(input_vars_1)[i])], 
                                                       0.25*mirror_input_vars_1[i])
  }
}

filter_columns = permanent_filter
for(i in seq(length(input_vars_1))){
  if(input_vars_1[i]==0){
    filter_columns = c(filter_columns, as.integer(names(input_vars_1[i])))
  }
}
if(user_sample[1]==0){
  filter_columns = c(filter_columns, 1:6)
}

merge_filter = merge_data[,-filter_columns]
user_filter = user_obs[-filter_columns]
merge_filter["New",] = user_filter

new_cl = kmeans(merge_filter, centers=20)
new_cluster_num = new_cl$cluster[names(new_cl$cluster)=="New"]
new_cluster_numcities = sum(new_cl$cluster==new_cluster_num)
new_cluster_cities = as.numeric(names(new_cl$cluster[new_cl$cluster==new_cluster_num])[1:new_cluster_numcities-1])

# SIMILAR CITIES PRINTED HERE
merge %>% filter(CBSA %in% new_cluster_cities) %>% select(NAME)

