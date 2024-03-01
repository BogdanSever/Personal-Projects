function next = generate_transition(current)
    %{
        This function generates an array of numbers which we use to 
        generate the power matrix of degree k from the power matrix of 
        degree k-1. The array has the same amount of numbers as rows in the
        matrix of degree k-1 and it show oh many rows we will have in the
        matrix of degree k.

                                       [2   0   0]
        [1   0   0]    3  2  1         [1   1   0]
        [0   1   0]   ------------>    [1   0   1]
        [0   0   1]    transition      [0   2   0]
           (k-1)                       [0   1   1]
                                       [0   0   2]
                                            (k)
    
        Here the transition is 3 2 1 and it represents the amount of rows
        we will get from from each row in the matrix of degree k-1. 
        E.g: From the first row we will get 3 rows, from the second row we
        will get 2 rows and from the last row we will get 1 row.
    %}
    next = [];
    for i = 1 : length(current)
        next = [next current(i):-1:1];
    end

end