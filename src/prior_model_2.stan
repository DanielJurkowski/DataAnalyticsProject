data {
    int<lower=0> N; // number of observations
    array[N] real<lower=0, upper=4> hours;
    array[N] real<lower=0, upper=4> hangouts;
    array[N] real<lower=0, upper=4> drinks;
}

generated quantities {
    array[N] real<lower=0, upper=100> predicted_gpa; // predicted GPA for each observation

    // Parameteres for gamma distribution, chosen so that the average is about 70-80
    real a = normal_rng(40, 0.5);
    real b = normal_rng(14, 0.3); 
    real alpha = abs(normal_rng(0.75, 0.1));
    real beta = abs(normal_rng(-0.25, 0.05));
    real scale = 100;

    // Generate predicted GPA for each observation using a gamma distribution summed with with mean based on studying 
    // hours, hangouts and consumption of alcohol (drinks per hangout)
    for (i in 1:N) {
        predicted_gpa[i] = scale * beta_rng(a, b) + alpha * hours[i] + beta * hangouts[i] * drinks[i];
    }
}
