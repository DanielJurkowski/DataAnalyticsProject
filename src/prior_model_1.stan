data {
    int<lower=0> N; // Number of observations
    array[N] real<lower=0, upper=4> hours; // Hours spent studying predictor
    array[N] real<lower=0, upper=4> hangouts; // Hangouts predictor
}

generated quantities {
    array[N] real<lower=0, upper=100> predicted_gpa; // Predicted GPA for each observation

    // Coefficients
    real alpha = normal_rng(1.5, 0.2);
    real beta = normal_rng(-1, 0.3);
    real sigma = normal_rng(5, 0.5); 
    real theta = normal_rng(70, 3); 

    // Generate predicted GPA for each observation using a normal distribution with mean based on studying 
    // hours and hangouts 
    for (i in 1:N) {
        predicted_gpa[i] = normal_rng(theta + alpha * hours[i] + beta * hangouts[i], sigma);
    }
}
