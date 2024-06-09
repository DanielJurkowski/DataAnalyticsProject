data {
    int<lower=0> N;
    array[N] real<lower=0, upper=4> hours;
    array[N] real<lower=0, upper=4> hangouts;
    array[N] real<lower=0, upper=4> drinks;
    array[N] real<lower=0, upper=100> gpa;
}

parameters {
    real<lower=0> alpha;
    real<lower=0> beta; 
    real a;
    real b;
}

transformed parameters {
    array[N] real scaled_gpa;
    for (i in 1:N) {
         scaled_gpa[i] = gpa[i] / 100;
    }
}

model {
    alpha ~ normal(25, 0.1);
    beta ~ normal(8, 0.1);
    a ~ normal(0.75, 0.1);
    b ~ normal(-0.25, 0.05);

    for (i in 1:N) {
        scaled_gpa[i] ~ beta(alpha, beta);
    }
}

generated quantities {
    array[N] real predicted_gpa;
    vector[N] log_likelihood; 
    for (i in 1:N) {
        log_likelihood[i] = 100 * beta_lpdf(scaled_gpa[i] | alpha, beta) + a * hours[i] + b * hangouts[i] * drinks[i]; 
        predicted_gpa[i] = 100 * beta_rng(alpha, beta) + a * hours[i] + b * hangouts[i] * drinks[i];
    }
}
