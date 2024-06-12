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
    real a;
    real b;
}

transformed parameters {
    array[N] real<lower=0> alpha;
    array[N] real<lower=0> beta;
    // zategowac trzeba
    for (i in 1:N) {
         alpha[i] = fmax(theta_1 + a * hours[i], 0);
         beta[i] = fmax(theta_2 + b * hangouts[i] * drinks[i], 0);
    }
}

model {
    theta_1 ~ normal(38, 2);
    theta_2 ~ normal(10, 1);
    a ~ normal(1.5, 0.3);
    b ~ normal(0.75, 0.05);

    for (i in 1:N) {
        scaled_gpa[i] ~ beta(alpha[i], beta[i]);
    }
}

generated quantities {
    array[N] real predicted_scaled_gpa;
    vector[N] log_likelihood; 

    for (i in 1:N) {
        log_likelihood[i] = beta_lpdf(scaled_gpa[i] | alpha[i], beta[i]); 
        predicted_scaled_gpa[i] = beta_rng(alpha[i], beta[i]);
    }
}
