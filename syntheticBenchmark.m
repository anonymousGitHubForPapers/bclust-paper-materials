function [random_objective, random_ri, random_time, tclust_objective, tclust_ri, tclust_time, bclust_objective, bclust_ri, bclust_time, oracle_objective] = syntheticBenchmark(n,k,N,R,barOmega)
    sph = struct();
    sph.shw=R^2;
    sph.pars = 'VVV';
    out = MixSim(k,N,'sph',sph,'BarOmega',barOmega);
    [data,label]=simdataset(n, out.Pi, out.Mu, out.S);
    [random_objective, random_ri, random_time, tclust_objective, tclust_ri, tclust_time, bclust_objective, bclust_ri, bclust_time, oracle_objective] = benchmark(data, label, R, 1);
end