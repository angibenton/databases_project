import pandas as pd

#UNEMPLOYMENT DATA
ue_monthly = pd.read_csv("unemployment_monthly.csv");
print(ue_monthly); #before
ue_yearly = pd.DataFrame()
ue_yearly['year'] = ue_monthly['Year']
ue_monthly_noyear = ue_monthly.drop(columns = ['Year'])
ue_yearly['unemploymentRate'] = ue_monthly_noyear.mean(axis = 1)
ue_yearly = ue_yearly[ue_yearly.year != 2021]
print(ue_yearly); #after 

