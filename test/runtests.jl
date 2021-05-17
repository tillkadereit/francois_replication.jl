using Test, francois_replication

"""
   Test the splitlikelihood function that is replicated in Julia based on Francois et al.'s Matlab code. 
    The function shall return either the total log likelihood or a vector of log likelihoods for each observation, as well as 
        the predicted shares for each ethnicity in each time period. 

    splitlikelihood(paramvec, popshare, govshare, P, regimes, includeobs, numeth, lambda, vectorize, estregimes, ae, final)
"""




@test splitlikelihood(paramvec,popshare,govshare,P,regimes,includeobs,numeth,lambda,vectorize,estregimes,ae,final) == [ll,constflag,sharedata,members]


