function [C, mu, A, ObjectiveValues] = fullClusterize2(X,k,R,freePoints,colors,C,D)
[n,N] = size(X); % n is the number of points, N is their dimensionality

% we initialize mu and A to zero just to give them a value
mu = 0;
A = 0;

% this is the vector of fixed points. Points for which the value is -1 are
% free points. In the first iteration we just want to compute the M and
% gamma and the value of the objective function so we fix all points to the
% starting assignment
cl = C;

% the initialization of the best objective. We put it to +infinity so that
% we are sure that the first objective we get will be better than that (we
% are minimizing).
bestObj = +Inf;

% this is the array of objective values obtained in each iteration in
% order. It starts empty and grows with each iteration.
ObjectiveValues = [];

% we compute the new values of C, mu, A and the objective by solving
% the optimization problem
[C, mu, A, bestObj, M, gamma] = clusterize(X,k,R,cl,C,bestObj, [],[]);

% we use 500000 as just a big number that is not infinity. In practice this
% number will never be reached and we will converge much, much faster.
for it=1:500000
    improved = 0;
    % we save the old assignment in this variable
    oldC = C;

    % add the objective to the list of objectives in each iteration
    ObjectiveValues = [ObjectiveValues, bestObj];

    % if colors is set plot the clusters and show the points that changed
    % assignments by circling them
    if(size(colors,1))
        plotClusters(X,k,C,A,mu,colors);
        III = find(1- (oldC == C));
        plot(X(III,1),X(III,2),'o');
    end

    % find which x are uncertain:
    % for each x compute the ratio of the distance from its cluster and the
    % distance from the nearest cluster. Then sort them by descending order
    % of this ratio. The first ones are the less certain.
    point_loglikelihoods = zeros(n,k);
    
    innerWhileExit = 0;
    while(innerWhileExit==0)
        oldC = C;
        for i=1:n
            for j=1:k
                point_loglikelihoods(i,j) = - 1/2*(X(i,:)' - mu{j})' * A{j} * (X(i,:)' - mu{j}) + log(det(A{j})^(1/2));
            end
        end
        [~, BLLI] = max(point_loglikelihoods,[],2);
        % reassign points
        [newC, newmu, newA, objval, newM, newGamma] = clusterize(X,k,R,BLLI,C,bestObj, [], []);
        if(objval < bestObj && norm(newC-oldC) > 0)
            A = newA;
            mu = newmu;
            C = newC;
            bestObj = objval;
            M = newM;
            gamma = newGamma;
        else
            innerWhileExit=1;
        end
    end

    for i=1:n
        for j=1:k
            point_loglikelihoods(i,j) = - 1/2*(X(i,:)' - mu{j})' * A{j} * (X(i,:)' - mu{j}) + log(det(A{j})^(1/2));
        end
    end
   
    
    original_loglikelihoods = zeros(n,1);
    for i=1:n
        original_loglikelihoods(i,1) = point_loglikelihoods(i,C(i));
        point_loglikelihoods(i,C(i)) = -Inf;
    end
    BLL = max(point_loglikelihoods,[],2);
    BLLDiffs = -BLL + original_loglikelihoods;
    
    [~, SortedDiffsIndexes] = sort(BLLDiffs);

    for f=1:(D/freePoints)
        cl = C;
        ff = (f-1)*freePoints+1;
        ff2 = min(n,f*freePoints);
        cl(SortedDiffsIndexes(ff:ff2)) = -1;
        
        % we compute the new values of C, mu, A and the objective by solving
        % the optimization problem
        BM = zeros(N,N);
        Bgamma = zeros(N,1);
        for j1=1:k
            for j2=(j1+1):k
                BM = max(BM, abs(M{j1}-M{j2}));
                Bgamma = max(Bgamma, abs(gamma{j1}-gamma{j2}));
            end
        end
        BM = BM*2;
        Bgamma = Bgamma*2;
        [newC, newmu, newA, objval, newM, newGamma] = clusterize(X,k,R,cl,C,bestObj, Bgamma, BM);
        if(objval < bestObj && norm(newC - C) > 0)
            C = newC;
            mu = newmu;
            A = newA;
            M = newM;
            gamma = newGamma;
            bestObj = objval;
            improved = 1;
            break
        end
    end

    if(not(improved))
        break;
    end

end
end