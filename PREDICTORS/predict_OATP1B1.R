library(caret)
library(ranger)
library(randomForest)


fitCaretModel = function(dxtrain=NULL, dytrain = NULL, bestpars)
{
    if(is.null(dxtrain))
    {
        stop("Error: training set is NULL")
        return(NULL)
    }

    if(is.null(dytrain))
    {
        stop("Error: response is NULL")
        return(NULL)
    }

    fitControl <- trainControl(method = "none", classProbs=TRUE, verboseIter=TRUE)
    
    rfModel = train(dxtrain, dytrain, method = "ranger", tuneGrid = bestpars, trControl = fitControl, num.trees = 500)

    return(rfModel)
}


computeConformityScores = function(modelFit = NULL, calibrationSet = NULL, ycalibrationSet = NULL)
{
    if(is.null(modelFit))
    {
        stop("Error: the input model is NULL")
    }

    if(is.null(calibrationSet))
    {
        stop("Error: calibrationSet is NULL")
    }

    if(is.null(ycalibrationSet))
    {
        stop("Error: response is NULL")
    }

    #The first column should be the class labels
    calibLabels = as.numeric(ycalibrationSet)

    predProb = predict(modelFit, calibrationSet, type="prob")
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



#------------------------------------------------------------------------------

args = commandArgs(trailingOnly=TRUE)

fpfile = args[1]
outfile = args[2]
applyadan = as.logical(as.integer(args[3]))


fittedmodel <- readRDS("MODELS/model_oatp1b1_ecfp6.rds")
X = read.csv(fpfile, header=F, row.names=1, colClasses = "factor")
yhat <- predict(fittedmodel, newdata = X)

# Inductive Conformal Prediction: Theory and Application to Neural Networks, Harris Papadopoulos
# Predict the classification with the largest p-value
# Output as confidence to this prediction one minus the second largest p-value, and as credibility the p-value of the output prediction, i.e. the largest p-value.

if (applyadan) {

    originalData <- fittedmodel$trainingData
    nrAttr = ncol(originalData) #no of attributes
    tempColumn = originalData[, nrAttr]
    trdata <- originalData[,1:(nrAttr-1)]
    ytrdata <- as.factor(originalData[, nrAttr])
    nTrainSize = nrow(trdata)
    #create partition for proper-training set and calibration set.
    result = sample(1:nTrainSize,  0.70*nTrainSize)
    calibSet = trdata[-result, ]
    ycalibSet = ytrdata[-result]
    properTrainSet = trdata[result, ]
    yproperTrainSet = ytrdata[result]
    modelFit = fitCaretModel(properTrainSet, yproperTrainSet, fittedmodel$bestTune)


    MCListConfScores = computeConformityScores(modelFit, calibSet, ycalibSet)
    testConfScores = predict(modelFit, newdata = X, type = "prob")
    pValues = computePValues(MCListConfScores, testConfScores)

    confidence = 1 - apply(pValues, 1, FUN=min) 

    Z <- data.frame(yhat, format(confidence, digits=2, nsmall=2), format(apply(pValues, 1, FUN=max), digits=2, nsmall=2))
    colnames(Z) <- c("Predicted", "Confidence", "Credibility")
    rownames(Z) <- rownames(X)
    write.table(Z, file=outfile, quote = F)
} else {
    Z <- data.frame(yhat)
    rownames(Z) <- rownames(X)
    colnames(Z) <- c("Predicted")
    write.table(Z, file=outfile, quote = F)
}






