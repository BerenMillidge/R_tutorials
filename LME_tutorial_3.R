# this is the "dragons" tutorial from here:
#https://gkhajduk.github.io/2017-03-09-mixed-models/
# should hopefully be really interesting

library(lme4)
library(ggplot2)

# load data
dragons <-load("dragons.RDATA")
head(dragons)

# let's lets look at the distribution of response variable
# which is the test score we are looking at 
hist(dragons$testScore)

# use scale fucntion to normalise explanatory - i.e. predictor variables
dragons$bodyLength2 <- scale(dragons$bodyLength)

# let's start by fitting a really basic linear model
basic.lm <- lm(testScore ~ bodyLength2, data=dragons)
summary(basic.lm)

# let's try plotting
plot(dragons$testScore, dragons$bodyLength2)
# it dos look like there is definitely a posssible correlation there!s

ggplot(dragons, aes(x=bodyLength2, y=testScore)) + 
  geom_point() + 
  geom_smooth(method='lm')
# let's plot it properly

# so there's clearly an upward trend... that's good!
# the linear model is significant relationship p value
# let's check the assumptions - first homoscedascity of residuals

# get the residual plot
plot(basic.lm, which=1)
# so that's a bit of an unfortunate pattern - probably nonlinear
# data - so the erros seems less for both high and low test scores
# perhaps some kind of u shaped curve?
#let's experiment with the test scores
hist(dragons$testScore)
# the dragons test scores seems normal so that's good!
# let's look at the qq plot
plot(basic.lm, which=2)
# qq plot seems to be good, so normality of variance seems to wkr
# I can do shapiro test
model.shapiro <-shapiro.test(resid(basic.lm))
model.shapiro
# so the shapiro test is significant! this is bad right?
# the QQ plot seems okay though, so not sure what's happenign there1

# what about hte data across grouping factors. let's use boxplots
# to figure this out
boxplot(testScore ~ mountainRange, data=dragons)
# so yeah, clear difference between the mountains. this is going to really!
# throw off the analysis!
# also you can try plottingthe colours graph by mountain range
ggplot(dragons, aes(x=bodyLength2, y = testScore, colour=mountainRange)) +
  geom_point(size=2) + 
  theme_classic() + 
  theme(legend.position="none")

# ooh! that's really really cool. yeah... playing around with this is fun
# and really cool! so yeah then that's obvious the confounding effects of the mountain ranges
# the data within there aren't independent and you can't really ignore that!

# let's split data by moutnain range... which is surprisingly easy
# just using facet wrap!
ggplot(aes(bodyLength, testScore), data=dragons) + geom_point() +
  facet_wrap(~ mountainRange) + xlab("length") + ylab("test score")
# well that is REALLY cool! how easy it is to produce these graphs
# my god. R is really just forshort scripts, but it's amazingly powerful
# for doing this too though  kind of fire and forget code
# isbasically what R is for for qucik analysis and it does this perfectly!

# so the mountain range issue is significantly problematic... so what to do?
