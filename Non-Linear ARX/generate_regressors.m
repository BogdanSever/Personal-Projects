function regressor_matrix = generate_regressors(y, u, na, nb, power_matrix)
    %{
        This function generates the regressor matrix.
    %}
    N = length(y);
    dim = size(power_matrix, 1);
    regressor_matrix = zeros(N, dim);
    for i = 1:N
        regressor_matrix(i, :) = generate_regressor_line(y, u, na, nb, power_matrix, i);
    end

end