%% Data importing and preprocessing
clear all; clc;

load('iddata-07.mat');

u_id = id.u;
y_id = id.y;

u_val = val.u;
y_val = val.y;

%% Generating the regressors for the identification model 

na = 1;
nb = na;
M = 10;

power_matrix = generate_final_power_matrix(na, nb, M);
phi_id = generate_regressors(y_id, u_id, na, nb, power_matrix);

theta = phi_id \ y_id;

y_hat_id = simulate_system(u_id, theta, na, nb, power_matrix);
y_hat_val = simulate_system(u_val, theta, na, nb, power_matrix);
plot(y_val);
hold on;
plot(y_hat_val);

%% Testing and optimizing the values for the identification model

N = 5;
M = 3;

val_mse = zeros(N, M);

for n = 1:N
    
    na = n;
    nb = n;

    for m = 1:M
        
        no_elements = na + nb + 1;
        In = eye(no_elements);
        
        if m == 1
            transitions = no_elements;
            power_matrix = In;
        else
            transitions = generate_transition(transitions);
            power_matrix = generate_intermediate_power_matrix(power_matrix, transitions, In);
        end

        phi_id = generate_regressors(y_id, u_id, na, nb, power_matrix);
        theta = phi_id \ y_id;

        y_hat_val = simulate_system(u_val, theta, na, nb, power_matrix);
        val_mse(n, m) = calculate_mse(y_val, y_hat_val);
        %disp(calculate_mse(y_val, y_hat_val));
    end
end

[X, Y] = meshgrid(1:N, 1:M);
figure;
plot3(X, Y, val_mse);




