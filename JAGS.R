# tutorial from http://www.sumsar.net/blog/2013/06/three-ways-to-run-bayesian-models-in-r/ on running
# simple bayesian models in R

# JAGS is Just another gibbs sampler, and runs gibbs sampling on a model specificatoin
# to create a posterior mode analyser... which is cool!

library(rjags)

# crate a model specification string

model_string <- "model{
	for(i in 1:length(y)) {
	y[i] = ~ dnorm(mu, tau)
	}
	mu ~ dnorm(0.0001)
	sigma ~ dlnorm(0, 0.0625)
	tau <- 1/ pow(sigma,2)
}"

# and run the model!
model <- jags.model(textConnection(model_string), data=list(y=y), n.chains=3, n.adapt=10000)
update(model, 10000) # burnin for 10000 samples
mcmc_samples <- coda.samples(model, variable.names=c("mu", "sigma"), n.iter=20000)
# so it runs the samples which makes sense
