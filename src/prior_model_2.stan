data {
    int<lower=0> N; // number of observations
    array[N] real<lower=0, upper=4> hours;
    array[N] real<lower=0, upper=4> hangouts;
    array[N] real<lower=0, upper=4> drinks; // Drinks predictor
}

generated quantities {
    array[N] real<lower=0, upper=100> predicted_gpa; 

    real alpha = abs(normal_rng(25, 0.1));
    real beta = abs(normal_rng(8, 0.1));
    real a = normal_rng(0.75, 0.1);
    real b = normal_rng(-0.25, 0.05);

    // Generate predicted GPA for each observation using a beta distribution summed with values based studying 
    // hours, hangouts and consumption of alcohol
    for (i in 1:N) {
        predicted_gpa[i] = 100 * beta_rng(alpha, beta) + a * hours[i] + b * hangouts[i] * drinks[i];
    }
}
