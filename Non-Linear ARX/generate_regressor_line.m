function regressor_line = generate_regressor_line(y, u, na, nb, power_matrix, k)
    %{
        This function calculates the line in the regressor matrix. It
        calculates every term of type:
    
        1^x_1 * y(k-1)^x_2 * y(k-2)^x_3 * ... * y(k-na)^x_(na+1) * 
        u(k-1)^x_(na+2) * u(k-2)^x_(na+3) * ... * u(k-nb)^x_(na+nb+1).

        Where the powers: x_1, x_2, ..., x_(na+nb+1) are taken from the
        power matrix.
    %}
    power_matrix = power_matrix(:,2:end);
    dim = size(power_matrix, 1);
    regressor_line = zeros(1, dim);
    function_input = zeros(1, na + nb );
    counter = 1;

    for i = 1:na
        if k - i > 0
            function_input(counter) = y(k - i);
        else
            function_input(counter) = 0;
        end
        counter = counter + 1;
    end
    
    for i = 1:nb
        if k - i > 0
            function_input(counter) = u(k - i);
        else
            function_input(counter) = 0;
        end
        counter = counter + 1;
    end

    for i = 1:dim
        term = prod(function_input .^ power_matrix(i, :));
        regressor_line(i) = term;
    end

end