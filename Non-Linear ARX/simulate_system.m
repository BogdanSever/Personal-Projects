function y = simulate_system(u, theta, na, nb, power_matrix)
    %{
        This function simulates the system based on the theta that we 
        calculated on the identification data set.
    %}
    N = length(u);
    y = zeros(N, 1);
    for i = 1:N
        y(i) = generate_regressor_line(y, u, na, nb, power_matrix, i) * theta;
    end

end