Predicting the World Cup winner using Fifa Rankings, Elo Rantings & Transfer Market Values of the Team.

Data Sources: 
Fifa World Rankings : http://www.fifa.com/fifa-world-ranking/ranking-table/men/index.html 
Fifa world rankings are determined based on the teams performance in the international matches. Friendly matches are not considered in the rankings.
Elo Ratings: http://www.eloratings.net/2018_World_Cup_qualifying
Elo Ratings are calculated considering all perfromance of teams including friendly matches. Its complex matrix assigns points based on the type of competition the match is being played in and takes into account the goal difference between the two sides.
Trasfer Market values of the world cup teams: https://www.transfermarkt.com/world-cup-2018/teilnehmer/pokalwettbewerb/WM18
This website takes the estimated market value of all the players of a team.

Data Cleaning:
In the transfer market file, the market values were the curency expressed as 1,08 Bill. €. We have to clean this data and convert it into integer in order to use it. First step was to replace the "," with ".". Then replace the "Bill. €" or "Mill. €". Also, since few of the values were in billions, we converted them into millions to standardise the values. Final step was to convert all these values into numeric.

Method:
After data cleaning, next step is to standardise all these values to know the overall favourite. For this we calculated the z-scores for all the teams for all the three data frames. After that we calcluated the mean of the z-scores of the team to dervie the overall winner.
