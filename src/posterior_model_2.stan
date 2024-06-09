// data {
//     int<lower=0> N; // Number of observations
//     array[N] real<lower=0, upper=100> gpa;
//     array[N] real<lower=0, upper=8> hours;
//     array[N] real<lower=0, upper=4> hangouts;
//     array[N] real<lower=0, upper=4> drinks;
// }

// parameters {
//     real alpha;
//     real beta;
//     real sigma;
//     real off;

// }

// transformed parameters {
//    array[N] real mu;
//     for (i in 1:N) {
//          mu[i] = off + alpha * hours[i] + beta * hangouts[i] * drinks[i];
//     }
// }

// model {
//     alpha ~ normal(0.75, 0.1);
//     beta ~ normal(-0.25, 0.05);
//     sigma ~ normal(5, 0.5);
//     off ~ normal(70, 3);

//     for (i in 1:N) {
//         gpa[i] ~ normal(mu[i], sigma);
//     }

// }

// generated quantities {
//     array[N] real<lower=0, upper=100> predicted_gpa; // Predicted GPA for each observation

//     for (i in 1:N) {
//         predicted_gpa[i] = normal_rng(mu[i], sigma);
//     }
// }

data {
    int<lower=0> N; // liczba obserwacji
    array[N] real<lower=0, upper=8> hours;
    array[N] real<lower=0, upper=4> hangouts;
    array[N] real<lower=0, upper=4> drinks;
    array[N] real<lower=0, upper=100> gpa; // obserwowane wartości GPA
}

parameters {
    real<lower=0> a; // Parametry dla rozkładu beta, muszą być dodatnie
    real<lower=0> b; 
    real alpha; // Współczynniki regresji
    real beta;
    real<lower=0> scale; // Parametr skali, musi być dodatni 
}

transformed parameters {
    array[N] real scaled_gpa;
    for (i in 1:N) {
         scaled_gpa[i] = gpa[i] / 100;
    }
}

model {
    // Priorytety dla parametrów
    a ~ normal(25, 0.1); // Średnia około 25
    b ~ normal(8, 0.1);  // Średnia około 8
    alpha ~ normal(0.75, 0.1);
    beta ~ normal(-0.25, 0.05);
    scale ~ normal(1, 0.1); // Skala dla beta, typowo w okolicy 1

    // Likelihood
    for (i in 1:N) {
        scaled_gpa[i] ~ beta(a, b);
    }
}

generated quantities {
    array[N] real predicted_gpa; // przewidywane GPA dla każdej obserwacji
    array[N] real log_likelyhood; 
    // Generowanie przewidywanego GPA dla każdej obserwacji
    for (i in 1:N) {
        log_likelyhood[i] = 100 * beta_lpdf(scaled_gpa[i] | a, b) + alpha * hours[i] + beta * hangouts[i] * drinks[i]; 
        predicted_gpa[i] = 100 * beta_rng(a, b) + alpha * hours[i] + beta * hangouts[i] * drinks[i];
    }
}

