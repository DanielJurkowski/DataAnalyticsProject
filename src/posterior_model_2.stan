data {
    int<lower=0> N;
    array[N] real<lower=0, upper=4> hours;
    array[N] real<lower=0, upper=4> hangouts;
    array[N] real<lower=0, upper=4> drinks;
    array[N] real<lower=0, upper=1> scaled_gpa;
}

parameters {
    real theta_1;
    real theta_2; 
    real theta_3;
    real theta_4;
    real theta_5;
}

transformed parameters {
    array[N] real<lower=0> alpha_param;
    array[N] real<lower=0> beta_param;
    // zategowac trzeba
    for (i in 1:N) {
         alpha_param[i] = theta_1 + theta_2 * hours[i];
         beta_param[i] = theta_3 + theta_4 * hangouts[i] + theta_5 * drinks[i];
    }
}

model {
    theta_1 ~ lognormal(3.63, 0.02);
    theta_2 ~ lognormal(0.4, 0.1);
        theta_3 ~ lognormal(2.3, 0.1);
    theta_4 ~ lognormal(0.01, 0.1);
    theta_5 ~ lognormal(0.01, 0.1);

    for (i in 1:N) {
        scaled_gpa[i] ~ beta(alpha_param[i], beta_param[i]);
    }
}

generated quantities {
    array[N] real predicted_scaled_gpa;
    vector[N] log_likelihood; 

    for (i in 1:N) {
        log_likelihood[i] = beta_lpdf(scaled_gpa[i] | alpha_param[i], beta_param[i]); 
        predicted_scaled_gpa[i] = beta_rng(alpha_param[i], beta_param[i]);
    }
}
