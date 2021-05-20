

#=
   26.03.2021, Till Kadereit
   This is the file to replicate the Matlab code of Table 4 (MLE estimation) of Francois, Rainer
   and Trebbi. It is based on the file "estimation" in the provided replication kit. 
=#

#install and add the XLSX package to be able to read in excel files

using XLSX


function main() 

#sort author's excel columns and store them in respective variable  (as in the other file)

data = XLSX.readdata("ethnicgroup_sorted2.XLSX", "ethnicgroup_data", "A2:Y11750")

rawtext = data[:, [1,4,5]]    #save the text columns in "rawtext"
rawnumeric = data[:,2:25]     #save all other columns in "rawnumeric" 

#set the percentage of elites (fixed across countries and time)
lambda=1



#Uganda
firstobs = 10710
lastobs = 11749
numeth = 26
countryparam = [1.682 100000 135.3 0.1004]


#extract the variables over the range of interest

popshare = rawnumeric[firstobs:lastobs,5]/100
leader = rawnumeric[firstobs:lastobs,6]
leadertrans = rawnumeric[firstobs:lastobs,15]
govsize = rawnumeric[firstobs:lastobs,7]
govposition = rawnumeric[firstobs:lastobs,8]

#inlcude all observations

includeobs = ones(size(popshare,1),1)

#calculate share of positions:

govshare = govposition./govsize

#normalize population

P=1

# determine regimes [leader & length of leadership]
# first column is leader; second is length of leadership
# third column is first observation of regime change



idx = 1   # increments for each new regime


#Now we want to loop over all data loooking for leaders and regime changes 
#(in the case of multiple leaders, only the first will be picked up)
 
regimechange= 1      # we start by assuming a change
regimes = [leader; leadertrans; regimechange]'   # determine regimes, first columns being leader, second is length of leadership
startofregime = 1    #start of first regime 
regimes[1,1] = NaN  # used to check that leader is found
regimes[1,3] = 1     # first transition associated with first observation 


for i=(1:size(popshare,1))       
    # look for transition only every numeth rows
    if (regimechange == 0 && leadertrans[i] == 1 && mod(i, numeth) .== 1)
        regimechange = 1
        regimes[idx,2] = (i-startofregime)/numeth
        startofregime = i
        idx = idx + 1
        regimes[idx,1] = NaN  # used to check that leader is found
        regimes[idx,3] = i    # observation at which transition occurred
    end
    if regimechange .== 1
        # looking for new leader
        if leader[i] == 1
            # found leader of new regime
            regimes[idx,1] = mod(i, numeth)
            if regimes[idx,1] .== 0
                regimes[idx,1] = numeth
            end
            regimechange = 0
        end
    end
    
end



# length of last regime

# regimechange should be zero as we should have found the last start of
# regime & then the leader of that regime

regimechange = 0

if regimechange .== 0 
    regimes[idx,2] = (size(popshare,1)+1-startofregime)/numeth
else()
    error("A leader was not found in the last regime.")
end


# check that leaders were always found
if (sum(isnan(regimes[:,1])))
    error("A leader was not found for at least one regime.")
end



# the parameter vector to be estimated is (first to last)

# Fprime - leadership payoff; transformed
# gamma_t - probability of successful coup [transformed]
# xi - parameter governing [beta] error distribution
# rprime = delta*epsilon*(1-r)/r/(1-delta) where delta is the
# discount factor; epsilon is the probability of regime change; & r is()
# the factor by which patronage is destroyed when a revolution occurs




# fix alpha & epsilon at estimates from pooled estimation
alpha = 11.5222
epsilon = 0.115/(1-0.115) # transformed from estimate obtained




myll = (paramvec) -> splitlikelihood[paramvec,popshare,govshare,P,regimes,includeobs,numeth,lambda,0,0,[alpha epsilon],0]





#create bounds for the initial population (not binding during optimization)


initrange = [0.25 0 40 0; 2 10 250 1]

#set options for ga algorithm
options = gaoptimset["PopulationSize",1000,"Generations",200,"TolFun",1E-10,"PopInitRange",initrange]


#if an estimate from pooledestimation exists, place in initial population

if (exist("countryparam","var")) ~= 0
    disp("Using estimate from pooledestimation in initial population.")
    options = gaoptimset[options,"InitialPopulation",countryparam]
end


#estimation
[paramestga fvalga exitflag] = ga[myll,4,options]


#local optimization (options and estimation)
fminopts = optimset("Display","off","TolX",1e-6,"TolFun",1e-10, "MaxIter", 10000,"MaxFunEvals",10000)
[paramest,fval,fminflag] = fminsearch(myll,paramestga,fminopts)

if fminflag~=1
    disp("WARNING: fmin failed to converge.")
end



# report likelihood & check that insider constraint is not violated

[ll,constflag] = splitlikelihood[paramest,popshare,govshare,P,regimes,includeobs,numeth,lambda,0,0,[alpha epsilon],1]

if constflag .== 1
    error("Insider constraint is violated at estimated parameters.")
end



# calculate standard errors using the outer product of gradients
# likelihood function returns the vector of likelihoods rather than total

var = OPG["splitlikelihood",paramest,popshare,govshare,P,regimes,includeobs,numeth,lambda,1,0,[alpha epsilon],0]



seorig = sqrt(diag(inv(var))); # untransformed std errors


# transform variables

gamma = abs(paramest[2])/(1+abs(paramest[2]))
F = paramest[1]*(1-gamma)/gamma()


J = zeros(size(paramest,2),size(paramest,2))
J[1,1] = (1-gamma)/gamma; # derivative of F wrt F'
J[1,2] = -paramest[1]/gamma^2*transformder[paramest[2]]; # derivative of F wrt gamma()
J[2,2] = transformder[paramest[2]]; # derivative of transformation for gamma()
J[3,3] = 1; # no transformation for xi
J[4,4] = 1; # no transformation for rprime



# transform & report estimates

disp("The estimated parameters are: F, gamma, xi, rprime, Fprime")



[F gamma paramest[3] paramest[4] paramest[1]]

disp("with standard errors:")
se = sqrt(diag(J*inv(var)*J')); #standard errors

[se[1] se[2] se[3] se[4] seorig[1]]




end 