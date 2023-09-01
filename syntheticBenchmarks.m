%% global stuff
ns = 200;
nrepeats = 100;
TOTAL_OUT = [];
%% first run: change k (total problems:5)
ks = 2:6;
Ns = 8;
Rs = sqrt(10);
barOmegas = 0.01;
repeats = 1:nrepeats;
OUT = repeatSyntheticBenchmark(ns,ks,Ns,Rs,barOmegas,repeats);
writematrix(OUT, 'change_k_out.txt');
TOTAL_OUT = [TOTAL_OUT; OUT];
%% second run: change Ns (total problems:5)
ks = 4;
Ns = 2:2:10;
Rs = sqrt(10);
barOmegas = 0.01;
repeats = 1:nrepeats;
OUT = repeatSyntheticBenchmark(ns,ks,Ns,Rs,barOmegas,repeats);
writematrix(OUT, 'change_N_out.txt');
TOTAL_OUT = [TOTAL_OUT; OUT];
%% third run: change R (total problems: 5)
ks = 4;
Ns = 8;
Rs = [1, sqrt(4), sqrt(6), sqrt(10), sqrt(30)];
barOmegas = 0.01;
repeats = 1:nrepeats;
OUT = repeatSyntheticBenchmark(ns,ks,Ns,Rs,barOmegas,repeats);
writematrix(OUT, 'change_R_out.txt');
TOTAL_OUT = [TOTAL_OUT; OUT];
%% fourth run: change barOmegas (total problems: 5)
ks = 4;
Ns = 8;
Rs = sqrt(10);
barOmegas = [0.001, 0.005, 0.01, 0.05, 0.1];
repeats = 1:nrepeats;
OUT = repeatSyntheticBenchmark(200,ks,Ns,Rs,barOmegas,repeats);
writematrix(OUT, 'change_barOmega_out.txt');
TOTAL_OUT = [TOTAL_OUT; OUT];
%% save TOTAL_OUT (total problems: 19)
writematrix(TOTAL_OUT, 'total_out.txt');