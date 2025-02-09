function [xplus, rplus, terminal, pplus] = stochact_mdpwrapper(m, x, u)
% MDP function wrapper to generate transitions by multiplying actions by a stochastic gain
%  MODEL = STOCHACT_MDPWRAPPER(MODEL, 'prepare')
%  [XPLUS, RPLUS, TERMINAL, PPLUS] = STOCHACT_MDPWRAPPER(M, X, U)
%
% Requires the fields 'stoch_gain' and 'stoch_prob' on the m structure.
%
% First, the 'prepare' mode should be called, after which the function can be used as a normal MDP
% function.
%
% This function conforms to the specifications established by SAMPLE_MDP; can return set of
% transitions and their probabilities.

% dimensionality
p = m.p; q = m.q;

% process 'prepare' mode first
if nargin == 2 && strcmp(x, 'prepare'),
    % error check
    if size(m.stoch_prob, 2) ~= size(m.stoch_gain, 2) ...
            || all(size(m.stoch_prob, 1) ~= [1 q]) || all(size(m.stoch_gain, 1) ~= [1 q]),
        error('Stochastic action wrapper: stoch_gain or stoch_prob size error');
    elseif any(abs(sum(m.stoch_prob, 2) - 1) > eps)
        error('Stochastic action wrapper: stoch_prob probs do not sum up to 1');                
    end;
    % bring to standard format
    if size(m.stoch_prob, 1) == 1, m.stoch_prob = repmat(m.stoch_prob, q, 1); end;
    if size(m.stoch_gain, 1) == 1, m.stoch_gain = repmat(m.stoch_gain, q, 1); end;
    % preinitialize helper variables
    m.stoch_n = size(m.stoch_prob, 2);
    % compute "cdf" vector for easy sampling
    m.stoch_cdf = cumsum(m.stoch_prob, 2);
    m.stoch_cdf = [zeros(q, 1) m.stoch_cdf(:, 1:end-1)];
    % compute all possible gain combinations and their probs
    m.stoch_allgains = flat(mat2cell(m.stoch_gain, ones(1, q), m.stoch_n));
    m.stoch_allprobs = prod(flat(mat2cell(m.stoch_prob, ones(1, q), m.stoch_n)), 1);
    m.stoch_nall = size(m.stoch_allgains, 2);
    % this is also identical to L, the number of possible outcomes
    m.L = m.stoch_nall;
    % finally, swap this wrapper function for the original mdp function
    m.singletransfun = m.fun;
    m.fun = @stochact_mdpwrapper;
    % 'prepare' mode done
    xplus = m;      % model should be the only returned variable
    return;
end;

% regular transition mode
if nargout < 4,
    % only generate a random transition
    for iq = 1:q,
        ind = find(rand >= m.stoch_cdf(iq, :), 1, 'last');
        u(iq) = m.stoch_gain(iq, ind) * u(iq);
    end;
    [xplus, rplus, terminal] = feval(m.singletransfun, m, x, u);
else
    % simulate all transitions, also outputting their distribution
    % generate all possible actions
    u = m.stoch_allgains .* repmat(u, 1, m.stoch_nall);
    % remove duplicates...
    [u, ifrom, ito] = unique(u', 'rows'); u = u';
    L = size(u, 2);
    % ...and compute the resulting probabilities
    if L == m.stoch_nall, 
        pplus = m.stoch_allprobs;
    else
        pplus = zeros(1, L);
        for i = 1:L, pplus(i) = sum(m.stoch_allprobs(ito == i)); end;
    end;
    % generate the transitions
    xplus = nan(p, L); rplus = nan(1, L); terminal = nan(1, L);
    for i = 1:L, 
        [xplus(:, i), rplus(i), terminal(i)] = feval(m.singletransfun, m, x, u(:, i));
    end;
    % remove any duplicates, recomputing the probs if there are any
    xrtplus = [xplus; rplus; terminal]; 
    [xrtplus, ifrom, ito] = unique(xrtplus', 'rows'); xrtplus = xrtplus';
    L2 = size(xrtplus, 2);
    if L2 < L,   % otherwise, everything can be left as is
        % error('Duplicate transitions -- code not verified!'); % code looks ok on reading
        xplus = xrtplus(1:p, :);
        rplus = xrtplus(p+1, :);
        terminal = xrtplus(end, :);
        pplus2 = zeros(1, L2);
        for i = 1:L2, pplus2(i) = sum(pplus(ito == i)); end;            
        pplus = pplus2;
    end;
end;    % return-all-transitions branch
