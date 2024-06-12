data {
    int<lower=0> N;
    array[N] real<lower=0, upper=4> hours;
    array[N] real<lower=0, upper=4> hangouts;
    array[N] real<lower=0, upper=4> drinks;
    array[N] real<lower=0, upper=100> gpa; // Observed GPA
}

parameters {
    real theta_1;
    real theta_2;
    real theta_3;
    real theta_4;
    real<lower=0> sigma;

}

transformed parameters {
   array[N] real mu;
    for (i in 1:N) {
         mu[i] = theta_1 + theta_2 * hours[i] + theta_3 * hangouts[i] + theta_4 * drinks[i];
    }
}

model {
    theta_1 ~ normal(70, 3);
    theta_2 ~ normal(1.5, 0.2);
    theta_3 ~ normal(-0.5, 0.3);
    theta_4 ~ normal(-0.75, 0.3);
    sigma ~ normal(5, 0.5);

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
        predicted_gpa[i] = fmin(normal_rng(mu[i], sigma), 100);
    }
}
