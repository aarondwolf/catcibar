# catcibar
 A Stata program to create bar charts with confidence intervals for multiple variables.

## Installing via *net install*

The current version is still a work in progress. To install, user can use the net install command to download from the project's Github page:

```
net install catcibar, from("https://aarondwolf.github.io/catcibar")
```

## Dependencies
`catcibar` uses `mylabels`, by Nick Cox, when using the `proportion` or `percent` options. In Stata, to install the package, type in:
```
net sj 22-4 gr0092
```

## Syntax

```
    catcibar { varlist | varname } [if] , [options]
```



Options
-----------------------------------------------------------------------------------------------


| Option                | Description                                                  |
| --------------------- | ------------------------------------------------------------ |
| over(varname)         | Set over variable for proportion or mean command.            |
| by(varlist[, byopts]) | Repeat for subgroups. See by_option for sub-options.         |
| proportion            | Get proportions of each level of varlist instead of mean. Varlist must  use only one varname. |
| percent               | Display Y-axis labels as %. This is on by default if proportion is specified. |
| colors(colorlist)     | Set colors for each level of over variable.                  |
| ciopts(line_options)  | Options for confidence interval lines. See twoway rcap and line_options. |
| cilevel(real)         | Set the confidence level for a two-way test. Default is 95.  |
| nlabel                | Prints the number of observations in each over group. Only works if the  number of observations per group is constant over. |
| wrapxlab(integer)     | Wrap x-axis labels at after each Nth character (after a full word). Default  is 20. |
| nopreserve            | Do not preserve current dataset. Useful for debugging.       |
| marker_label_options  | Optional labels for bar or confidence intervals. Note: {opt ml:abel()} must be one of *mean*, *ll*, or *ul*. **catcibar** will throw an error otherwise. All other options are as specified in marker_label_options, and will be passed directly to each bar.             |
| twoway_options        | titles, legends, axes, added lines and text, by, regions, name, aspectratio, etc. Any options not in the above list will be passed directly to **twoway** exactly as input. |


 

## Description

catcibar generates summary statistics and confidence intervals for varlist, and plots the resulting graph using twoway bar and twoway rcap. The varname specified in over(varname) is used to graph bars of different colors, one for each value of over. Each category of the specified varname (if proportion is specified), or each variable in varlist (if mean is specified) is plotted as a separate cluster of bars along the x-axis.

Any options not detailed in the above list will be passed directly to twoway when drawing the
graph.

Graphs can be plotted by subgroup by specifying the *by()* option. This is passed directly to twoway as well.

## Author

Aaron Wolf, Northwestern University
aaron.wolf@u.northwestern.edu