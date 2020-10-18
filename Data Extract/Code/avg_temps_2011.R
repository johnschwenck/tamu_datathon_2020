# Daily average for maximum temperatures in 2011
max_avg_temp = read.csv("max_avg_temps2011.txt", sep="\t")
max_avg_temp = max_avg_temp[seq(1, nrow(max_avg_temp), 2), ]
head(max_avg_temp)

# Daily average for minimum temperatures in 2011
min_avg_temp = read.csv("min_avg_temps2011.txt", sep="\t")
min_avg_temp = min_avg_temp[seq(1, nrow(min_avg_temp),2),]
head(min_avg_temp)

sum(max_avg_temp$County==min_avg_temp$County)
# [1] 3145

avg_temps = data.frame(max_avg_temp$County, max_avg_temp$County.code, avg.max.temp = max_avg_temp$Avg.Daily.Max.Air.Temperature..F.)

avg_temps = inner_join(min_avg_temp, max_avg_temp)
head(avg_temps)

names(avg_temps)[8] = "Avg.Min.Temp"
names(avg_temps)[9] = "Avg.Max.Temp"

avg_temps = avg_temps %>% mutate("Avg.Mean.Temp" = (Avg.Min.Temp + Avg.Max.Temp)/2)

head(avg_temps)

save(avg_temps, file="Data Extract/avg_temps_2011.rda")
