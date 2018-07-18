# this is the "dragons" tutorial from here:
#https://gkhajduk.github.io/2017-03-09-mixed-models/
# should hopefully be really interesting

library(lme4)
library(ggplot2)

# load data
dragons <-load("dragons.RDATA")
head(dragons)

hist(dragons$testScore)
plot(dragons$testScore, dragons$bodyLength)
boxplot(dragons$bodyLength ~ dragons$mountainRange + dragons$site, data=dragons)



dragons
# let's lets look at the distribution of response variable
# which is the test score we are looking at 
hist(dragons$testScore)
hist(dragons$bodyLength)

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
# how does it alsodo the variance/uncertainty? I don't get that!
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
# can just try adding it as a fixed factor
#as technically it is categorical - i.e. it does 'exhaust' the variation
# in the factor
mountain.lm = lm(testScore ~ bodyLength2, data=dragons)
summary(mountain.lm)

# so the trouble is this gives a p value for every mountain range
# which is not what you're interested in. - if it was then this would be totally valid
# but here you want the overall trend not slpit up by mountain range
# so a random factor is better - interestinlgy R won't do continuous random factors
# although obviosuly numeric like subject ID would be allowd
# also as a general principle, if not the main analysis, around >5 factors do it a sa random factor
# below that you could just do it as a fixed factor

# so if you are going to include it as a random factor, you need a mixed model!
# so instead fix a random effect model
mixed.lmer <- lmer(testScore ~ bodyLength2 + (1|mountainRange), data=dragons)
summary(mixed.lmer)
# lets plot the lmer to test assumptions
plot(mixed.lmer)
# so residuals for eahc factor seem fairly normally distributed
# which is good and across seesm reasonable!

qqnorm(resid(mixed.lmer))
# qq plot is really good!
qqline(resid(mixed.lmer))
# also really good!

# so used 1| mountain range. whatever is on the right ofthe | is the grouping factor
# in that case. 
# so random effects can be crossed or nested... so, there are hierarchical
# linear models - HLMs or multilevel models - these are with nested hierarchical factors
# but not all mixed models are hierarchical, even complex ones
# you can have nonhierarchical crossed factors!
# i.e. suppose that you  test each dragon multiple times
# and also that you could observe the same dragon at different mountain
# ranges (since they can fly!) # and all dragons might be multiply observed (fully crossd factors)
# or you can assume only some of them (partially crossed factors)

# factors can als be nested! but implicitly - i.e. each site is within a mountain range
# but the sites 1,2,3 are called the same for all mountain ranges
# but are obviously not the same!!! instead you need to have explicit
# nesting over implicit because implicit nesting like this can obviosuly confuse the system
# if it compares all site 3s or whatever as if they were exactly the same
# so create a new sample column
samples <- within(dragons, sample <- factor(mountainRange:site))
samples
dragons
# well I've overwritten dragons. oh well!
# implict nesting will confuse the lmer algorithm so that's really bad
# you need explicitly nested factors

mixed.lmer2 = lmer(testScore ~ bodyLength2 + (1|mountainRange) + (1|sample), data=dragons)
summary(mixed.lmer2)

# this is relly cool
dragons
# let's now plot the sites and the dragons
ggplot(dragons, aes(x=bodyLength, y=testScore, colour=site)) + 
  facet_wrap(~mountainRange, nrow=3) +
  geom_point() + 
  theme_classic() +
  geom_line(data=cbind(dragons, pred=predict(mixed.lmer2)), aes(y=pred)) +
  theme(legend.position="NONE")

# this is relaly cool! this graphic system seems fully flexuble even though I dno't understand it at all!
# which is awesome. it seems a whole lot nicer than matplotlib!

# you can use the stargazer library to present the tables
library(stargazer)

stargazer(mixed.lmer2, type="text", digits=3, star.cutoffs = c(0.05,0.01, 0.001), digit.separator="")

# so for getting "pvalues" the best easy thing is likelihood ratio tests
# the good alterantive is MCMC and parametric bootstrapping for whateverthat is
# but who knows how that works in actuality!
# so now I know why you need REML = FALSE for the anova - it's because
# reml is restricted or residual maximum likliehood
# you need t ouse ML estimates since REML assumes the fixed effects structure
# is correct while ML doesn't rely on thecoefficients of the fixed effects
# while REML is usually less biased than the ML estimate in cases where
# the fixed effects structure iscorrect
# even though you use ML to compare models, get the parameter estimates
# from the best REML model as ML underestimates teh variance of random effects
# you can also use AICc(model) for the Akaike informatino criterion testing