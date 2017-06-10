function unifiedMetric = unifiedDlpMetric(praucNew,aucExist,adj,directed)
%unifiedDlpMetric Compute unified dynamic link prediction metric
%   unifiedDlpMetric(praucNew,aucExist,adj) computes a unified dynamic link
%   prediction metric using the geometric mean of the PRAUC for new link
%   prediction and the AUC for previously observed link prediction, both
%   after subtracting the baseline metrics for a random predictor.
%
%   Inputs:
%   praucNew - PRAUC of predictor for new link prediction. This can be
%              computed using the dlpPRCurve function by passing in 'new'
%              for the links input.
%   aucExist - AUC of predictor for previously observed link prediction.
%              This can be computed using the dlphROCCurve function by
%              passing in 'existing' for the links input.
%   adj - 3-D array of graph adjacency matrices, where each slice along the
%         third dimension denotes the adjacency matrix at time t. Each
%         adjacency matrix is binary with no self-edges and can be directed,
%         i.e. w(i,j,t) = 1 denotes an edge from i to j at time t, and
%         w(i,j,t) = 0 denotes the absence of an edge from i to j at time
%         t. The adjacency matrix is used only to compute the total number
%         of edges and node pairs, which are used to compute the baseline
%         PRAUC for new link prediction.
%
%   Optional input:
%   directed - Boolean denoting whether the graph is directed. (Default:
%              false)
%
%   Output:
%   unifiedMetric - Geometric mean of baseline corrected PRAUC for new link
%                   prediction and AUC for previously observed link
%                   prediction, which provides a balanced evaluation of
%                   dynamic link prediction accuracy.

% Authors: Ruthwik R. Junuthula and Kevin S. Xu, 2016

if nargin < 4
    directed = false;
end

[n,~,tMax] = size(adj);
% Baseline PRAUC is obtained by computing PRAUC using all ones predictor
% and is equal to total number of new edges divided by total number of new
% edge node pairs
[~,~,baselinePrauc] = dlpPRCurve(adj,ones(n,n,tMax),'new',directed);

praucNewAboveBaseline = (praucNew - baselinePrauc) / (1 - baselinePrauc);
aucExistAboveBaseline = 2*(aucExist - 0.5);
unifiedMetric = sqrt(praucNewAboveBaseline * aucExistAboveBaseline);

end

