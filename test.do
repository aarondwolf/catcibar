clear
sysuse nlsw88

catcibar wage, over(collgrad) by(smsa)
return list
