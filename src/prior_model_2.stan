data {
    int<lower=0> N; // number of observations
    array[N] real<lower=0, upper=4> hours;
    array[N] real<lower=0, upper=4> hangouts;
    array[N] real<lower=0, upper=4> drinks; // Drinks predictor
}

generated quantities {
    array[N] real<lower=0, upper=100> predicted_gpa; 

    // Adjust beta distribution for average 70-80% GPA
    real theta_1 = normal_rng(38, 2);
    real theta_2 = normal_rng(10, 1);

    // Predictors coefficients
    real a = normal_rng(1.5, 0.3);
    real b = normal_rng(0.75, 0.05);


    // Generate predicted GPA for each observation using a beta distribution
    for (i in 1:N) {
        predicted_gpa[i] = 100 * beta_rng(theta_1 + a * hours[i], theta_2 + b * hangouts[i] * drinks[i]);
    }
}
