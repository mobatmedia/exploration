# Copyright 2017 Mario O. Bourgoin

library("rstan")

rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

y <- as.matrix(read.table('rats.txt', header = TRUE))
x <- c(8, 15, 22, 29, 36)
xbar <- mean(x)
N <- nrow(y)
T <- ncol(y)
fit <- stan(file = 'rats.stan')

print(fit)
plot(fit, pars = c("mu_alpha", "mu_beta", "sigmasq_alpha", "sigmasq_beta", "lp__"))
pairs(fit, pars = c("mu_alpha", "mu_beta", "sigmasq_alpha", "sigmasq_beta", "lp__"))
