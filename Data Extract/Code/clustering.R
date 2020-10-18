library('tidyverse')

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
                         -`bike_cab_other_time`)
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
                                   priv_trans_alone_time = log(priv_trans_alone_time))
rownames(merge_data) = (merge %>% drop_na)$CBSA

a1 = kmeans(merge_data, centers=10)
table(a1$cluster)