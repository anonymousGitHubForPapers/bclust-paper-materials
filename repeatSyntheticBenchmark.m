function OUT = repeatSyntheticBenchmark(ns,ks,Ns,Rs,barOmegas,repeats)
OUT = ["n","k","N","R","barOmega","it","random_objective", "random_ri", "random_time", "tclust_objective", "tclust_ri", "tclust_time", "bclust_objective", "bclust_ri", "bclust_time", "oracle_objective"];

for n=ns
    for k = ks
        for N=Ns
            for R=Rs
                for barOmega=barOmegas
                    for it=repeats
                        rng(it);    
                        ["n","k","N","R","barOmega","it";n,k,N,R,barOmega,it];
                        [random_objective, random_ri, random_time, tclust_objective, tclust_ri, tclust_time, bclust_objective, bclust_ri, bclust_time, oracle_objective] = syntheticBenchmark(n,k,N,R,barOmega);
                        OUT = [OUT;[n,k,N,R,barOmega,it,random_objective, random_ri, random_time, tclust_objective, tclust_ri, tclust_time, bclust_objective, bclust_ri, bclust_time, oracle_objective]];
                    end
                end
            end
        end
    end
end
end