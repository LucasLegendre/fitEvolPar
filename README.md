# fitEvolPar

## Description

This function estimates the best fit for an evolutionary parameter (α, λ, or g) in a phylogenetic generalised least squares (PGLS) model, using log-likelihood.

## Usage
```
fitEvolPar(tre, dat, mod=c("OU", "lambda","EB"))
```

## Arguments
`tre` &nbsp; &nbsp; &nbsp; an ultrametric phylogenetic tree (object of class "`phylo`")

`dat` &nbsp; &nbsp; &nbsp; a data frame containing the two variables (predictive and response) to include in a PGLS analysis

`mod` &nbsp; &nbsp; &nbsp; the phylogenetic correlation structure (covariance matrix) for the evolutionary model to estimate the main parameter of

## Details
Function will stop if the data contains missing values and/or if the tips of the tree do not match the row names in the data frame. Data frame `dat` needs to have two columns: the predictive variable (x) on the left, and the response one (y) on the right.

Correlations structures defined by the user with `mod` can be: `"OU"`(Ornstein-Uhlenbeck – Martins and Hansen, 1997; Butler and King, 2004), `"lambda"` (Brownian Motion with a maximum likelihood estimate of Pagel's λ – Freckleton et al., 2002), or `"EB"` (Early Burst – Blomberg et al., 2003). PGLS models are fitted using `gls` in `nlme` with correlation structures from `ape` (see `?corClasses`).

## Value
A parameter estimate for the model of choice (α for `"OU"`, Pagel's λ for `"lambda"`, or g for `"EB"`). Value is comprised between 0 and 1 (0.1 and 1 for g), with one significant figure.

## Author(s)
Lucas Legendre <lucasjlegendre@gmail.com>

## Acknowledgements
This function was adapted from a piece of code written by Emmanuel Paradis on the R-sig-phylo mailing list (<https://stat.ethz.ch/mailman/listinfo/r-sig-phylo>).

## References

Blomberg, S. P., Garland, T. and Ives, A. R. (2003) Testing for phylogenetic signal in comparative data: Behavioral traits are more labile. <i>Evolution</i>, <b>57</b>, 717–745.

Butler, M. A. and King, A. A. (2004) Phylogenetic comparative analysis: A modeling approach for adaptive evolution. <i>The American Naturalist</i>, <b>164</b>, 683–695.  

Freckleton, R. P., Harvey, P. H. and Pagel, M. (2002) Phylogenetic analysis and comparative data: A test and review of evidence. <i>The American Naturalist</i>, <b>160</b>, 712–726.  

Martins, E. P. and Hansen, T. F. (1997) Phylogenies and the comparative method: a general approach to incorporating phylogenetic information into the analysis of interspecific data. <i>The American Naturalist</i>, <b>149</b>, 646–667.

## See Also
[corClasses](https://cran.r-project.org/web/packages/ape/ape.pdf#Rfn.corClasses), [gls](https://cran.r-project.org/web/packages/nlme/nlme.pdf#Rfn.gls)

## Examples
```
library(ape)
library(evobiR)
library(phytools)

# Load the data
data(anole.data)
data(anoletree)

# Reorganize the data into 'dat'
dat<-cbind.data.frame(anole.data$SVL, anole.data$HL)
colnames(dat)<-c("SVL", "HL"); rownames(dat)<-rownames(anole.data)

# Estimate individual parameter for a lambda model
fitEvolPar(anole.tree, dat, "lambda")

# Use in a 'gls' object with an OU model
spp<-rownames(anole.data)
reg<-gls(HL~SVL, anole.data, correlation=corMartins(fitEvolPar(anole.tree, dat, "OU"), phy = anoletree, fixed = TRUE, form=~spp))
summary(reg)
```
