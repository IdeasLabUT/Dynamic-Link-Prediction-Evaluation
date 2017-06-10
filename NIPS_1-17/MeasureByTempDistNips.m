% Script to evaluate link prediction accuracy on NIPS data set by temporal
% distance (how long since edge has been previously observed) of node pair.

% Authors: Ruthwik R. Junuthula and Kevin S. Xu, 2016

sbmResultsFile = 'SBTM_NIPS.mat';
simLpResultsFile = 'SimilarityLinkPredictors_NIPS.mat';

maxDist = 8;
xcrit = 'reca';
ycrit = 'prec';

%% Load SBM results
disp('Loading SBM results')
load(sbmResultsFile)

%% Load similarity-based link prediction results
disp('Loading similarity-based link prediction results')
load(simLpResultsFile)

%% Compute and plot measure by temporal distance
measByDist = zeros(1,maxDist);
for dist = 1:maxDist
    disp(['Computing measure for distance ' int2str(dist)])
    [~,~,~,measByDist(dist)] = tempDistThresCurve(adj,predMatSbtm,dist, ...
        xcrit,ycrit,false);
end
disp('Computing measure for all distances')
[~,~,~,measAllDist] = dlpThresCurve(adj,predMatSbtm,'existing',xcrit,ycrit, ...
    false);

plot(1:maxDist,measByDist,1:maxDist,measAllDist*ones(1,maxDist),'--')
