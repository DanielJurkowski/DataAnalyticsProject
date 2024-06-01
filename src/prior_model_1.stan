data {
    int<lower=0> N; // Number of observations
}

generated quantities {
    array[N] real<lower=0, upper=100> predicted_gpa; // Predicted GPA for each observation

    real<lower=0, upper=25> studying_hours = abs(normal_rng(7, 3)); // Randomly generate studying hours between 0 and 25, normal dist. with mean 7 and std 3
    real<lower=0, upper=4> hangouts = uniform_rng(0, 4); // Randomly generate hangouts between 0 and 4, uniformly distributed

    real sigma = abs(normal_rng(0, 0.5)); // Std. for predicted GPA

    // Generate predicted GPA for each observation using a normal distribution with mean based on studying 
    // hours and hangouts 
    for (i in 1:N) {
        predicted_gpa[i] = normal_rng(70 + 1.5 * studying_hours + (-1) * hangouts, sigma);
    }
}
