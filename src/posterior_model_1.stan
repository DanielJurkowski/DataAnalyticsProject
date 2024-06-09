data {
    int<lower=0> N;
    array[N] real<lower=0, upper=4> hours;
    array[N] real<lower=0, upper=4> hangouts;
    array[N] real<lower=0, upper=100> gpa; // Observed GPA
}

parameters {
    real alpha;
    real beta;
    real sigma;
    real theta;

}

transformed parameters {
   array[N] real mu;
    for (i in 1:N) {
         mu[i] = theta + alpha * hours[i] + beta * hangouts[i];
    }
}

model {
    alpha ~ normal(1.5, 0.2);
    beta ~ normal(-1, 0.3);
    sigma ~ normal(5, 0.5);
    theta ~ normal(70, 3);

    // Likelihood
    for (i in 1:N) {
        gpa[i] ~ normal(mu[i], sigma);
    }

}

generated quantities {
    array[N] real<lower=0, upper=100> predicted_gpa;
    vector[N] log_likelihood; 
    for (i in 1:N) {
        log_likelihood[i] = normal_lpdf(gpa[i] | mu[i], sigma);
        predicted_gpa[i] = normal_rng(mu[i], sigma);
    }
}
