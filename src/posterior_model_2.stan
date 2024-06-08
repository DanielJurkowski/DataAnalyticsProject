data {
    int<lower=0> N; // Number of observations
    array[N] real<lower=0, upper=100> gpa;
    array[N] real<lower=0, upper=4> hours;
    array[N] real<lower=0, upper=4> hangouts;
    array[N] real<lower=0, upper=4> drinks;
}

parameters {
    real alpha;
    real beta;
    real sigma;
    real off;

}

transformed parameters {
   array[N] real mu;
    for (i in 1:N) {
         mu[i] = off + alpha * hours[i] + beta * hangouts[i] * drinks;
    }
}

model {
    alpha ~ normal(0.75, 0.1);
    beta ~ normal(-0.25, 0.05);
    sigma ~ normal(5, 0.5);
    off ~ normal(70, 3);

    for (i in 1:N) {
        gpa[i] ~ normal(mu[i], sigma);
    }

}

generated quantities {
    array[N] real<lower=0, upper=100> predicted_gpa; // Predicted GPA for each observation

    for (i in 1:N) {
        predicted_gpa[i] = normal_rng(mu[i], sigma);
    }
}
