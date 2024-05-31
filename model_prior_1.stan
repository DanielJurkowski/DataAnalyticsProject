data {
    int<lower=0> N; // number of observations
}

generated quantities {
    // predicted average GPA for each observation
    vector[N]  predicted_gpa; 
    // randomly generate studying hours between 0 and 25, with mean 7 and standard deviation 3
    real<lower=0, upper=25> studying_hours = abs(normal_rng(7, 3)); 
    // randomly generate hangouts between 0 and 4, uniformly distributed
    real<lower=0, upper=4> hangouts = uniform_rng(0, 4);
    // randomly generate gender probability between 0 and 1, using a beta distribution with parameters 2 and 2
    real sigma = abs(normal_rng(0, 0.5)); 

    // generate predicted GPA for each observation using a normal distribution with mean based on studying 
    // hours, hangouts, gender probability, and constant values, and standard deviation sigma
    for (i in 1:N) {
        predicted_gpa[i] = normal_rng(70 + studying_hours * 1.5 + hangouts * (-1), sigma);
    }
}
