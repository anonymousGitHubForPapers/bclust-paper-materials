# bclust-paper-material
Code and datasets for the paper "A Mixed Integer Semidefinite Programming Approach for Cluster Analysis in Gaussian Mixture Models"

Tested with MATLAB Version: 9.12.0.2039608 (R2022a) Update 5

with the following Toolboxes:

MATLAB                                                Version 9.12        (R2022a)
Global Optimization Toolbox                           Version 4.7         (R2022a)
Optimization Toolbox                                  Version 9.3         (R2022a)
Statistics and Machine Learning Toolbox               Version 12.3        (R2022a)

and FSDA version 8.5.32

To use the user needs to install the YALMIP library and the MOSEK solver. Edit the file "benchmark.m" to set the paths of the 
YALMIP library and the MOSEK solver to the ones of the specific installations.
The script to execute to repeat the synthetic benchmarks is "syntheticBenchmarks.m".
The scripts to execute to repeat the real-world applications are "benchmarkWine.m", "benchmarkSeeds.m", "benchmarkAlgerianForestFiresBejaia.m", "benchmarkAlgerianForestFiresSidiBelAbbes.m", "benchmarkIris.m", "benchmarkStars.m".