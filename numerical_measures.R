#calculating the mean is very straightforward
duration = faithful$eruptions
mean(duration)
waiting = faithful$waiting
mean(waiting)

# so is eadian
median(duration)

# quantile function gives all the quartiles
quantile(duration)
# percentile scan be done too by passing arbitrary decimal values to quantile
# i.e. the xth quantile
percentiles = quantile(duration, range(0.0,1, by=0.01))
percentiles = quantile(duration, c(0.32, 0.56,0.98))
percentiles

# range is the largest - the smallest
range(duration)
max(duration) - min(duration)

# interquartile range can just be done with the IQR function
IQR(duration)

# boxplots also have their ownfunction
boxplot(duration, horizontal=TRUE)

# same with variance
var(duration)
# and std
sd(duration)
sqrt(var(duration))

# covariance is also simple defined
cov(duration, waiting)

# pearsons correlation coefficient is also just a function
cor(duration, waiting)
# my own implementation
function mycor(x,y){
  cov(x,y) / (var(x) * var(y))
}
my_cor(duration, waiting)


# huh, the moment i sjust the sum of x - the mean to the power of k
# this can be achieved by the e1071 library (why on earth is it called that!?)

library(e1071)
moment(duration, order=3, center=TRUE)

# e1071 library also has kurtotic skewness measures
skewness(duration)
# and kurtosis
kurtosis(duration)
