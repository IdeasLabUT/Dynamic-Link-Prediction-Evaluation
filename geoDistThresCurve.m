function [x,y,t,auc] = geoDistThresCurve(adj,predMat,geoDist,xcrit,ycrit, ...
    directed)
%geoDistThresCurve Compute dynamic link prediction threshold curve for
%                  potential links at specified geodesic distance
%   [x,y,t,auc] = geoDistThresCurve(adj,predMat,geoDist,xcrit,ycrit,directed)
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
%   geoDist - Geodesic distance of potential links to consider. Geodesic
%             distance of 1 denotes links that have previously been
%             observed, while higher distances denote new links. Geodesic
%             distance at time t is calculated with respect to the
%             cumulative adjacency matrix up to time t-1.
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
cumAdj = cumsum(adj,3);
cumAdj(cumAdj>0) = 1;

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

geoDistMask = false(n,n,tMax-1);
for t = 1:tMax-1
    distMat = distances(graph(cumAdj(:,:,t)));
    geoDistMask(:,:,t) = (distMat == geoDist);
end

adj = adj(:,:,2:end);
predMat = predMat(:,:,2:end);

bothMasks = activeMask & geoDistMask;
adjVect = adj(bothMasks);
predVect = predMat(bothMasks);
[x,y,t,auc] = perfcurve(adjVect,predVect,1,'xcrit',xcrit,'ycrit',ycrit);

end

