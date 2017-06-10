function [fpr,tpr,thres,auc,adjVect,predVect] = dlpROCCurve(adj,predMat, ...
    links,directed)
%dlpROCCurve Compute ROC curve for dynamic link prediction
%   Wrapper function for dlpThresCurve() to specifically return a receiver
%   operating characteristic (ROC) curve
%
%   [fpr,tpr,thres,auc,adjVect,predVect] = dlpROCCurve(adj,predMat, ...
%       links,directed)
%
%   Inputs:
%   adj - 3-D array of graph adjacency matrices, where each slice along the
%         third dimension denotes the adjacency matrix at time t. Each
%         adjacency matrix is binary with no self-edges and can be directed,
%         i.e. w(i,j,t) = 1 denotes an edge from i to j at time t, and
%         w(i,j,t) = 0 denotes the absence of an edge from i to j at time t.
%   predMat - 3-D array of link prediction scores, where each slice along
%             third dimension denotes the predictions of edges and
%             non-edges at time t, i.e. predMat(:,:,t) denotes predictions
%             of adj(:,:,t).
%   links - String taking one of three values: 'all', 'new', or 'existing'
%           denoting the set of node pairs that the threshold curve is to
%           be computed over. 'new' denotes triplets (i,j,t) for which no
%           edge exists between i and j in any time prior to t. 'existing'
%           denotes triplets (i,j,t) for which at least one such edge
%           exists. 'all' considers at time t all node pairs for nodes
%           present in the network at any time prior to t.
%
%   Optional input:
%   directed - Boolean denoting whether the graph is directed. (Default:
%              false)
%
%   Outputs:
%   fpr - Vector of false positive rates for each threshold specified by thres.
%   tpr - Vector of true positive rates for each threshold specified by thres.
%   thres - Vector of thresholds applied to dynamic link prediction scores,
%           where thres(i) denotes the threshold that results in the values
%           fpr(i) and tpr(i).
%   auc - Area under the ROC curve computed by linear interpolation
%         between the points specified by (fpr(i),tpr(i)).
%   adjVect - Vector representation of adjacency matrix considering only
%             the node pairs specified by links.
%   predVect - Vector representation of link prediction scores considering
%              only the node pairs specified by links.

% Authors: Ruthwik R. Junuthula and Kevin S. Xu, 2016

[fpr,tpr,thres,auc,~,adjVect,predVect] = dlpThresCurve(adj,predMat,links, ...
    'FPR','TPR',directed);

end

