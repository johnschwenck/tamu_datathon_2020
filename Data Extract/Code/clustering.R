library('tidyverse')

setwd('Data Extract/Data/')

load('merge_no_ind.rda')

merge_data = (merge 
              %>% select(-CBSA, -NAME, -`CBSA_name`,
                         -`City, State`, -`Year`, )
              %>% drop_na
              %>% data.frame)
rownames(merge_data) = (merge %>% drop_na)$CBSA

Delta = dist(merge_data)
out = hclust(Delta, method='centroid')

a1 = cutree(out, k=5)

table(a1)