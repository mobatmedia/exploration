# Copyright 2017 Mario O. Bourgoin

# Expectation maximization following:
# http://rstudio-pubs-static.s3.amazonaws.com/1001_3177e85f5e4840be840c84452780db52.html

library("mixtools")

# Data from a normal distribution mean = trueMean, sd = 1
set.seed(123) ## ensures we all see the same output
trueMean <- 10 ## suppose this true mean is unknown
n <- 20
x <- rnorm(n, mean = trueMean) ## sample data from a Normal distribution
print(x)

# Histogram
hist(x, col = "lavender")
abline(v = mean(x), col = "red", lwd = 2) ## highlight sample mean

# Candidate values
candidates <- function(x, n = length(x)) {
    min(x) + diff(range(x)) * seq(0, 1, length.out = n)
}

# Likelihood
likelihood <- function(FUN, params, ..., sample) {
    sapply(params, function(param) prod(FUN(sample, param, ...)))
}

# Plot 
params <- candidates(x, n = 50)
plot(params, likelihood(dnorm, params, sample = x), type = "b")

# Data from a mixture of two well-separated normals.
prob <- 0.75
mean1 <- 1
mean2 <- 7
n <- 1000
set.seed(123)
y <- rbinom(n, 1, prob) + 1
x <- rnorm(n, ifelse(y == 1, mean1, mean2))

# Density plot.
plot(density(x))
points(x, jitter(rep(0.01, length(x))), col = ifelse(y == 1, "black", "red"))

# Initial parameters.
p <- 0.5
mu1 <- 0
mu2 <- 1
iterations <- 10
# Fitting loop.
for (i in seq(iterations)) {
    # Expectation: Given the parameters, what are the latent variables?
    T1 <- p * dnorm(x, mu1)
    T2 <- (1 - p) * dnorm(x, mu2)
    P <- T1 / (T1 + T2)
    p <- mean(P)
    # Maximization: Given the latent variables, what are the parameters?
    mu1 <- sum(P * x) / sum(P)
    mu2 <- sum((1 - P) * x) / sum(1 - P)
    print(c(mu1 = mu1, mu2 = mu2, p = p))
}

myEM <- normalmixEM(x, mu = c(0, 1), sigma = c(1, 1), sd.constr = c(1, 1))
print(myEM$mu)
print(myEM$lambda)

# Data from a mixture of two less well-separated normals.
prob <- 0.75
mean1 <- 1
mean2 <- 4
n <- 1000
set.seed(123)
y <- rbinom(n, 1, prob) + 1
x <- rnorm(n, ifelse(y == 1, mean1, mean2))

# Density plot.
plot(density(x))
points(x, jitter(rep(0.01, length(x))), col = ifelse(y == 1, "black", "red"))

# Initial parameters.
p <- 0.5
mu1 <- 0
mu2 <- 1
iterations <- 30
# Fitting loop.
for (i in seq(iterations)) {
    # Expectation: Given the parameters, what are the latent variables?
    T1 <- p * dnorm(x, mu1)
    T2 <- (1 - p) * dnorm(x, mu2)
    P <- T1 / (T1 + T2)
    p <- mean(P)
    # Maximization: Given the latent variables, what are the parameters?
    mu1 <- sum(P * x) / sum(P)
    mu2 <- sum((1 - P) * x) / sum(1 - P)
    print(c(mu1 = mu1, mu2 = mu2, p = p))
}

myEM <- normalmixEM(x, mu = c(0, 1), sigma = c(1, 1), sd.constr = c(1, 1))
print(myEM$mu)
print(myEM$lambda)
