function [y, gammabar, gamma, c, Mbar, M, Objective, Constraints] = clusterizeConstructProblem(X,k,R, cl, oldC, bestUpper, BGamma, BM)
[n,N] =size(X); % n is the number of points, N is their dimensionality
% we can use Il(i) to check if the point is free or not: if it is free then
% we have Il(i) > 0
Il = (cl==-1); 
%% initialize variables
% Init M
M = cell(1,k);
for j=1:k
    M{j} = sdpvar(N,N);
end

% Init \bar{M}
Mbar = cell(1,n);
for i=1:n
    if(Il(i)>0)
        Mbar{i} = sdpvar(N,N);
    end
end

% Init \gamma
gamma = cell(1,k);
for j=1:k
    gamma{j} = sdpvar(N,1);
end

% Init \bar{\gamma}
gammabar = cell(1,n);
for i=1:n
    if(Il(i)>0)
        gammabar{i} = sdpvar(N,1);
    end
end

% Init y
y = cell(1,n);
for i=1:n
    y{i} = sdpvar(N,1);
end

% Init c
c = [];
for i=1:n
    if(Il(i)>0)
        cc = binvar(1,k,'full');
        c = [c; cc];
        assign(cc,oldC(i)==(1:k));
    else
        c = [c; (1:k)==cl(i)];
    end
end

%% Init objective function
Objective = 0;
for i=1:n
    if(Il(i)>0)
        Objective = Objective + norm(y{i} - gammabar{i},2)/2 - N*log(geomean(Mbar{i})) + log(2*pi);
    else
        Objective = Objective + norm(y{i} - gamma{cl(i)},2)/2 - N*log(geomean(M{cl(i)})) + log(2*pi);
    end
end

for j=1:k
    %Objective = Objective -sum(c(:,j))*log(sum(c(:,j))/n);
end

%% Init constraints
Constraints = [];

% init constraint 1)
for j=1:k
    if(sum(cl==j) <=1)
        Constraints = [Constraints, sum(c(:,j)) >= 2];
    end
end

% init constraint 2)
for i=1:n
    if(Il(i)>0)
        Constraints = [Constraints, sum(c(i,:)) == 1];
    end
end

% init constraint 3)
for i=1:n
    if(Il(i)>0)
        for j=1:k
            Constraints = [Constraints, gammabar{i} - gamma{j} <= (1-c(i,j)) * BGamma];
        end
    end
end

% init constraint 4)
for i=1:n
    if(Il(i)>0)
        for j=1:k
            Constraints = [Constraints, gammabar{i} - gamma{j} >= -(1-c(i,j)) * BGamma];
        end
    end
end

% init constraint 5)
% constraint 5 is already enforced because we have declared M{j}, Mbar{i}
% as sdpvars

% init constraint 6)
% here we have to enforce the constraint for every column of the matrices
% because if we were to use <= with sdpvar matrices it would be interpreted
% as a semidefinite constraint rather than elementwise inequality
for i=1:n
    if(Il(i)>0)
        for j=1:k
            for a=1:N
                Constraints = [Constraints, Mbar{i}(a,:) - M{j}(a,:) <= (1-c(i,j)) *BM(a,:)];
            end
        end
    end
end


% init constraint 7)
% here we have to enforce the constraint for every column of the matrices
% because if we were to use >= with sdpvar matrices it would be interpreted
% as a semidefinite constraint rather than elementwise inequality
for i=1:n
    if(Il(i)>0)
        for j=1:k
            for a=1:N
                Constraints = [Constraints, Mbar{i}(a,:) - M{j}(a,:) >= -(1-c(i,j)) * BM(a,:)];
            end
        end
    end
end

% init constraint 8)
% not here anymore: we have moved the determinant in the objective

% init constraint 9)
for j=1:k
    Constraints = [Constraints, lambda_max(M{j}) <= R * lambda_min(M{j})];
end


% init constraint 10)


for i=1:n
    if(Il(i)>0)
        Constraints = [Constraints, y{i} == Mbar{i} * X(i,:)'];
    else
        Constraints = [Constraints, y{i}==M{cl(i)}*X(i,:)'];
    end
end

if(bestUpper < Inf)
    %Constraints = [Constraints, Objective <= bestUpper];
end
end
