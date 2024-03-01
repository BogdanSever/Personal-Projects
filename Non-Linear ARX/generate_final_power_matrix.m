function power_matrix = generate_final_power_matrix(na, nb, m)
    %{
        This function calculates all the possible arrays of the type:
        [x_1 x_2 x_3 ... x_na ... x_(na+nb+1)] where x_n represents the
        power coefficient of the input / output in the term:
    
        1^x_1 * y(k-1)^x_2 * y(k-2)^x_3 * ... * y(k-na)^x_(na+1) * 
        u(k-1)^x_(na+2) * u(k-2)^x_(na+3) * ... * u(k-nb)^x_(na+nb+1)

        where all the powers have the sum equal to m which is the degree of
        the polynomial:

        x_1 + x_2 + ... + x_na + ... + x_(na+nb+1) = m;

        It's a recursive function that uses intermediary matrices. The
        matrix of degree m and number of inputs / outputs equal to na / nb
        is calculated based on the matrix of degree m-1.
    %}
    no_elements = na + nb + 1;
    In = eye(no_elements);
    
    transitions = no_elements;
    power_matrix = In;
    
    for M = 2:m
        transitions = generate_transition(transitions);
        power_matrix = generate_intermediate_power_matrix(power_matrix, transitions, In);
    end

end

