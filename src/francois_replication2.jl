#Replication of Francois et al. "How is power shared in Africa", Till Kadereit, 26.04.2021


"""
    splitlikelihood(paramvec, popshare, govshare, P, regimes, includeobs, numeth, lambda, vectorize, estregimes, ae, final) 

    We want to create the "splitlikelihood" function that calculates the (negative) log likelihood of the dynamic
    coalition model. This function is needed for the main MLE file. 
    It returns either the total log likelihood or a vector of log likelihoods for each observation, as well
    as the predicted shares for each ethnicity in each time period. 
"""
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

                popsh = popshare[i for i in 1:numeth] 

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
   
    elite = [lambda*P.*popshare[i] for i in 1:numeth]
    # get the elite sizes [a vector of the sizes of each ethnicity's elite]
    elite = lambda*P.*popsh

    #calculate vector of exponential terms for probability of leadership
    expelite = exp(alpha.*elite) 

    #calculate probability each group becomes leader
    pr = expelite./(ones(1,numeth)*expelite)

    #vector of predicted shares for each ethnicity in each time period
    predshare = zeros(size(popshare,1),1) 

    #vector of groups to exclude (i.e. the leader in each time period)
    exclude = zeros(size(popshare,1),1) 

    #contribution to the log likelihood from the regime transition itself
    llregime = zeros(size(regimes,1),1) 
    startregime = 1

#Now: want to loop over each regime to calculate 2 things:
#1. the contribution to the likelihood for the regime 
#2. the predicted shares for the regime

for i in 1:size(regimes,1)

    llregime[i] = log(pr[regimes[i,1]]*(1-epsilon)^regimes[i,2]*epsilon)

    if estregimes .== 0 # estimating all parameters

        function(F, gamma, rprime, splitter, corecoal, bigoutsiders, popsh, regimes[i, 1], P, lambda)

            if flag .== 1
                # shares are negative so exit loop
                break()
            end

            popsh = popshare[i for i in 1:numeth] 


            #now the predicted shares have to be replicated and vector shall be 
            #excluded into a vector for all observations in the regime

            for j=startregime:(startregime+regimes[i,2]-1)
                predshare[(j-1)*numeth+1:j*numeth]=shares

                exclude[j*numeth] = 1
                leader[(j-1)*numeth+regimes[i,1]] = 1
                largest[(j-1)*numeth+1] = 1
            end 


            #now perform a check of the insider constraint

            if final==1 

                coalvec = (shares.>0)
                coalvec[regimes[i,1]] = 0
                
                for m in 1:numeth 
                    if coalvec[m] .== 1

                        if m.== actualsplitter 
                            size_m= actualsplitsize
                        else size_m = elite[m]
                        end 

                        x_m = shares[m]/size_m

                        #now want to find shares that member would get if was leader 

                        function splitpredictedshares(F, gamma, rprime, splitter, corecoal, bigoutsiders, popshare, m, P, lambda)

                            popsh = popshare[i for i in 1:numeth] 

                            if tempflag .==1 
                                disp('WARNING: Some shares were negative when calculating the shares with coalition member being leader!')
                                disp('Shares:')
                                tempshares'
                            end 

                            xbar_m = tempshares[m]/elite[m]

                            #check sufficient condition such that if it holds insider constraint is always satisfied

                            scaledbar_m = size_m*delta*epsilon/(rprime*(1-delta)+delta*epsilon)*xbar_m

                            if scaledbar_m .> x_m
                                constflag = 1
                            end 

                        end 

                    end 

                end 

            end 

            startregime = startregime + regimes[i,2] 

        end 

    end 



    if ((estregimes == 0 && ((splitter != 0 && flag == 0) || (splitter !=0 && vectorize == 1 ))) || estregimes == 1)

if estregimes == 0

#now create an indicator function which is 1 if an ethnicity has observed positive shares (each time period)

    incoalition = (govshare>0)

    if final==1

        members[:,1] = (predshare>0)
            members[:,2] = incoalition
            
            members[:,3] = popshare
            sharedata[:,1] = leader.*predshare
            sharedata[:,2] = leader.*govshare
            sharedata[:,3] = largest.*predshare
            sharedata[:,4] = largest.*govshare
            sharedata[:,5] = predshare
            sharedata[:,6] = govshare

    end 


    #now we want to calculate beta distribution probabilities for those in and out of the coalition

    inpr = 1/2*betapdf[(govshare-predshare+1)/2,xi,xi]

    outpr = betacdf[(1-predshare)/2,xi,xi]

    #then create a vector of each observation's contribution to the log-likelihood 

    llobs = includeobs.*(1-exclude).*(incoalition.*log(inpr)+(1-incoalition).*log(outpr))


end


#finally, do not allow log likelihood to go to negative infinity to prevent optimzation issues

if vectorize .==0 
    if estregimes .==0
        ll = -max(-1E5,ones(1,size(popshare,1))*llobs)
    else 
        ll = -max(-1E5,ones(1,size(regimes,1))*llregime)
    end 
else 
    if estregimes .==0
        ll = -max(-1E5,llobs)

        if flag==1
            disp("WARNING: Shares are negative when calculating likelihood with vectorize==1:")
            shares' 
        end 
    else ()

        ll = -max(-1E5,llregime)
    end 
end 


else 

    #if no optimal coalition with non-negative shares can be found for some regime, set negative of log likelihood to a large value

    if vectorize == 0
        ll = 1E5
    else 

        error("Splitter can not be found when trying to calculate standard errors (vectorize==1")


    return ll, constflag, sharedata, members 

end 


