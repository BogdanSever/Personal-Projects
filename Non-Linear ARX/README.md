# Non-linear ARX
  This project was part of my System Identification class. In order to find the mathematical model of an unknown system we neeeded to try different values of polynomials
  of type: P(n,m) = [y(k-1) + y(k-2) + ... y(k-n) + u(k-1) + u(k-2) + ... + u(k-n)]^m, where y - the output of the system, u - the input of the system, m - degree of polynomial, n - last 'n' inputs and outputs.

  To find the right pair of (n,m) we need to calculate all the powers of every term of the polynomial P(n,m) and evaluate the terms. 

  1 ^ a_0 + y(k-1) ^ a_1 + y(k-2) ^ a_2 + ... + y(k-n) ^ a_n + u(k-1) ^ a_n+1 + ... + u(k-n) ^ a_2*n.

  The algorithm efficiency comes from finding the powers of the expansion of P(n,m) based on the powers of the expansion P(n,m-1).
  
