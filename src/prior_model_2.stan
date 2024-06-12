data {
    int<lower=0> N; // number of observations
    array[N] real<lower=0, upper=4> hours;
    array[N] real<lower=0, upper=4> hangouts;
    array[N] real<lower=0, upper=4> drinks; // Drinks predictor
}

generated quantities {
    array[N] real<lower=0, upper=100> predicted_gpa; 

    // Adjust beta distribution for average 70-80% GPA
    real theta_1 = lognormal_rng(3.63, 0.02);
    real theta_2 = lognormal_rng(2.3, 0.1);

    // Predictors coefficients
    real a = lognormal_rng(0.4, 0.1);
    real b = lognormal_rng(0.01, 0.1);
    real c = lognormal_rng(0.01, 0.1);

    // Generate predicted GPA for each observation using a beta distribution
    for (i in 1:N) {
        predicted_gpa[i] = 100 * beta_rng(theta_1 + a * hours[i], theta_2 + b * hangouts[i] + c * drinks[i]);
    }
}
