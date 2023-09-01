function [C, mu, A, objvalout, M, gamma] = clusterize(X,k,R,cl,oldC, bestUpper, Bgamma, BM)
% we clear the yalmip context otherwise temporary variables would
% accumulate slowing everything down
yalmip('clear');
[n,N] =size(X); % n is the number of points, N their dimensionality

% we construct the optimization problem seen in the notes
[y, gammabar, gamma, c, Mbar, M, Objective, Constraints] = clusterizeConstructProblem(X,k,R, cl,oldC, bestUpper, Bgamma, BM);
% we use the yalmip branch and bound solver (which will use MOSEK as the
% internal solver for the semi-definite subproblems). We tell it to use the
% starting assignments which we set in clusterizeConstructProblem (the
% previous solution) by setting 'usex0' to 1. We tell it not to print the
% progress (verbose 0).
options = sdpsettings('solver','bnb','usex0',0,'verbose',1);

% we ask yalmip to optimize the objective given the constraints
sol = optimize(Constraints, Objective, options);
c = value(c);
% even though c is a binary variable due to approximations it could be not
% exactly integer. We thus take the biggest value and put it to 1 and set
% the others to 0
for i=1:n
   c(i,find(c(i,:)==max(c(i,:)))) = 1;
   c(i,find(c(i,:) < 1)) = 0;
end
% we then use the values of c to create the vector of cluster assignments
C = round(value(c)*(1:k)');

% here we compute the values of A and mu. A is equal to M^2. mu is equal to
% M^-1 gamma
A = cell(k,1);
mu = cell(k,1);
for i=1:k
    A{i} = value(M{i})^2;
    mu{i} = value(M{i})^(-1) * value(gamma{i});
    M{i} = value(M{i});
    gamma{i} = value(gamma{i});
end

% we alse return the value of the objective
objvalout = value(Objective);
end
