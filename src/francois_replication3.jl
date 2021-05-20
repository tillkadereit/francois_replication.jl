#=11.05.2021, This is the file to replicate the code of 
the "pooledestimation" file of Francois et al. 2013 =#



function main_pooled()

skipest = 1 

usetopshare = 0   #set to 0 to use top government positions only 

#set to look at the subsample with all observations 
subsample = 0

#set a global countryparam vector that will be filled with/contain all values later; it shall be accessed here and within in the 
#pooledlikelihood function, s.t. maintains values across functions calls 

module countryparam

countryparam = Vector{Dict}(F, gamma, rprime, xi)

end 



# index of last observation in the data
lastdataobs = 11749



using DataFrames
using XLSX

#sort author's excel columns and store them in respective variable  (as in the other file)
data = XLSX.readdata("ethnicgroup_sorted2.XLSX", "ethnicgroup_data", "A2:Y11750")

rawtext = DataFrame(data[:, [1,4,5]])    #save the text columns in "rawtext"
rawnumeric = DataFrame(data[:,2:25])     #save all other columns in "rawnumeric" 

rawnumeric[:,3:4] .= NaN                    #replace the 3rd and 4th columns by NaN, such that the columns structure
                                            #corresponds exactly to that of Francois et al.


#now want to create a 3-column array: 1st column is number of ethnicities in the country, 2nd

#column is observation at which country starts in the data, third is where the country ends

countries = [15 21 30 17 10 22 9 16 15 17 10 14 37 20 26; 1 646 1549 2809 3557 3997 4965 5361 6001 6661 7392 7822 8424 9830 10710; 645 1548 2808 3556 3996 4964 5360 6000 6660 7391 7821 8423 9829 10709 11749]'

numcountries = size(countries,1)   #yields number of countries used (15)

lambda = 1  #percentage of elites; assume fixed across countries and time 


popshare = rawnumeric[1:lastdataobs,5]/100
leader = rawnumeric[1:lastdataobs,6]
leadertrans = rawnumeric[1:lastdataobs,15]
if usetopshare .== 1
    govsize = rawnumeric[1:lastdataobs,10]
    govposition = rawnumeric[1:lastdataobs,11]
else()
    govsize = rawnumeric[1:lastdataobs,7]
    govposition = rawnumeric[1:lastdataobs,8]
end
year = rawnumeric[1:lastdataobs,2]
country = rawtext[2:lastdataobs+1,1]
group = rawtext[2:lastdataobs+1,4]



end 