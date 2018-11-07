 # following the sutorial here: http://www.sumsar.net/blog/2013/11/easy-laplace-approximation/ 
# on the laplace approximation... getting it sorted would be fantastic!

# so, in many situations the posterior is asymptotically normally distributed as the number of data points goes to infinity
# thus approximating theposterior with a normal could work exceptionally well, esp. if multivariate
# this is also friston's argument!

# often works well for generalized linear models though, so that's great!

rnorm(n=8, mean=10, sd=4)
# laplace approximation is not invariant to changes of basis, so you can chooes the basis where it works best
# which is amazing... can you always parametrise something to a normal? I doubt it
# well... you probably can actually in terms of soem arbitrary nonlinear transofmration which is cool!
# so why don't people do this all the time? if it can get arbitrarily good
# then I guess the trick is finding the correct shift in basis, which is some arbitrary nonlinear function
# which might be really hard to find... can you get a simple NN to do so? do you reckon?
# might this be something worth researching?

# so generate some arbitrary data - yi = normal(mu, sigma)
#mu = normal(0,1000)
#sigma = lognormal (0,4)

# generate some data by the following
set.seed(1337)
y <- rnorm(n=20, mean=10, sd=5)
p <- c(mean = mean(y), sd=sd(y))
# so next we define a function calculating the unnormalized log posteroir of the model given a param vector, and a vector of datapoints(y

model <- function(p, y) {
  log_lik <- sum(dnorm(y, p["mu"], p["sigma"], log=T))
  log_post <- log_lik + dnorm(p["mu"], 0, 100, log=T) + dnorm(p["sigma"],0,4,log=T)
  log_post
}
model(p, y)

# yeah... we're trying to find values for mu and sigma... but I don't know right?
#  I'm really confused there... so who knows?
# so presumably you are approximating the parameters of the distrubutions using Laplace....

# so we find the mode of the two dimensional posterior using the optim funtion!

inits <- c(mu=0, sigma=1)
fit <- optim(inits, model, control=list(fnscale=-1), hessian=TRUE, y=y) 
param_mean <- fit$par
param_cov_mat <- solve(-fit$hessian)
round(param_mean, 2) # round to two decimal places!
round(param_cov_mat, 3)
library(mvtnorm)
samples <- rmvnorm(10000, param_mean, param_cov_mat)
# so now let's do something to somehow get the predictive distribution... god knows how?
samples <- cbind(samples, pred=rnorm(n=nrow(samples), samples[,"mu"], samples[,"sigma"]))
# now use coda library to inspect the samples
library(coda)
samples <- mcmc(samples)
densityplot(samples)
# huh... well tat's annoying!
hist(samples)
densplot(samples)
summary(samples)


library(coda)
library(mvtnorm)

# Laplace approximation
laplace_approx <- function(model, inits, no_samples, ...) {
  fit <- optim(inits, model, control = list(fnscale = -1), hessian = TRUE,
               ...)
  param_mean <- fit$par
  param_cov_mat <- solve(-fit$hessian)
  mcmc(rmvnorm(no_samples, param_mean, param_cov_mat))
}

y <- rgamma(n = 20, rate = 10)



model <- function(p, y) {
  log_lik <- sum(dnorm(y, p["mu"], p["sigma"], log = T))
  log_post <- log_lik + dnorm(p["mu"], 5, 2, log = T) + dlnorm(p["sigma"],
                                                                 1, 5, log = T)
  log_post
}

model()

inits <- c(mu = 0, sigma = 1)
samples <- laplace_approx(model, inits, 10000, y = y)
densplot(samples)
