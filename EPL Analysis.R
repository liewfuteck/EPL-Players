epl = read.csv("D:/Github/EPL Footballers/epldata_final.csv", header=T)
epl$club <- gsub("[+]"," ",epl$club)

# For R, we are looking at the data from a statistical perspective.
# 1) We want to check if the ages of footballers in the Premier League follow
#    a normal distribution.

par(mfrow=c(2,1))
hist(epl$age[epl$position_cat==4],include.lowest=T,freq=F,
     main=paste("Histogram of Goalkeepers' Ages"),xlab="Age",
     ylab="Frequency", axes=T)
xpt <- seq(18,40,0.01)
ypt <- dnorm(xpt, mean(epl$age[epl$position_cat==4]), sd(epl$age[epl$position_cat==4]))
lines(xpt,ypt)

summary(epl$age[epl$position_cat==4])


outfield <- epl$position_cat==1|epl$position_cat==2|epl$position_cat==3
hist(epl$age[outfield],include.lowest=T,freq=F,
     main=paste("Histogram of Outfield Players' Ages"),xlab="Age",
     ylab="Frequency", axes=T)
xpt <- seq(18,40,0.01)
ypt <- dnorm(xpt, mean(epl$age[outfield]), sd(epl$age[outfield]))
lines(xpt,ypt)

summary(epl$age[outfield])

# From the 2 tables above, we can see that due to the much larger population 
# size of the outfield players, by Central Limit Theorem, the population converges to normal.

# As expected, due to the higher physical demands of outfield players, the mean, median, maximum and quantiles
# are all higher for goalkeepers as compared to that of outfield players.

# We also want to check on the correlation between fpl_values and being from a big club.
# Since one is a categorical, and the other is a numerical variable, we use the one-way ANOVA test.
model1 <- aov(epl$fpl_value~epl$big_club)
summary(model1)

# From output, we see that the null hypothesis (being from a big club and fpl value
# are independent has a p-value of < 2e-16. Hence, we can safely reject the null hypothesis, and conclude
# that the 2 variables are not independent.)


model2 <- aov(epl$fpl_points~epl$big_club)
summary(model2)
# Again, the probability of the one-way ANOVA is 9.37e-10. Hence, we can again safely reject the null
# hypothesis, and conclude that the 2 variables are not independent. This actually makes sense, since
# players from big clubs usually perform better to reflect the clubs' higher standing on the table. As a result, 
# they are more likely to gain fpl_points.

# We also want to check if there is a strong correlation between page_views and big_club.
model3 <- aov(epl$page_views~epl$big_club)
summary(model3)
# With the big clubs' higher popularity both domestically and overseas, it is more likely for their players
# to have higher page views (as a metric of popularity) as compared to players from smaller clubs.

# We hypothesize that there is a relationship between page_views and fpl_sel.
epl$fpl_sel <- gsub("[%]","",epl$fpl_sel)
epl$fpl_sel <- as.numeric(epl$fpl_sel)
cor.test(epl$fpl_sel, epl$page_views)
# From output, we see correlation between page_views and fpl_sel is not very high. Hence, it is unlikely that they
# have a linear relationship. To get a better idea, we plot the points out.

plot(epl$fpl_sel, epl$page_views)
# Unfortunately, there does not seem to be any form of meaningful relationship. This is surprising, as 
# fpl_sel and page_views are both measures of popularity, and it was expected there would be a linear positive
# relationship between the 2 variables.