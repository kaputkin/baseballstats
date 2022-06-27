library(baseballr)
library(plyr)


#get yesterdays date
date <- Sys.Date()-1

##pull live ball distance
d <- scrape_statcast_savant(date, date, player_type = 'batter')
d <- d[which(d$description == 'hit_into_play'),]
d <- d[,c(6,7,53)]

#aggregate by player
d.dist <- aggregate(x = d$hit_distance_sc,          
          by = list(d$player_name,d$batter),              
          FUN = sum)

data.dist.joined <- merge(data.dist, d.dist, by.x =(c("Group.1", "Group.2")), by.y =(c("Group.1", "Group.2")), all.x=T)
colnames(data.dist.joined) <- c("Player Name", "PlayerID", "Dist", "Dist_new")
colnames(data.dist.total) <- c("Player Name", "PlayerID", "Dist")

data.dist.total$Dist <- data.dist.total$Dist
