#=26.03.2021, Till Kadereit
This is the file to replicate the Matlab code of Table 4 (MLE estimation) of Francois, Rainer
and Trebbi. It is based on the file "estimation" in the provided replication kit. =#

#install and add the XLSX package to be able to read in excel files


Pkg.add("XLSX")

using XLSX

xf = XLSX.readxlsx("C:\\Users\\Till\\Documents\\Uni\\Paris\\4thSemester\\Numerical_Methods\\Replication_Project\\Replication_kit_francois\\ECMA_Replication_FrancoisRainerTrebbi\\Matlab_files\\ethnicgroup_sorted2.XLSX")
XLSX.sheetnames(xf)
sh = xf["ethnicgroup_data"]



#set the percentage of elites (fixed across countries and time)
lambda=1



#Uganda

firstobs = 10710
lastobs = 11749
numeth = 26
countryparam = [1.682 100000 135.3 0.1004]


#extract the variables over the range of interest

popshare = [firstobs:lastobs,5]/100
leader = [firstobs:lastobs,6]
leadertrans = [firstobs:lastobs,15]
govsize = [firstobs:lastobs,7]
govposition = [firstobs:lastobs,8]

#inlcude all observations

includeobs = ones(size(popshare,1),1)

#calculate share of positions:

govshare = govposition./govsize

#normalize population

P=1

# determine regimes [leader & length of leadership]
# first column is leader; second is length of leadership
# third column is first observation of regime change


regimes = [leader; leadertrans; regimechange]'



idx = 1   # increments for each new regime


#Now we want to loop over all data loooking for leaders and regime changes 
#(in the case of multiple leaders, only the first will be picked up)
 
regimechange= 1      # we start by assuming a change
startofregime = 1    #start of first regime 
regimes[1,1] = NaN  # used to check that leader is found
regimes[1,3] = 1     # first transition associated with first observation 
