data {
    // number of observations
    int<lower=0> N; 
}

generated quantities {
    // predicted average GPA for each observation
    vector[N] predicted_gpa; 
    // randomly generate studying hours between 0 and 25, with mean 7 and standard deviation 3
    real studying_hours = normal_rng(7, 3);
    // randomly generate hangouts between 0 and 4, uniformly distributed
    real hangouts = uniform_rng(0, 4);
    // Shape parameter for gamma distribution, chosen so that the average is about 70-80
    real alpha = 11; 
    // Scale parameter 
    real beta = 0.15; 

    for (i in 1:N) {
        // gamma distribution for predicting
        predicted_gpa[i] = gamma_rng(alpha, beta) + studying_hours * 0.5 - hangouts * 2;
    }
}