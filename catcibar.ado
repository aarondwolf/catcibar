*! version 1.0.1  27oct2020 Aaron Wolf, aaron.wolf@yale.edu
//	Program for making bar graphs with CIs based on prop: commands
*set trace on
cap program drop catcibar
program define catcibar, rclass
	
	version 13
	syntax varlist [if] , 	[Over(varname numeric) by(passthru) CILevel(real 95) PERcent PROPortion WRAPXlab(integer 20) NLabel MEAN Noisily Colors(string) noPREserve CIOpts(string asis) *]
	
	* Ensure varlist is varname if proportion specified
	cap assert wordcount("`varlist'") == 1 if "`proportion'" == "proportion"
	if _rc {
	    di as error "Only one variable can be specified if {it: proportion} specified."
		error 197
	}
	
	* Get varlist from by
	if `"`by'"' != "" {
		tokenize `"`by'"', parse(",")
		local byvars: subinstr local 1 "by(" "", all 
		local byvars: subinstr local byvars ")" "", all 
		confirm variable `byvars'
	}
	else local byvars 

qui {
    
if "`preserve'" != "nopreserve" preserve

	* Drop if any groups are missing
	foreach var of varlist `varlist' `over' `byvars' {
	    drop if mi(`var')
	}
	
	* Create "over" variable if missing
	if "`over'" == "" {
	    tempname overlabel
	    tempvar overvar
		gen `overvar':`overlabel' = 1
		local over `overvar'
		la def `overlabel' 1 "All"
	}
	
	* Split varlist if proportion specified
	if "`proportion'" == "proportion" {
	    tempvar split
		tab `varlist', gen(`split')
		* Remove original variable name from split labels
		foreach var of varlist `split'* {
		    local lab: variable label `var'
			local lab = subinstr("`lab'","`varlist'==","",.)
			la var `var' "`lab'"
		}
		ds `split'*
		local varlist `r(varlist)'
	}	
	
	* Get value and variable lables from over variable
	local `over'_vallabel: value label `over'	
	tempfile vallabels
	la save ``over'_vallabel' using `vallabels'
	local `over'_lab: variable label `over'

	
	* Get local list of mean and semean variables
	local words: word count `varlist'
	forvalues i = 1/`words' {
	    local var: word `i' of `varlist'
		local means `means' mean`i'=`var'
		local semeans `semeans' semean`i'=`var'
		local counts `counts' count`i'=`var'
		local `var'_lab: variable label `var'
	}
	
			
	* Collapse varlist by subgroups
	collapse (mean) `means' (semean) `semeans' (count) `counts' `if', by(`over' `byvars')
	sort `over' `byvars'
	gen i = _n
	
	* Reshape long
	reshape long mean semean count, i(i) j(varname) 
	forvalues i = 1/`words' {
	    local var: word `i' of `varlist'
		lab def varname `i' "`var'", modify
	}
	la val varname varname
	
	* Confidence intervals 1 - `ci'/2
	bysort varname: egen N = sum(count)
	local pvalue = (100-`cilevel')/200
	gen ll = mean - invttail(N-1,`pvalue')*semean
	gen ul = mean + invttail(N-1,`pvalue')*semean	
		
	* Calculate barwidth
	levelsof `over', local(overlevels)
	local levels = wordcount("`overlevels'")
	local bw = 1/(1 + `levels')
	sum `over'
	local min = `r(min)'
	
	* Calculate number of observations within over/over2
	bysort varname `over': egen nlabel = sum(count)
	bysort varname `byvars': egen bynlabel = sum(count)
		
	* Get other options
	local cilegend = `levels' + 1
						
	* Reconfigure varlist and over to start at 1, with no gaps
	gen over:over = .
	local n = 1
	foreach i in `overlevels' {
	    replace over = `n' if `over' == `i'
		local vallab: label (`over') `i'
		local legend `"`legend' `n' "`vallab'""'
		la def over `n' "`vallab'", modify
		local++n
	}
				
	* Get x labels from varlist levels
	forvalues i = 1/`words' {
		local var: word `i' of `varlist'
		catbar_wrap "``var'_lab'", at(`wrapxlab')
		local xlab `"`xlab' `i' `"`r(name)'"' "'
	}
	
	*noi macro list _all
	*exit
	
	* Generate an x variable for subgroup graphing
		// Centered on varlist, with over labels below or above their median
	egen tag = tag(over)
	sum over if tag, d
	gen x = varname + (over - `r(p50)')/(`levels'+1)
	
	* Get xmlabels
	sum x
	local min = `r(min)' - `bw'/2
	local max = `r(max)' + `bw'/2
	
	* Draw Graphs
	forvalues i = 1/`levels' {
		local color: word `i' of `colors'
		local bars `bars' (bar mean x if over == `i', barw(`bw') color(`color'))	
	}
	
	* % labels for proportion
	if ("`percent'" == "percent") | ("`proportion'" == "proportion") mylabels 0(20)100, myscale(@/100) local(percent) suffix("%")
		
	* Legend on or off
	if "`over'" ==  "`overvar'" local legend off
	else local legend order(`legend' `cilegend' "`cilevel'% CI")
		
	twoway `bars' (rcap ll ul x , lcolor(gs7) `ciopts'	) `nplot', `by' legend(`legend') ///
		xtitle("") xlabel(`xlab') xmlabel(`min' " " `max' " ", notick) ///
		`options' ylabel(`percent')
	
if "`preserve'" != "nopreserve" restore
}

	return local varlist 	`varlist'
	return local over		`over'
	if "`byvars'" != "" return local by `byvars'
	return scalar pvalue = `pvalue'

end	



cap program drop catbar_wrap
program define catbar_wrap, rclass
		
	syntax anything, [LOCAL(name) at(integer 40)]
		
	local length = length(`anything')
	local pieces = ceil(`length'/`at')

	if `length' > `at' {
		forvalues i = 1/`pieces' {
			local lab`i': piece `i' `at' of `anything', nobreak
			local name `"`name' "`lab`i''" "'
		}
	}
	else {
		local name `anything'
	}
	
	di `"`name'"'
	return local name = `"`name'"'
	return scalar length = `length'
	return scalar pieces = `pieces'
	
	
	if "`local'" != "" c_local `local' = `"`name'"'
		
end

