# My Replication of the paper "How is power shared in Africa?" by Francois, Rainer and Trebbi (2015)

> This replication study was part of my evaluation for the course [Numerical Methods](https://floswald.github.io/NumericalMethods/) at SciencesPo Paris in Spring 2021

The following is the documentation for the replication of the paper "How is power shared in Africa?" by Francois et al. (2015). I will replicate the author's Matlab code for the paper using Julia. 
In their paper, Francois et al. aim to answer the question whether African politics is concentrated in the hand of a small ruling elite. 
Using a rich set of data on the ethnic composition of African ministerial cabinets, Francois et al. provide evidence for inclusive coalitions and a high degree of bargaining within the regimes, which rejects the widespread view that African autocracies are run by a narrow elite. 

The authors thereby rely on a maximum likelihood estimation of their ethnic power sharing model, to estimate the liklihood of an observed cabinet allocation. The central results in table 4 present the maximum liklihood estimates of the model parameters alpha, epsylon, gamma, F, r and xi. 
To replicate these results, the "estimation" and "pooledestimation" files are of particular importance and serve to estimate the MLE parameters of the dynamic power sharing model. 
"estimation" estimates the parameters per single country (whose standard parameters are set at the beginning of the file). "Pooledestimation" pools all countries together and estimates alpha and epsilon across countries, whereas F, gamma, xi and r are estimated individually for each country. 

In order to estimate the vector of paramters of interest, two main functions have to be created separetely: The "splitlikelihood" function (for the MLE estimation for single countries) and the "pooledlikelihood" function (for the pooled estimation with all countries). 


```@autodocs
Modules = [francois_replication]
```


end
