function [recall,precision,prauc,truePos,falsePos,maxF1] = dlpPRCurve(adj, ...
    predMat,links,directed)
%dlpPRCurve Compute precision-recall (PR) curve for dynamic link prediction
%   [recall,precision,prauc,truePos,falsePos,maxF1] = dlpPRCurve(adj, ...
%       predMat,links,directed)
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
%   recall - Vector of recall values for varying thresholds of link
%            prediction scores.
%   precision - Vector of precision values for varying thresholds of link
%               prediction scores.
%   prauc - Area under the precision-recall curve computed using the
%           proper approach described by Davis & Goadrich (2006) rather
%           than linear interpolation.
%   truePos - Total number of true positive predictions summed over all
%             time steps.
%   falsePos - Total number of false positive predictions summed over all
%              time steps.
%   maxF1 - Maximum F1-score (harmonic mean of precision and recall) over
%           entire precision-recall curve.

% Authors: Ruthwik R. Junuthula and Kevin S. Xu, 2016
% Reference:
% Davis, J., & Goadrich, M. (2006). The relationship between Precision-Recall
%   and ROC curves. In Proceedings of the 23rd International Conference on
%   Machine Learning (pp. 233–240). http://doi.org/10.1145/1143844.1143874

if nargin < 4
    directed = false;
end

[truePos,falsePos,~,~,nPos] = dlpThresCurve(adj,predMat,links,'TP','FP', ...
    directed);

idx = 1;
while idx < length(truePos)
    if truePos(idx+1) - truePos(idx) > 1
        % Linearly false positives interpolate between true positive values
        truePosInterp = (truePos(idx):truePos(idx+1))';
        falsePosInterp = linspace(falsePos(idx),falsePos(idx+1), ...
            length(truePosInterp))';
        truePos = [truePos(1:idx-1); truePosInterp; truePos(idx+2:end)];
        falsePos = [falsePos(1:idx-1); falsePosInterp; falsePos(idx+2:end)];
        idx = idx + length(truePosInterp) - 1;
    else
        idx = idx + 1;
    end
end

% Compute precision and recall for all points
precision = truePos ./ (truePos + falsePos);
recall = truePos ./ nPos;

prauc = trapz(recall(2:end),precision(2:end));
f1Score = 2 .* precision .* recall ./ (precision + recall);
maxF1 = max(f1Score);

end
