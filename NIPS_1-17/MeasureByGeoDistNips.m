% Script to evaluate link prediction accuracy on NIPS data set by geodesic
% distance of node pair.

% Authors: Ruthwik R. Junuthula and Kevin S. Xu, 2016

sbmResultsFile = 'SBTM_NIPS.mat';
simLpResultsFile = 'SimilarityLinkPredictors_NIPS.mat';

maxDist = 8;
xcrit = 'fpr';
ycrit = 'tpr';

%% Load SBM results
disp('Loading SBM results')
load(sbmResultsFile)

%% Load similarity-based link prediction results
disp('Loading similarity-based link prediction results')
load(simLpResultsFile)

%% Compute and plot measure by geodesic distance
measByDist = zeros(1,maxDist);
for dist = 2:maxDist
    disp(['Computing measure for distance ' int2str(dist)])
    [~,~,~,measByDist(dist)] = geoDistThresCurve(adj,predMatSbtm,dist, ...
        xcrit,ycrit,false);
end
disp('Computing measure for all distances')
[~,~,~,measAllDist] = dlpThresCurve(adj,predMatSbtm,'new',xcrit,ycrit,false);

plot(2:maxDist,measByDist(2:end),2:maxDist,measAllDist*ones(1,maxDist-1),'--')