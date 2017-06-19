# Dynamic Link Prediction Evaluation Toolbox

This toolbox is used for evaluation of link prediction accuracy in dynamic networks where edges are both added and removed over time, which we refer to as *dynamic link prediction*. 
Refer to the [paper](http://arxiv.org/abs/1607.07330) for more details.

## Download
1. Download or clone the Git repository
2. Add the root folder to your MATLAB path

## Usage
Due to the enormous difference in the difficulty of predicting new links and previously observed links as discussed in Sections IV and V of the [paper](http://arxiv.org/abs/1607.07330), we suggest to evaluate new link prediction and previously observed link prediction separately.

### Evaluating New Link Prediction
The recommended metric for prediction of new links is the area under the Precision-Recall curve (PRAUC). This is done using the function `dlpPRCurve()` as follows:

`[recall,precision,prauc] = dlpPRCurve(adj,predMat,'new',directed)`

where the third output denotes the desired PRAUC metric.

### Evaluating Previously Observed Link Prediction
The recommended metric for prediction of previously observed links is the area under the Receiver Operating Characteristic curve (AUC). This is done using the function `dlpROCCurve()` as follows:

`[fpr,tpr,thres,auc] = dlpROCCurve(adj,predMat,'existing',directed)`

where the fourth output denotes the desired AUC metric.

### Unified Evaluation Metric
If a single evaluation metric is desired, we recommend the geometric mean of the two metrics above (after a baseline correction), which we denote by the GMAUC. This can be computed using the function `unifiedDlpMetric()` as follows:

`unifiedMetric = unifiedDlpMetric(praucNew,aucExist,adj,directed)`

### Additional Information

See the documentation in the headers of the respective functions (or type `help ` followed by the function name, e.g. `help dlpROCCurve` in the MATLAB command window) for more details on usage.

## Demo

A demo of the two separate evaluation metrics and the unified metric applied to a 17-year NIPS co-authorship data set is provided in the folder `NIPS_1-17`. First run the script `SimilarityLinkPredictionNips.m` to generate the link predictions for the Adamic-Adar and Katz link predictors, then run the script `CompareLinkPredictorsUnifiedNips.m` to compute the evaluation metrics. Table V(a) in the [paper](http://arxiv.org/abs/1607.07330) was generated using these two scripts.

## Reference

Junuthula, R. R., Xu, K. S., & Devabhaktuni, V. K. (2016). Evaluating link prediction accuracy on dynamic networks with added and removed edges. In Proceedings of the 9th IEEE International Conference on Social Computing and Networking (pp. 377–384). Retrieved from [http://arxiv.org/abs/1607.07330](http://arxiv.org/abs/1607.07330)

## License

Distributed with a BSD license; see `LICENSE.txt`