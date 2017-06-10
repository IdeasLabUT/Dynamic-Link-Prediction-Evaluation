function [x,y,t,auc] = tempDistThresCurve(adj,predMat,tempDist,xcrit,ycrit, ...
    directed)
%tempDistThresCurve Compute dynamic link prediction threshold curve for
%                   potential links at specified temporal distance
%   [x,y,t,auc] = tempDistThresCurve(adj,predMat,tempDist,xcrit,ycrit, ...
%      directed)
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
%   tempDist - Temporal distance of potential links to consider. Temporal
%              distance of 1 denotes potential links that were observed in
%              the previous snapshot, temporal distance of 2 denotes
%              potential links that were last observed 2 snapshots ago,
%              etc.
%
%   Optional inputs:
%   xcrit - String denoting the criterion for the x axis. This string is
%           passed to the perfcurve() function in the Statistics and
%           Machine Learning Toolbox. (Default: 'FPR' for false positive
%           rate)
%   ycrit - String denoting the criterion for the y axis. (Default: 'TPR'
%           for true positive rate)
%   directed - Boolean denoting whether the graph is directed. (Default:
%              false)
%
%   Outputs:
%   x - Vector of x axis values for criterion specified by xcrit.
%   y - Vector of y axis values for criterion specified by ycrit.
%   t - Vector of thresholds applied to dynamic link prediction scores,
%       where t(i) denotes the threshold that results in the values x(i)
%       and y(i).
%   auc - Area under the threshold curve computed by linear interpolation
%         between the points specified by (x(i),y(i)).

% Authors: Ruthwik R. Junuthula and Kevin S. Xu, 2016
if nargin < 4
    xcrit = 'FPR';
    ycrit = 'TPR';
    directed = false;
end

[n,~,tMax] = size(adj);
nodeActive = isNodeActive(adj);
nodeActive = cumsum(nodeActive,2);
nodeActive(nodeActive > 0) = 1;

activeMask = false(n,n,tMax-1);
for t = 1:tMax-1
    activeMaskCurr = nodeActive(:,t)*nodeActive(:,t)';
    activeMaskCurr(diag(true(n,1))) = 0;
    activeMask(:,:,t) = activeMaskCurr;
    if directed == false
        activeMask(:,:,t) = tril(activeMask(:,:,t));
    end
end

cumAdj = cumsum(adj(:,:,1:tMax-1),3);
cumAdj(cumAdj>1) = 1;
tempDistMask = false(n,n,tMax-1);

for t= tempDist+1:tMax-1    
    tempDistMask(:,:,t) = cumAdj(:,:,t-tempDist);
end

adj = adj(:,:,2:end);
predMat = predMat(:,:,2:end);

bothMasks = activeMask & tempDistMask;
adjVect = adj(bothMasks);
predVect = predMat(bothMasks);
[x,y,t,auc] = perfcurve(adjVect,predVect,1,'xcrit',xcrit,'ycrit',ycrit);

end