function [x,y,t,auc,nPos,adjVect,predVect] = dlpThresCurve(adj,predMat, ...
    links,xcrit,ycrit,directed)
%dlpThresCurve Compute threshold curve for dynamic link prediction
%   [x,y,t,auc,nPos,adjVect,predVect] = dlpThresCurve(adj,predMat, ...
%       links,xcrit,ycrit,directed)
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
%         between the points specified by (x(i),y(i)). Note that this is
%         not an accurate way to estimate the area under the
%         precision-recall curve! Use dlpPRCurve() instead.
%   nPos - Total number of edges in the dynamic network summed over all
%          time steps.
%   adjVect - Vector representation of adjacency matrix considering only
%             the node pairs specified by links.
%   predVect - Vector representation of link prediction scores considering
%              only the node pairs specified by links.

% Authors: Ruthwik R. Junuthula and Kevin S. Xu, 2016

if nargin < 4
    xcrit = 'FPR';
    ycrit = 'TPR';
    directed = false;
end

[n,~,tMax] = size(adj);

cumAdj = cumsum(adj,3);
cumAdj(cumAdj>0) = 1;
nodeExisting = logical(cumAdj(:,:,1:tMax-1));
 
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

adj = adj(:,:,2:end);
predMat = predMat(:,:,2:end);

if strcmp(links,'new')
    nodeNew = ~nodeExisting;
    activeMask = nodeNew & activeMask;
elseif strcmp(links,'existing')
    activeMask = nodeExisting & activeMask;   
end

adjVect = adj(activeMask);
predVect = predMat(activeMask);
[x,y,t,auc] = perfcurve(adjVect,predVect,1,'xcrit',xcrit,'ycrit',ycrit);

nPos = sum(adjVect);

