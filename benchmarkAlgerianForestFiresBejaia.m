%% load seeds data
clear;
raw = readmatrix("raw_algerian_bejaia.txt"); % last column is label, the others are the data (https://archive.ics.uci.edu/dataset/547/algerian+forest+fires+dataset)
label = raw(:,end);
data = raw(:,4:(end-1));
k=size(unique(label),1);
[n,N] = size(data);
%% preprocess columns (normalization)
for i = 1:N
    data(:,i) = (data(:,i)-mean(data(:,i)))/std(data(:,i) + 0.001);
end
%% init rng
rng(42);
%% do benchmark
[random_objective, random_ri, random_time, tclust_objective, tclust_ri, tclust_time, bclust_objective, bclust_ri, bclust_time, oracle_objective] = benchmark(data, label, sqrt(10), 1)