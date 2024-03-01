function MSE = calculate_mse(Y, Y_hat)
    %{
        This function calculates the MSE between 2 rows.
    %}
    error = Y - Y_hat;
    error = error .^ 2 / length(error);
    MSE = mean(error, 'all');

end