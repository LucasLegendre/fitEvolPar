fitEvolPar<-function(dat,tre,mod) {
  require(ape)
  require(evobiR)
  if (identical(setdiff(tre$tip.label, rownames(dat)), character(0))==FALSE) {
    stop("row names in the data and tips in the tree do not match")
  }
  if (ncol(dat) > 2) {
    stop("data frame contains more than two columns")
  }
  dat<-ReorderData(tre,dat)
  spp<<-rownames(dat)
  Wcv<<-diag(vcv.phylo(tre))
  colnames(dat)<-c("x","y")
  switch (mod, 
    OU = {
      alpha <- seq(0, 1, 0.1)
      fit <- list()
      for (i in seq_along(alpha)) {
        cor <- corMartins(alpha[i], phy = tre, fixed = TRUE, form=~spp)
        if (is.ultrametric(tre)==TRUE) {
          fit[[i]] <- gls(y~x, correlation = cor, data=dat, na.action=na.exclude, method = "ML")
        } else {
          fit[[i]] <- gls(y~x, correlation = cor, data=dat, weights=varFixed(~Wcv), na.action=na.exclude, method = "ML")
        }
      }
      print((which.max(sapply(fit, logLik))-1)*0.1)
    },
    lambda = {
      lambda<- seq(0, 1, 0.1)
      fit <- list()
      for (i in seq_along(lambda)) {
        cor <- corPagel(lambda[i], phy = tre, fixed = TRUE, form=~spp)
        if (is.ultrametric(tre)==TRUE) {
        fit[[i]] <- gls(y~x, correlation = cor, data=dat, na.action=na.exclude, method = "ML")
        } else {
        fit[[i]] <- gls(y~x, correlation = cor, data=dat, weights=varFixed(~Wcv), na.action=na.exclude, method = "ML")
        }
      }
      print((which.max(sapply(fit, logLik))-1)*0.1)
    },
    EB = {
      g <- seq(0.1, 1, 0.1)
      fit <- list()
      for (i in seq_along(g)) {
        cor <- corBlomberg(g[i], phy = tre, fixed = TRUE, form=~spp)
        if (is.ultrametric(tre)==TRUE) {
          fit[[i]] <- gls(y~x, correlation = cor, data=dat, na.action=na.exclude, method = "ML")
          } else {
          fit[[i]] <- gls(y~x, correlation = cor, data=dat, weights=varFixed(~Wcv), na.action=na.exclude, method = "ML")
          }
        }
      print(which.max(sapply(fit, logLik))*0.1)
    },
    stop("Please specify an accepted evolutionary model")
  )
}
