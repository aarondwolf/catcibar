{smcl}
{* *! version 1.0.2 Aaron Wolf 27oct2020}{...}
{title:Title}

{phang}
{cmd:catcibar} {hline 2} Draw bar graphs with confidence intervals for proportions or multiple variables.
{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{opt catcibar}
{ {varlist} | {varname} }
[{help if}] {cmd:,} [options]

{* Using -help odkmeta- as a template.}{...}
{* 24 is the position of the last character in the first column + 3.}{...}
{synoptset 24 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opth o:ver(varname)}}Set {it:over} variable for  {help proportion} or {help mean} command.{p_end}
{synopt:{cmd:by(}{help varlist}[{cmd:,} {it:byopts}]{cmd:)}}Repeat for subgroups. See {help by_option} for sub-options.{p_end}
{synopt:{opt prop:ortion}}Get proportions of each level of {help varlist} instead of mean. {it:varlist} must use only one {help varname}.{p_end}
{synopt:{opt per:cent}}Display Y-axis labels as %. This is on by default if {it: proportion} is specified.{p_end}
{synopt:{opth c:olors(colorlist)}}Set colors for each level of {it:over} variable.{p_end}
{synopt:{opth cio:pts(line_options)}}Options for confidence interval lines. See {help twoway rcap} and {help line_options}. {p_end}
{synopt:{opth cil:evel(real)}}Set the confidence level for a two-way test. Default is 95.{p_end}
{synopt:{opt nl:abel}}Prints the number of observations in each {opt o:ver} group. Only works if the number of observations per group is constant over.{p_end}
{synopt:{opth wrapx:lab(integer)}}Wrap x-axis labels at after each Nth character (after a full word). Default is 20.{p_end}
{synopt:{opt cw}}Calculate means and confidence intervals casewise. Default is to drop all observations where any observations of {it:varlist}, {it:over}, or {it:by(varlist)} are missing.{p_end}
{synopt:{opt {help twoway_options}}}titles, legends, axes, added lines and text, by, regions, name, aspectratio, etc.{p_end}
{synopt:{opt nop:reserve}}Do not {help preserve} current dataset. Useful for debugging.{p_end}
{synopt:{opt n:oisily}}Display result of {help proportion} or {help mean} command. Useful for debugging.{p_end}
{synoptline}

{title:Description}

{pstd}
{cmd:catcibar} generates summary statistics and confidence intervals for varlist,
and plots the resulting graph using twoway bar and twoway rcap. The varname
specified in {cmd:over(varname)} is used to graph bars of different colors,
one for each value of over. Each category of the specified varname
(if proportion is specified), or each variable in varlist is plotted as a
separate cluster of bars along the x-axis.

{pstd}
Any options not detailed in the above list will be passed directly to
{help twoway} when drawing the graph.

{pstd}
Graphs can be plotted by subgroup by specifying the *by()* option. This is
passed directly to twoway as well.


{title:Author}

{pstd}Aaron Wolf, Yale University {p_end}
{pstd}aaron.wolf@yale.edu{p_end}
