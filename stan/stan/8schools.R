# Copyright 2017 Mario O. Bourgoin

library("rstan")

rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

schools_dat <- list(J = 8,
                    y = c(28, 8, -3, 7, -1, 1, 18, 12),
                    sigma = c(15, 10, 16, 11, 9, 11, 10, 18))

# Original model.
fit <- stan(file = '8schools.stan', data = schools_dat,
            iter = 1000, chains = 4)

print(fit, digits = 1)
plot(fit, pars = c("mu", "tau", "lp__"))
pairs(fit, pars = c("mu", "tau", "lp__"))

la <- extract(fit, permuted = TRUE) # return a list of arrays 
mu <- la$mu

### return an array of three dimensions: iterations, chains, parameters 
a <- extract(fit, permuted = FALSE)

### use S3 functions as.array (or as.matrix) on stanfit objects
a2 <- as.array(fit)
m <- as.matrix(fit)

# Updated model.
fit2 <- stan(file = '8schools2.stan', data = schools_dat,
             iter = 1000, chains = 4)

print(fit2, digits = 1)
plot(fit2, pars = c("mu", "tau", "lp__"))
pairs(fit2, pars = c("mu", "tau", "lp__"))

la <- extract(fit2, permuted = TRUE) # return a list of arrays 
mu <- la$mu

### return an array of three dimensions: iterations, chains, parameters 
a <- extract(fit2, permuted = FALSE)

### use S3 functions as.array (or as.matrix) on stanfit objects
a2 <- as.array(fit2)
m <- as.matrix(fit2)
