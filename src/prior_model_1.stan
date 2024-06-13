data {
    int<lower=0> N; // Number of observations
    array[N] real<lower=0, upper=4> hours; // Hours spent studying predictor
    array[N] real<lower=0, upper=4> hangouts; // Hangouts predictor
    array[N] real<lower=0, upper=4> drinks; // Drinks predictor
}

generated quantities {
    array[N] real<lower=0, upper=100> predicted_gpa; // Predicted GPA for each observation

    // Predictors coefficients
    real theta_1 = normal_rng(75, 3);
    real theta_2 = normal_rng(1.5, 0.2);
    real theta_3 = normal_rng(-0.5, 0.3);
    real theta_4 = normal_rng(-0.75, 0.3);
    
    // Sigma for normal distribution
    real sigma = normal_rng(5, 0.5); 

    // Generate predicted GPA for each observation using a normal distribution with mean based on studying 
    // hours, hangouts and drinks
    for (i in 1:N) {
        predicted_gpa[i] = normal_rng(theta_1 + theta_2 * hours[i] + theta_3 * hangouts[i] + theta_4 * drinks[i], sigma);
    }
}
