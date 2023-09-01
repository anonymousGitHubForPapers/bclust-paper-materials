function objective = bclustEvalObjective(X, k, C, R)
[~, ~, ~, objective, ~, ~] = clusterize(X,k,R,C,C,Inf, [],[]);
end