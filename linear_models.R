#linear modelling basic tutorial from: 
#https://ourcodingclub.github.io/2017/02/28/modelling.html
# okay, downloaded the csv data!
# so choose which distibution you want to use - linear models ar
# typically gaussian in assumption - generalised linear models
# use other distributions, but the basic form of the model 
# is still y = mx + c - i.e. a linear relationship of some sort

# anyhow, so choosing the distibution to model your data is important
# you shuold really look at your data first in the exlporatory
#data analysis phase! anyhow...
# distributions you might want to use are: gaussian - use when 
# data continuous, symmetric, homoscedastic
# poisson - use for abundance /integer valued data. where 0 is likely
# i.e. lots of zeroes for non-occurence of event, events are independent
# and so forth. when data is left skewed - i.e. lots of zeroes and small numbers
# use binomial for when data is true or false presence/abscence!

# generally think statistically about what could affect your basic model
# how many exlpanatory variables do you want to include in the regression
# what do you wnat to control for. So on and so forth
# what might be the confounders?
# think generally about model structure... there mnust be some actual
# and useful way of quantitatively calculating the complexity of the modl
# r I guess you can just use bayes? and its normalisation properties
# to do the occams razor for you? but not in these frequentist cases?
# so there must be some other measures of model complexity, one would hope!

# anyhow, linear models. - sample dataset about apple yield

# installed package agridat for this
library(agridat)
library(ggplot2)
#load dataset
apples <- agridat::archbold.apple
# some basic exploratory data analysis!
head(apples)
summary(apples)


# okay, next step is apparently creating a ggplot2 theme
theme.clean <- function(){
  theme_bw()+
    theme(axis.text.x = element_text(size = 12, angle = 45, vjust = 1, hjust = 1),
          axis.text.y = element_text(size = 12),
          axis.title.x = element_text(size = 14, face = "plain"),             
          axis.title.y = element_text(size = 14, face = "plain"),             
          panel.grid.major.x = element_blank(),                                          
          panel.grid.minor.x = element_blank(),
          panel.grid.minor.y = element_blank(),
          panel.grid.major.y = element_blank(),  
          plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), units = , "cm"),
          plot.title = element_text(size = 20, vjust = 1, hjust = 0.5),
          legend.text = element_text(size = 12, face = "italic"),          
          legend.title = element_blank(),                              
          legend.position = c(0.9, 0.9))
}

# for the graph. which is fair enough

# okay, first hypothesis is that apple spacing affects yield - presumably
# the closer together the more they compete and less yield
apples$spacing
str(apples$spacing)
# so yeah, apples spacing has only 3 values but is numeric,
# so should probably call it a factor instead - just do the type conversion
apples$spacingFactor <- as.factor(apples$spacing)

# next plot using some horrendous ggplot boxplot thing
apples.p <- ggplot(apples, aes(spacingFactor, yield)) + 
  geom_boxplot(fill="#CF3333", alpha=0.8, colour = "#8B2323") +
  theme.clean() +
  theme(axis.text.x = element_text(size=12, angle=0)) + 
  labs(x="Spacing (m)", y="Yield (kg)")

apples.p
# so the boxplot is interesting. There is a clear trend towards
# higher yields with higher spacing in the mean, but OTOH
# the error bars almost completely overlap.
# let's test this though with a linear model
# format for linear model is lm(independent ~ dependent, data=data)
apples.m <- lm(yield ~ spacingFactor, data=apples)
summary(apples.m)
# so, the summary of the model is actually super useful!
# it appears that the results are actually significant, which is great!
# with fairly high significant results. p values are quite small
# the R-squared values aren't that high though which isn't surprising
# considering there are a lot of other sources of variability
# that's interesting though!

# okay, before you get too carried away, need to be sure that 
# the assumptions of the model are actually met. What are the assumptions of a linear model:
#here are some of them:
# - residuals are normally distributed
# - data are homoscedastic
# - data are independent samples (key!)

# let's test reisudals first
apples.resid <- resid(apples.m)
#use shapiro test to test this
apples.resid.result <- shapiro.test(apples.resid)
apples.resid.result
# so according to the shapiro-wilk normality test, they are normal
# so that's good!

# check for homoscedascity
apples.homoscedastic <- bartlett.test(apples$yield, apples$spacingFactor)
apples.homoscedastic

# so p = 0.1364 - so edging towards significance but not yet there
# so that's good too - assumptinos are met!

# so let's examine the model result using plot - gives four graphs
# a QQ plot of reisudla,s a scale locatio nplot, a plot of residuals
# vs leverage (what is this?) - i.e. presumably whether there are points
# which have huge influence on outcomes?
#anyhow...
plot(apples.m)
# so on the QQ plot they mostly stick to the line which is really good. Come off a bit at the edges, but that's fairly normal I would suspect!

# okay, so that was a general linear model. But what if data aren't normal!?
# here use a generalised linear model which can use other distibutions
# i.e. a poisson
# use the shagLPI dataset
getwd()
setwd("/home/beren/work/phd/eyetracking")
shag <- read.csv("shagLPI.csv", sep = ",")
head(shag)
#set year t obe numeric
shag$year <- as.numeric(shag$year)
# okay, data is loaded that's niec!
# make a histrogram to look at th sdistibution
shag.hist <- ggplot(shag, aes(pop)) + geom_histogram() + theme.clean()
shag.hist

# data represent data counts/event counts in intervals
# so a poisson distibution is the correct one!
# so create a generalised linear model with poisson
# not that difficult
shag.m <- glm(pop ~ year, family=poisson, data=shag)
summary(shag.m)
plot(shag.m)
# I still have no idea what this residuals vs leverage plot
# actuall means, which isn'treally ideal!
# the data is highly significant though, which is nice.
# let's plot the graph generally
shag.p <- ggplot(shag, aes(x = year, y = pop)) + 
  geom_point(colour = "#483D8B") + 
  geom_smooth(method=glm, colour="#483D8B", fill="#483D8B", alpha=0.6) + 
  scale_x_continuous(breaks=c(1975, 1985, 1990, 1995, 2000, 2005)) +
  theme.clean() + 
  labs(x=" " , y = "European Shag abundance")

shag.p

# so that's awesome. you can really create really neat graphs in R
# whic his perfect, and presumably why it is used so much. that's  really cooL!
# aes is apaprently an aesthetic function which maps geom properties
# to your data items. that makes sense!

# can also make models with binomial data too
weevil <- read.csv("Weevil_damage.csv", sep = ",")
weevil$block <- as.factor(weevil$block)
weevil.m <- glm(damage_T_F ~ block,family=binomial, data=weevil)
summary(weevil.m)