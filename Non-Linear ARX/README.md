# System Identification Project

This project was undertaken as part of my **System Identification** class, where the goal was to derive a mathematical model for an unknown system. We approached this problem by considering polynomial models of the form

$$
P(n,m) = \left[ y(k-1) + y(k-2) + \cdots + y(k-n) + u(k-1) + u(k-2) + \cdots + u(k-n) \right]^m,
$$

where:

- \( y \) is the system output,
- \( u \) is the system input,
- \( m \) is the polynomial degree, and
- \( n \) is the number of past inputs and outputs included in the model.

To determine the optimal pair \((n,m)\), we needed to compute all the powers of every term in the polynomial expansion. This led to expressions such as

$$
1^{a_0} \cdot y(k-1)^{a_1} \cdot y(k-2)^{a_2} \cdots y(k-n)^{a_n} \cdot u(k-1)^{a_{n+1}} \cdot \cdots \cdot u(k-n)^{a_{2n}}
$$

where the exponents \( a_i \) indicate the power applied to each term. The efficiency of our algorithm comes from the fact that the expansion for \( P(n,m) \) is computed using the powers already derived from the expansion of \( P(n,m-1) \).

This approach is analogous to the principles of **linear regression**. In linear regression, we model the relationship between an output and its predictors by fitting a linear equation (for example, \( y = \beta_0 + \beta_1 x \)). By incorporating polynomial terms as features, linear regression can capture nonlinear relationships effectively. In our project, the polynomial expansion serves as a feature transformation that allows us to model the system dynamics, leveraging the recursive computation of polynomial powers to enhance efficiency.
