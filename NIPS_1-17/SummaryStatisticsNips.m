% Script to compute summary statistics on NIPS data set.

% Authors: Ruthwik R. Junuthula and Kevin S. Xu, 2016

dataFile = 'NipsAdj_17Years.mat';

directed = false;

%% Load data
disp('Loading data')
load(dataFile)
[n,~,tMax] = size(adj);

%% Compute mean number of edges and edge probability
node_existing = false(n,n,tMax-1);
cummulative_adj = zeros(n);
for i = 1:tMax-1
    cummulative_adj = cummulative_adj|adj(:,:,i);    % All the edges that have formed until time 'i'
    node_existing(:,:,i) = cummulative_adj;
end
node_new = ~node_existing;
 
nodeActive = isNodeActive(adj);
nodeActive = cumsum(nodeActive,2);
nodeActive(nodeActive > 0) = 1;

activeMask = false(n,n,tMax);
for t = 1:tMax
    activeMaskCurr = nodeActive(:,t)*nodeActive(:,t)';
    activeMaskCurr(diag(true(n,1))) = 0;
    activeMask(:,:,t) = activeMaskCurr;
    if directed == false
        activeMask(:,:,t) = tril(activeMask(:,:,t));
    end
end

nNodePairs = zeros(1,tMax);
nEdges = zeros(1,tMax);
for t = 1:tMax
    nNodePairs(t) = nnz(activeMask(:,:,t));
    nEdges(t) = nnz(adj(:,:,t));
    if directed == false
        nEdges(t) = nEdges(t)/2;
    end
end

fprintf('Total number of nodes: %i\n', nnz(nodeActive(:,end)))
fprintf('Mean number of edges: %f\n', mean(nEdges))
fprintf('Mean edge probability: %f\n', mean(nEdges./nNodePairs))

%% Compute mean new and previous edge probabilities
adj = adj(:,:,2:end);
newDens = zeros(1,tMax-1);
existingDens = zeros(1,tMax-1);

activeMask = activeMask(:,:,1:tMax-1);
activeMaskNew = node_new & activeMask;
activeMaskExisting = node_existing & activeMask;

for t = 1:tMax-1
    adjCurr = adj(:,:,t);
    newDens(t) = nnz(adjCurr(activeMaskNew(:,:,t)))/nnz(activeMaskNew(:,:,t));
    existingDens(t) = nnz(adjCurr(activeMaskExisting(:,:,t))) ...
        / nnz(activeMaskExisting(:,:,t));
end

fprintf('Mean new edge probability: %f\n', mean(newDens))
fprintf('Mean re-occurring edge probability: %f\n', mean(existingDens))
