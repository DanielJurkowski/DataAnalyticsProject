data {
    int<lower=0> N; // number of observations
}

generated quantities {
    array[N] real<lower=0, upper=100> predicted_gpa; // predicted GPA for each observation

    real<lower=0, upper=25> studying_hours = abs(normal_rng(7, 3)); // Randomly generate studying hours between 0 and 25, normal dist. with mean 7 and std 3
    real<lower=0, upper=4> hangouts = uniform_rng(0, 4); // Randomly generate hangouts between 0 and 4, uniformly distributed
    real<lower=0, upper=8> drinks = 8 * beta_rng(2, 3.5); // Randomly generate drinks per hangout, beta distribution shaped that most people would drink around 2 drinks per hangout

    // Parameteres for gamma distribution, chosen so that the average is about 70-80
    real alpha = 40;
    real beta = 14; 
    real scale = 100;

    // Generate predicted GPA for each observation using a gamma distribution summed with with mean based on studying 
    // hours, hangouts and consumption of alcohol (drinks per hangout)
    for (i in 1:N) {
        predicted_gpa[i] = scale * beta_rng(alpha, beta) + 0.75 * studying_hours + (-0.25) * hangouts * drinks;
    }
}