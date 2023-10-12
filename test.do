clear
sysuse nlsw88

*set trace on
catcibar wage, over(collgrad) by(smsa) mlabel(mean)
return list
