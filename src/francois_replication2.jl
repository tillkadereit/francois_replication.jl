#Replication of Francois et al. "How is power shared in Africa", Till Kadereit, 26.04.2021

#= We want to create the "splitlikelihood" function that calculates the (negative) log likelihood of the dynamic
    coalition model. This function is needed for the main MLE file. 
    It returns either the total log likelihood or a vector of log likelihoods for each observation, as well
        as the predicted shares for each ethnicity in each time period.  =# 




function splitlikelihood(paramvec, popshare, govshare, P, regimes, includeobs, numeth, lambda, vectorize, estregimes, ae, final)

    delta = 0.95
    #use alpha and epsylon at estimates from pooled estimation as in the other file
    alpha = 11.5222
    epsilon = 0.115/(1-0.115) 
    #define estregimes as variable that can either take value 0 or 1 
    estregimes = [0 1]
    #create empty arrays for the variables for which values will be computed later
    Fprime = []
    gamma = [] 
    xi = []
    rprime = []

    if estregimes == 0 
        ae = [alpha epsilon]
        paramvec = [Fprime gamma xi rprime]
    else paramvec = [alpha epsilon]
    end 

    if estregimes == 0 
        F = (1-gamma)*Fprime/gamma


        if estregimes == 0    
            function splitgroup(popsh,rprime) 

                popsh = popshare[1:numeth]

                return splitter, corecoal, bigoutsiders 
            end 
        end


        
 constflag = 0; #initialization
 sharedata = zeros(size(popshare,1),6); # initialization
 leader = zeros(size(popshare,1),1); # initialization
 largest = zeros(size(popshare,1),1); # initialization
 members = zeros(size(popshare,1),4); # initialization
 
 

# proceed only if a standard optimal coalition can be found or estimating
# regime parameters only

if ((estregimes == 0 && splitter .!= 0) || estregimes .== 1)













    return 

end 


