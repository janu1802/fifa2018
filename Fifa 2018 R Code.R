#This is try to preddict the Fifa 2018 world cup winners using different rankings system and basic statistics concept
#Getting the Fifa Rankings, Elo Ratings & Transfer Market Values in 3 data frames
fifa_ranking <- read.csv("Fifa rankings.csv", stringsAsFactors = F)
elo_ranking <- read.csv("Elo Rankings.csv", stringsAsFactors = F)
transfer_market <- read.csv("Transfer Market Rankings.csv", stringsAsFactors = F)

#Data Cleaning
#There is nothing to clean in the Fifa rankings & Elo ratings file. However the transfer market value file needs some data cleaning
#Also, since we require only country names and their points, creating new data frames with the required data only

str(transfer_market)
summary(transfer_market)
library(stringr)
transfer_new <- data.frame(transfer_market$Club, transfer_market$Market.value)
transfer_new$transfer_market.Market.value <-  gsub(",", ".", transfer_new$transfer_market.Market.value)
transfer_new$transfer_market.Market.value <-  gsub(" Mill. €", "", transfer_new$transfer_market.Market.value)
transfer_new$transfer_market.Market.value <- ifelse(str_detect(transfer_new$transfer_market.Market.value," Bill. €")== T, as.numeric(gsub(' Bill. €', '', transfer_new$transfer_market.Market.value))*1000, transfer_new$transfer_market.Market.value)
transfer_new$transfer_market.Market.value <- as.numeric(transfer_new$transfer_market.Market.value)

str(fifa_ranking)
summary(fifa_ranking)
fifa_new <- data.frame(fifa_ranking$country_full, fifa_ranking$total_points)

str(elo_ranking)
summary(elo_ranking)
elo_new <- data.frame(elo_ranking$Country, elo_ranking$Rating)

#Changing coloumn names for consistency

colnames(fifa_new)[which(names(fifa_new) == "fifa_ranking.country_full")] <- "Country"
colnames(fifa_new)[which(names(fifa_new) == "fifa_ranking.total_points")] <- "Points_fifa"
colnames(transfer_new)[which(names(transfer_new) == "transfer_market.Club")] <- "Country"
colnames(transfer_new)[which(names(transfer_new) == "transfer_market.Market.value")] <- "Points_transfer"
colnames(elo_new)[which(names(elo_new) == "elo_ranking.Country")] <- "Country"
colnames(elo_new)[which(names(elo_new) == "elo_ranking.Rating")] <- "Points_elo"

#Creating new file with only ratings and country name for the three ranking system
all_rating <- merge(transfer_new, fifa_new, by = "Country")
all_rating <- merge(all_rating, elo_new, by = "Country")


#calculating Mean & standard deviation of each data set
mean_fifa = mean(all_rating$Points_fifa)
mean_elo = mean(all_rating$Points_elo)
mean_transfer = mean(all_rating$Points_transfer)

std_fifa = sqrt((nrow(all_rating)-1)/nrow(all_rating)) * sd(all_rating$Points_fifa)
std_elo = sqrt((nrow(all_rating)-1)/nrow(all_rating)) * sd(all_rating$Points_elo)
std_transfer = sqrt((nrow(all_rating)-1)/nrow(all_rating)) * sd(all_rating$Points_transfer)


#Calculating z-score

all_rating$zscore_transfer <- round((all_rating$Points_transfer - mean_transfer)/std_transfer,2)
all_rating$zscore_fifa <- round((all_rating$Points_fifa - mean_fifa)/std_fifa,2)
all_rating$zscore_elo <- round((all_rating$Points_elo - mean_elo)/std_elo,2)
all_rating$overall_zscore <- round((all_rating$zscore_transfer + all_rating$zscore_fifa + all_rating$zscore_elo)/3,2)
write.csv(all_rating, file = "Final Fifa File.csv")

library(ggplot2)

#Visualizing the data frame and understanding the favourites in each of the rankings systems

all_rating$Country <- factor(all_rating$Country, levels = all_rating$Country[order(all_rating$zscore_elo)])
plot1 <- ggplot(all_rating, aes(Country, zscore_elo)) + 
  geom_bar(colour = "black",  fill = "green", stat='identity') + 
  coord_flip() +
  ggtitle("Elo Ratings") + 
  xlab("z-score Elo Ratings") + 
  ylab("Country")

all_rating$Country <- factor(all_rating$Country, levels = all_rating$Country[order(all_rating$zscore_fifa)])
plot2 <- ggplot(all_rating, aes(Country, zscore_fifa)) + 
  geom_bar(colour = "black",  fill = "green", stat='identity') + 
  coord_flip() +
  ggtitle("Fifa Ranking Points") + 
  xlab("z-score Fifa Ranking Points") + 
  ylab("Country")

all_rating$Country <- factor(all_rating$Country, levels = all_rating$Country[order(all_rating$zscore_transfer)])
plot3 <- ggplot(all_rating, aes(Country, zscore_transfer)) + 
  geom_bar(colour = "black",  fill = "green", stat='identity') + 
  coord_flip() +
  ggtitle("Transfer Value Market") + 
  xlab("z-score Transfer Value Market") + 
  ylab("Country")

require(gridExtra)
grid.arrange(plot1, plot2, plot3, ncol=3)

#Clealy, all the three have different winners. 
#According to elo ratings, Brazil is the Winner.
#According to Fifa rankings, Germany is winner
#According to Transfer Market Value, France is the winner since it has the most valued players
#The Elo ratings & Fifa rankings are predicting Germany vs Brazil Finals where as transfer maket value suggest France vs Spain

#Visualizing the overall scores to determine winners

all_rating$Country <- factor(all_rating$Country, levels = all_rating$Country[order(all_rating$overall_zscore)])
ggplot(all_rating, aes(Country, overall_zscore)) + 
  geom_bar(colour = "black",  fill = "green", stat='identity') + 
  coord_flip() +
  ggtitle("Fifa World Cup Outcomes") + 
  xlab("z-score") + 
  ylab("Country")

#Brazil is the clear favourite with 1.94 overall z-score followed by Germany with a score of 1.79

#Semi-finalist: Brazil, France, Spain & Belgium
#Finalist: Brazil & France
#Winners: Brazil
