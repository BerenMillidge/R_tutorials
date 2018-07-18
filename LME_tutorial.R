# okay, simple LME tutorials from here: http://www.bodowinter.com/tutorial/bw_LME_tutorial1.pdf
# should be interesting to try to figure some of this stuff out!

# create fake dataset
pitch <- c(233,204,242,130,112,142)
sex <- c(rep("female", 3), rep("male",3))
#combine into dataframe
df = data.frame(sex, pitch)
df

# create the linear model
model <- lm(pitch ~sex, data=df)
summary(model)
# so very strong success it seems from the summary statistics!
# remember, the p value is the probability under the condition that
# the null hypothesis is true! not that your model is actually true!
# which is a very good point... you're model is not confirmed by it
# rather that your data is very unlikely to arise given the null!
# so once again you need to input the F values into the writeup 
# which makes sense!
# so "fixed effects" are essentially just predictor variables.

# you can also obviously construct continuous models
age = c(14,23,35,48,52,67)
pitch = c(252, 244, 240,233,212,204)
df2 <- data.frame(age, pitch)
xmdl = lm(pitch ~ age, df2)
summary(xmdl)


# but the actual intercept is meaningless, let's normalise by subtracting the mean
norm <- df2$age - mean(df2$age)
norm
df2$age_norm <- norm
model2 <- lm(pitch ~ age_norm, data=df2)
summary(model2)

# so I'm not sure what that was dealt with... but who knows?

# obviously you can also extend the linear model to more fixed effects
# this does the final predicted result as a linear combination of the fixed effects
# i.e. y = w1x1 + w2x2 + w3x3 ... + e

# so obviously the linear model is a model which has assumptions
# if the assumptions are not met then the model results are invalid
# but not necessarily incorrect!!! generally they can be quite robust
# to a lot of the assumption problems, excepindependence of data

# homoscedasticty -you test this with the residual plot!?
# another is no collinearity - all your fixed effects/ predictor variables 
# should be linearly independent. If they arenot then obviously the factors
# both will explain and eat into the variance that each explain, since they are obviously
# related to each other!
# yeah, model becomes unstable - i.e. order of mdoels and all sorts
# of things can swap around the levels of significance can be very
# various!

# residuals should be linear - i.e. presumably data is actually linear
# in some sense. model will fail if that fails obviously

# residuals should ideally be normally distributed - no crazy outlier
# residuals... the model is actually fairly robust to this so it doesn't really matter
# but check in any case with QQ plot

# absence of outliers/influential single data points - you can test this 
# with dfbeta() r function where it reruns the model various times
# with individual datapoints excluded to figure outwhat happens there
 # i.e. "leave one out diagnostics!"

# independence in your data items!! this is vital. without this the model is probably worthless
# this is what mixed and hierarchical mdoels arefor... for dealing with this stuff!
# so you can model this!
