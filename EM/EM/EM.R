# Copyright 2017 Mario O. Bourgoin

# Expectation maximization following:
# http://rstudio-pubs-static.s3.amazonaws.com/1001_3177e85f5e4840be840c84452780db52.html

library("mixtools")

# Data from a normal distribution mean = trueMean, sd = 1
set.seed(123) # Ensures we all see the same output.
trueMean <- 10 # This true mean is the unknown.
n <- 20 # The sample size.
x <- rnorm(n, mean = trueMean) # Sample data from a Normal distribution.
print(x)

# Histogram.
hist(x, col = "lavender")
abline(v = mean(x), col = "red", lwd = 2) ## The sample mean.

# Candidate parameter values.
candidates <- function(x, n = length(x)) {
    min(x) + diff(range(x)) * seq(0, 1, length.out = n)
}

# The likelihood: for each param set in params, Lik(param|sample)=P(sample|param).
likelihood <- function(FUN, params, ..., sample) {
    sapply(params, function(param) prod(FUN(sample, param, ...)))
}

# Plot the candidate parameters against their likelihoods.
params <- candidates(x, n = 50)
plot(params, likelihood(dnorm, params, sample = x), type = "b")

# Two well-separated normal distributions with sd=1.
mu_black <- 1 # The mean of the black distribution.
mu_red <- 7 # The mean of the red distribution.
p_black <- 0.75 # The probability of drawing from the black distribution.
# Draw a sample drawn from the mixture of the black and red distributions.
n <- 1000 # The sample size.
set.seed(123) # Ensures repeatabiity.
y <- rbinom(n, 1, p_black) # Split the sample between the distributions.
x <- rnorm(n, ifelse(y == 1, mu_black, mu_red)) # Sample the mixture.

# Density plot of the mixture.
plot(density(x), main = "Sample Density")
points(x, rep(0.01, length(x)), col = ifelse(y == 1, "black", "red"))
abline(v = mean(x), lwd = 2)

# Initial parameter estimates.
mean_black <- 0
mean_red <- 1
prop_black <- 0.5
# Fitting loop.
iterations <- 10
print(c(i = 0, mean_black = mean_black, mean_red = mean_red, prop_black = prop_black), digits = 4)
for (i in seq(iterations)) {
    # Expectation: Given the parameters, what are the latent variables?
    T1 <- prop_black * dnorm(x, mean_black)
    T2 <- (1 - prop_black) * dnorm(x, mean_red)
    P <- T1 / (T1 + T2)
    # Maximization: Given the latent variables, what are the parameters?
    mean_black <- sum(P * x) / sum(P)
    mean_red <- sum((1 - P) * x) / sum(1 - P)
    prop_black <- mean(P)
    print(c(i = i, mean_black = mean_black, mean_red = mean_red, prop_black = prop_black), digits = 4)
}
print(table(actual = y, predicted = round(P)))

myEM <- normalmixEM(x, mu = c(0, 1), sigma = c(1, 1), sd.constr = c(1, 1))
print(with(myEM, c(mean_black= mu[1], mean_red = mu[2], prop_black = lambda[1])), digits = 4)
print(table(actual = y, predicted = round(myEM$posterior[, 1])))

# Two less well-separated normal distributions with sd=1.
mu_black <- 1
mu_red <- 4
p_black <- 0.75
# Draw a sample drawn from the mixture of the black and red distributions.
n <- 1000
set.seed(123)
y <- rbinom(n, 1, p_black)
x <- rnorm(n, ifelse(y == 1, mu_black, mu_red))

# Density plot.
plot(density(x))
points(x, jitter(rep(0.01, length(x))), col = ifelse(y == 1, "black", "red"))
abline(v = mean(x), lwd = 2)

# Initial parameter estimates.
mean_black <- 0
mean_red <- 1
prop_black <- 0.5
# Fitting loop.
iterations <- 30
print(c(i = 0, mean_black = mean_black, mean_red = mean_red, prop_black = prop_black), digits = 4)
for (i in seq(iterations)) {
    # Expectation: Given the parameters, what are the latent variables?
    T1 <- prop_black * dnorm(x, mean_black)
    T2 <- (1 - prop_black) * dnorm(x, mean_red)
    P <- T1 / (T1 + T2)
    # Maximization: Given the latent variables, what are the parameters?
    mean_black <- sum(P * x) / sum(P)
    mean_red <- sum((1 - P) * x) / sum(1 - P)
    prop_black <- mean(P)
    print(c(i = i, mean_black = mean_black, mean_red = mean_red, prop_black = prop_black), digits = 4)
}
print(table(actual = y, predicted = round(P)))

myEM <- normalmixEM(x, mu = c(0, 1), sigma = c(1, 1), sd.constr = c(1, 1))
print(with(myEM, c(mean_black = mu[1], mean_red = mu[2], prop_black = lambda[1])), digits = 4)
print(table(actual = y, predicted = round(myEM$posterior[, 1])))
