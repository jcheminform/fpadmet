library(caret)
library(ranger)
library(randomForest)

#------------------------------------------------------------------------------

#' This function is internal to the package
#' @param trainingSet The training set
#' @param method Method for modeling
#' @param nrTrees Number of trees for RF
#' @return The fitted model
fitModel = function(trainingSet=NULL, method = "rf",  nrTrees = 100)
{
  	if(is.null(trainingSet))
  	{
    	stop("Error: training set is NULL")
    	return(NULL)
  	}

  	if(method != "rf")
  	{
    	stop("Error: only random forest is supported in the current release")
    	return(NULL)
  	}

  	#the first colum should be class labels, labeled as 1, 2, ...
  	#names(trainingSet)[1] <- "Y"

  	#trainingSet$Y <- as.factor(trainingSet$Y)

  	rfModel <- randomForest(Y ~ ., data = trainingSet, ntree = nrTrees, norm.votes = TRUE, keep.forest = TRUE, predict.all = TRUE, type = "classification")

  	return(rfModel)
}

computeConformityScores = function(modelFit = NULL, calibrationSet = NULL)
{
  	if(is.null(modelFit))
  	{
    	stop("Error: the input model is NULL")
  	}

  	if(is.null(calibrationSet))
  	{
    	stop("Error: calibrationSet is NULL")
  	}

  	#The first colum should be the class labels
  	calibLabels = as.numeric(calibrationSet[, 1])

  	predProb = predict(modelFit, calibrationSet[, -1], type="prob")
  	nrLabels = ncol(predProb) # number of class labels

  	MCListConfScores = list() #Moderian Class wise List of conformity scores
  	for(i in 1:nrLabels)
  	{
    	classMembers = which(calibLabels == i)
    	MCListConfScores[[i]] =  predProb[classMembers, i]
  	}

  	return(MCListConfScores)
}

computePValues = function(MCListConfScores = NULL, testConfScores = NULL)
{
  	if(is.null(MCListConfScores) || is.null(testConfScores))
  	{
    	stop("Error: the list MCListConfScores is NULL")
    	return(NULL)
  	}

  	nrTestCases = nrow(testConfScores)
  	nrLabels = ncol(testConfScores)
  	pValues = matrix(0, nrTestCases,  nrLabels)

  	for(k in 1:nrTestCases)
  	{
    	for(l in 1:nrLabels)
    	{
      		alpha = testConfScores[k, l]
      		classConfScores = MCListConfScores[[l]]
      		pVal = length(which(classConfScores < alpha)) + runif(1)*length(which(classConfScores == alpha))
      		pValues[k, l] = pVal/(length(classConfScores)+1)
    	}
  	}
  	return(pValues)
}

#' Class-conditional Inductive conformal classifier for multi-class problems
#' @param trainingSet Training set
#' @param testSet Test set
#' @param ratioTrain The ratio for proper training set
#' @param method Method for modeling
#' @param nrTrees Number of trees for RF
#' @return The p-values
#' @export
ICPClassification = function(trainingSet, testSet, ratioTrain = 0.7, method = "rf", nrTrees = 100)
{
  	if(is.null(trainingSet) || is.null(testSet) )
  	{
    	stop("\n 'trainingSet' and 'testSet' are required as input\n")
  	}

  	nTrainSize = nrow(trainingSet)
  	#create partition for proper-training set and calibration set.
  	result = sample(1:nTrainSize,  ratioTrain*nTrainSize)

  	calibSet = trainingSet[-result, ]
  	properTrainSet = trainingSet[result, ]

  	modelFit = fitModel(properTrainSet, method = method, nrTrees = nrTrees)
  	if(is.null(modelFit))
    	return(NULL)

  	MCListConfScores = computeConformityScores(modelFit, calibSet)
  	# the following is a hack since for some reason the model won't accept the default matrix
  	xtest <- rbind(properTrainSet[1, ], testSet) 
	xtest <- xtest[-1,]
  	testConfScores = predict(modelFit, xtest[, -1], type = "prob")
  	pValues = computePValues(MCListConfScores, testConfScores)

  	return(pValues)
}

#' Class-conditional transductive conformal classifier for multi-class problems
#' @param trainSet Training set
#' @param testSet Test set
#' @param method Method for modeling
#' @param nrTrees Number of trees for RF
#' @return The p-values
#' @export
TCPClassification = function(trainSet, testSet, method = "rf", nrTrees = 100)
{
  	if(is.null(trainSet) || is.null(testSet) )
  	{
    	stop("\n 'trainingSet' and 'testSet' are required as input\n")
  	}

  	nrTestCases = nrow(testSet)
  	nrLabels = length(unique(testSet[, 1]))
  	pValues = matrix(0, nrTestCases, nrLabels)

  	for(i in 1:nrLabels){
    	clsLabel = i
    	for(k in 1:nrTestCases)
    	{
      		tempTestCase = testSet[k, ]
      		tempTestCase[1]= clsLabel
      		tcpTrainSet = rbind(trainSet, tempTestCase)
      		pValues[k, i] = tcpPValues(tcpTrainSet, method = method, nrTrees = nrTrees)
    	}
  	}
  	return(pValues)
}


#' calculate pvalues using conformal
#' @model the trained caret model
#' @newdata test data
#' @pred the predicted value
#
calculatePValues <- function(model, newdata, pred) {
    originalData <- model$trainingData
    cnames <- colnames(originalData)
    nrAttr = ncol(originalData) #no of attributes
    tempColumn = originalData[, nrAttr]
    trdata <- cbind(tempColumn, originalData[,1:(nrAttr-1)])
    colnames(trdata) <- c("Y", cnames[1:(nrAttr-1)])
    trdata[, 1] = as.factor(as.numeric(trdata[, 1]))
    gdata <- cbind(as.numeric(pred), newdata)
    colnames(gdata) <- c("Y", colnames(newdata))
    pValues = ICPClassification(trdata, gdata, nrTrees = model$finalModel$num.trees)
    return(pValues)
}


#------------------------------------------------------------------------------

args = commandArgs(trailingOnly=TRUE)

fpfile = args[1]
outfile = args[2]
applyadan = as.logical(as.integer(args[3]))

fittedmodel <- readRDS("MODELS/model_anticommensal_pubchem.rds")


X = read.csv(fpfile, header=F, row.names=1, colClasses = "factor")
yhat <- predict(fittedmodel, newdata = X)

# Inductive Conformal Prediction: Theory and Application to Neural Networks, Harris Papadopoulos
# Predict the classification with the largest p-value
# Output as confidence to this prediction one minus the second largest p-value, and as credibility the p-value of the output prediction, i.e. the largest p-value.

if (applyadan) {
	pvals <- calculatePValues(fittedmodel, X, yhat)
	#write.table(pvals, file="", quote=F, row.names=F, col.names=F)

	confidence = 1 - apply(pvals, 1, FUN=min) # for binary

	Z <- data.frame(yhat, format(confidence, digits=2, nsmall=2), format(apply(pvals, 1, FUN=max), digits=2, nsmall=2))
	colnames(Z) <- c("Predicted", "Confidence", "Credibility")
	rownames(Z) <- rownames(X)
	write.table(Z, file=outfile, quote = F)
} else {
	Z <- data.frame(yhat)
	rownames(Z) <- rownames(X)
	colnames(Z) <- c("Predicted")
	write.table(Z, file=outfile, quote = F)
}

