clear
sysuse nlsw88

*set trace on
catcibar wage, over(collgrad) by(smsa)
return list
