function [random_objective, random_ri, random_time, tclust_objective, tclust_ri, tclust_time, bclust_objective, bclust_ri, bclust_time, oracle_objective] = benchmark(X, label, R, bclustFreePoints)
%% add libraries to path
addpath(genpath("D:\YALMIP-develop"));
% put the path of the mosek matlab files inside genpath
addpath(genpath("C:\Program Files\Mosek\10.0\toolbox\r2017a"))
%% get size of the problem
k=size(unique(label),1);
[n,N] = size(X);
%% random assignments
tic;
random_ids = floor(rand(n,1)*k + 1);
random_time = toc;
random_ri = RandIndexFS(random_ids, label);
random_objective = bclustEvalObjective(X,k,random_ids,R);
%% tclust
tic;
restrfactor = struct();
restrfactor.pars = 'VVV';
restrfactor.shw = R^2;
tclust_ids = tclust(X,k,0,restrfactor,'equalweights','true','nsamp',300).idx;
tclust_time = toc;
tclust_ri=RandIndexFS(tclust_ids,label);
tclust_objective = bclustEvalObjective(X,k,tclust_ids,R);
%% bclust default init
bclust_time = 0;
bclust_ri = 0;
bclust_objective = 0;
tic;
starting_ids = tclust_ids;
bclust_ids = fullClusterize2(X,k,R,bclustFreePoints,[],tclust_ids,n/10);
bclust_time = toc;
bclust_ri = RandIndexFS(bclust_ids, label);
bclust_objective = bclustEvalObjective(X,k,bclust_ids,R);
%% oracle
oracle_objective = bclustEvalObjective(X,k,label,R);
end