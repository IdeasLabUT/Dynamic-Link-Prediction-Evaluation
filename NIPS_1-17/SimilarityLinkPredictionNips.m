% Script to perform similarity-based link prediction on NIPS data set. This
% script needs to be run first before other scripts comparing link
% prediction accuracy can be used.

% Authors: Ruthwik R. Junuthula and Kevin S. Xu, 2016

dataFile = 'NipsAdj_17Years.mat';
resultsFile = 'SimilarityLinkPredictors_NIPS.mat';

katzWeight = 0.005;
katzMaxDist = 10;
ff = 0.5;   % Forgetting factor for exponentially-weighted moving average

%% Load adjacency matrices
disp('Loading adjacency matrices')
load(dataFile)
[n,~,tMax] = size(adj);

%% Run similarity-based link predictors
predMatAA = zeros(n,n,tMax);
predMatKatz = zeros(n,n,tMax);
% Link prediction scores considering cumulative graph of all previous
% snapshots
predMatAACum = zeros(n,n,tMax);
predMatKatzCum = zeros(n,n,tMax);
cumAdj = cumsum(adj,3);
cumAdj(cumAdj>0) = 1;
parfor t = 2:tMax
    disp(['Computing similarity-based predictions at t = ' int2str(t)])
    predMatAA(:,:,t) = predictLinksAA(adj(:,:,t-1));
    predMatKatz(:,:,t) = predictLinksKatz(adj(:,:,t-1),katzWeight,katzMaxDist);
    
    predMatAACum(:,:,t) = predictLinksAA(cumAdj(:,:,t-1));
    predMatKatzCum(:,:,t) = predictLinksKatz(cumAdj(:,:,t-1),katzWeight, ...
        katzMaxDist);
end

% Link prediction scores joint with connectivity
predMatAA_Adj = zeros(n,n,tMax);
predMatKatz_Adj = zeros(n,n,tMax);
maxSimAA = 0;
maxSimKatz = 0;
for t = 2:tMax
    maxSimAA = max(maxSimAA,max(max(predMatAA(:,:,t))));
    maxSimKatz = max(maxSimKatz,max(max(predMatKatz(:,:,t))));
    predMatAA_Adj(:,:,t) = predMatAA(:,:,t)./maxSimAA + adj(:,:,t-1);
    predMatKatz_Adj(:,:,t) = predMatKatz(:,:,t)./maxSimKatz + adj(:,:,t-1);
end

% Apply time series to similarity-based link predictors using only previous
% snapshot
predMatAA_TS = predMatAA;
predMatKatz_TS = predMatKatz;
predMatAA_Adj_TS = predMatAA_Adj;
predMatKatz_Adj_TS = predMatKatz_Adj;
for t = 3:tMax
    predMatAA_TS(:,:,t)  = ff*predMatAA_TS(:,:,t-1) ...
        + (1-ff)*predMatAA(:,:,t);
    predMatKatz_TS(:,:,t)= ff*predMatKatz_TS(:,:,t-1) ...
        + (1-ff)*predMatKatz(:,:,t);
    predMatAA_Adj_TS(:,:,t)  = ff*predMatAA_Adj_TS(:,:,t-1) ...
        + (1-ff)*predMatAA_Adj(:,:,t);
    predMatKatz_Adj_TS(:,:,t)= ff*predMatKatz_Adj_TS(:,:,t-1) ...
        + (1-ff)*predMatKatz_Adj(:,:,t);
end

%% Save results
save(resultsFile)
