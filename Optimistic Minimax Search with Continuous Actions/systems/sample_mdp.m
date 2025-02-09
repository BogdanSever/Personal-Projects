function [xplus, rplus, terminal, pplus] = sample_mdp(m, x, u, w)
%  Implements the discrete-time dynamics of the Markov decision process.
%  Deterministic problems should implement the calling mode:
%  [XPLUS, RPLUS, TERMINAL] = DOUBLEINT_MDP(M, X, U, [W])
%  Parameters:
%   M   - the model specification. Typically contains the fields (all structures)
%           phys - physical parameters
%           disc - discretization configuration
%           goal - goal configuration
%       but the actual structure may depend on the particular MDP.
%   X   - current state, x(k)
%   U 	- command u(k)
%   W   - exogenous noise/disturbance w(k), if model has exogenous noise
%       input.
%  Returns:
%   XPLUS       - state at next sample, x(k+1)
%   RPLUS       - ensuing reward, r(k+1)
%   TERMINAL    - whether the state is terminal (i.e., end of episode)
%               Should always be 0 for a continuing task
%
%  Certain algorithms such as OPMDP/OPSS also require that stochastic
%  problems should also implement the following mode:
%  [XPLUS, RPLUS, TERMINAL, PPLUS] = SAMPLE_MDP(M, X, U)
%  Parameters: same as before
%  Returns:
%   XPLUS       - set of all next states with nonzero probas, as a matrix,
%       one state per column
%   RPLUS       - row vector of corresponding rewards
%   TERMINAL    - row vector of corresponding terminal flags
%   PPLUS       - row vector of corresponding probabilities

% here we exemplify only the first mode
% compute here the next state and reward
xplus = m.A * x + m.B * u + m.E * w;
rplus = abs(x) <= m.goal.region;
terminal = 0;

% END sample_mdp() RETURNING xplus, rplus ===============================================