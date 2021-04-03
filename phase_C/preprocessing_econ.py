import pandas as pd

#empty dataframe analogous to the EconomicHealth relation 
econHealth = pd.DataFrame()

#note: all csv files are already 1948-2020 

#UNEMPLOYMENT RATE
ue_monthly = pd.read_csv("sourceData/unemployment_monthly.csv") 
print(ue_monthly) 
ue_monthly_noyear = ue_monthly.drop(columns = ['Year']) #take off the year for averaging 
econHealth['year'] = ue_monthly['Year']
econHealth['unemploymentRate'] = ue_monthly_noyear.mean(axis = 1) #average over 12 months 

#REAL GDP PERCENT CHANGE  
gdp_pch = pd.read_csv("sourceData/GDP_percent_change_annual.csv") 
print(gdp_pch) 
econHealth['realGdpPch'] = gdp_pch['GDP_PCH']

#S&P 500 RETURN ON INVESTMENT 
snp_roi = pd.read_csv("sourceData/sp-500-historical-annual-returns.csv") 
print(snp_roi)
econHealth["snpRoi"] = snp_roi['roi']

#look at the cute dataframe we made :) 
print(econHealth)
#export to a text file with no row numbers, no headers, and 4 decimal places 
econHealth.to_csv("EconomicHealth.txt", index = False, header = False, float_format = "%.4f") 
#TODO: get the 8-15 row subset of econHealth for EconomicHealth-small.txt




