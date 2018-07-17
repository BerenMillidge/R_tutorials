# probability distributions are all included in the standard library too
# which is cool!

dbinom(4, size=12, prob=0.2)

# so the general rule for probability distributions is that d-dist is the probability
# of a point. p-dist is the cumulative distribution up to some poin
# r-dist is a random sample from the distribution

# poisson is unsuprirsing
ppois(16, lambda = 12)

runif(10, min=1, max=3)

pexp(2, rate=1/3)

# norm is norm
pnorm(84, mean=72, sd=15.2, lower.tal=FALSE)

# chi squared as well
#quantile function in distributions is q-dist
qchisq(0.95, df=8)

# 2 distrbution - quantile function
qt(c(0.025, 0.975), df=5)

# f is the anova distribution
qf(0.95, df1=5, df2=2)
