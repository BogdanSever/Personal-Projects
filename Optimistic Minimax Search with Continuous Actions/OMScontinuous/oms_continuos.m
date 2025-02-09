close all; clear all; clc; tic

% Define and set up the model:
[cfg, parameters] = define_model();
model = setup_model(cfg);

% Trajectory initialization:
moves = 80;
current_state = [-pi; 0];
current_reward = 0;
max_disturbance = model.maxw;

% Final trajectory and rewards:
Xstar = zeros(2, moves);
Rstar = zeros(1, moves);
Zstar = zeros(1, moves);
Zstar_disturbance = zeros(1, moves);

for move = 1:moves

    Xstar(:, move) = current_state;
    Rstar(move) = current_reward;

    % Tree initialization:
    [parent, children, leaf, dim, upperbound, lowerbound, Ki, depth, minimax, z, x, r] = initialize_tree_minimax(parameters);

    % Root initialization:
    x(1, 1, :) = current_state;
    leaf(1) = true;
    depth(1) = 0;
    
    % Tree expansion:
    best_move = minimax_algorithm(parent, children, leaf, dim, upperbound, lowerbound, Ki, depth, minimax, z, x, r, parameters, model);
    
    Zstar(move) = best_move;
    
    % Updating the state:
    current_action = inverse_norm_u(best_move, model);
    disturbance = -max_disturbance + 2 * max_disturbance * rand();
    % disturbance = 0;
    [current_state, current_reward, ~] = feval(model.fun, model, current_state, current_action + disturbance);
    
    Zstar_disturbance(move) = current_action + disturbance;
end

figure
plot_results(Xstar, inverse_norm_u(Zstar, model), Rstar, moves);

time = ( 1 : moves ) .* 0.05;
figure
stairs(time, inverse_norm_u(Zstar, model), 'b', 'LineWidth', 1.5); % Plot Zstar in blue
hold on; % Hold the current plot to overlay the next plot
stairs(time, Zstar_disturbance, 'r', 'LineWidth', 1.5); % Plot Zstar_disturbance in red
hold off; % Release the hold
grid on; % Add a grid for better visualization
xlabel('Time'); % Label for x-axis
ylabel('Z Values'); % Label for y-axis
title('Zstar and Zstar\_disturbance'); % Title of the plot
legend('Zstar', 'Zstar\_disturbance'); % Add legend

toc