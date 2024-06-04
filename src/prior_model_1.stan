data {
    int<lower=0> N; // Number of observations
    array[N] real<lower=0, upper=4> hours;
    array[N] real<lower=0, upper=4> hangouts;
}

generated quantities {
    array[N] real<lower=0, upper=100> predicted_gpa; // Predicted GPA for each observation

    real alpha = abs(normal_rng(1.5, 1));
    real beta = abs(normal_rng(-1, 0.3));
    real sigma = abs(normal_rng(5, 1)); 
    real offsett = abs(normal_rng(70, 10)); 

    // Generate predicted GPA for each observation using a normal distribution with mean based on studying 
    // hours and hangouts 
    for (i in 1:N) {
        predicted_gpa[i] = normal_rng(offset + alpha * hours[i] + beta * hangouts[i], sigma);
    }
}
