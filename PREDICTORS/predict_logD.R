library(caret)
library(ranger)



args = commandArgs(trailingOnly=TRUE)

fpfile = args[1]
outfile = args[2]
applyadan = as.logical(as.integer(args[3]))

fittedmodel <- readRDS("MODELS/model_logD_pubchem.rds")
fittedqrfmodel <- readRDS("MODELS/qrf_model_logD_pubchem.rds")

X = read.csv(fpfile, header=F, row.names=1, colClasses = "factor")
yhat <- predict(fittedmodel, newdata = X)


if (applyadan) {
	X <- rbind(fittedmodel$trainingData[1, 1:(ncol(fittedmodel$trainingData)-1)], X) 
	X <- X[-1,]
	# 95% predition intervals
	yhat_unc <- predict(fittedqrfmodel, X, quantiles = c(0.025, 0.975), type="quantiles")	
	Z <- data.frame(format(yhat, digits=2, nsmall=2), format(yhat_unc$predictions[,1], digits=2, nsmall=2), format(yhat_unc$predictions[,2], digits=2, nsmall=2))
	colnames(Z) <- c("Predicted", "quantile_0.025", "quantile_0.975")

	rownames(Z) <- rownames(X)
	write.table(Z, file=outfile, quote = F)
} else {
	Z <- data.frame(yhat)
	rownames(Z) <- rownames(X)
	colnames(Z) <- c("Predicted")
	write.table(Z, file=outfile, quote = F)
}

