function next = generate_intermediate_power_matrix(current, transition, In)
    %{
        This function calculates the matrix of power k based on the matrix
        of power k-1 based on a rule ( a transition array ).
    
                                       [2   0   0]
        [1   0   0]    3  2  1         [1   1   0]
        [0   1   0]   ------------>    [1   0   1]
        [0   0   1]    transition      [0   2   0]
           (k-1)                       [0   1   1]
                                       [0   0   2]
                                            (k)
    %}  
    no_elements = length(In);
    next = [];
    for i = 1 : length(transition)
        last_n_colums = no_elements - transition(i) + 1;
        next = [next; In(last_n_colums:no_elements,:) + ones(transition(i),1) * current(i,:)];
    end

end
