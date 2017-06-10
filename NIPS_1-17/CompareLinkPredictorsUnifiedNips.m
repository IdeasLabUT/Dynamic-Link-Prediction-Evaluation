% Script to compare link predictors on NIPS data set with separate
% evaluation for prediction of new and previously observed edges, along
% with unified metric.

% Authors: Ruthwik R. Junuthula and Kevin S. Xu, 2016

sbmResultsFile = 'SBTM_NIPS.mat';
simLpResultsFile = 'SimilarityLinkPredictors_NIPS.mat';

directed = false;

%% Load SBM results
disp('Loading SBM results')
load(sbmResultsFile)

%% Load similarity-based link prediction results
disp('Loading similarity-based link prediction results')
load(simLpResultsFile)

%% Compare PRAUC on new edges
disp('Computing PRAUC for new edges')
[~,~,praucDsbm] = dlpPRCurve(adj,predMatDsbm,'new',directed);
fprintf('HM-SBM PRAUC: %.3g\n',praucDsbm);
[~,~,praucSbtm] = dlpPRCurve(adj,predMatSbtm,'new',directed);
fprintf('SBTM PRAUC: %.3g\n',praucSbtm);
[~,~,praucEwma] = dlpPRCurve(adj,predMatEwma,'new',directed);
fprintf('EWMA PRAUC: %.3g\n',praucEwma);
% [~,~,praucAA] = dlpPRCurve(adj,predMatAA,'new',directed);
% fprintf('Adamic-Adar PRAUC: %.3g\n',praucAA);
% [~,~,praucKatz] = dlpPRCurve(adj,predMatKatz,'new',directed);
% fprintf('Katz PRAUC: %.3g\n',praucKatz);
% [~,~,praucAACum] = dlpPRCurve(adj,predMatAACum,'new',directed);
% fprintf('Adamic-Adar Cum. PRAUC: %.3g\n',praucAACum);
% [~,~,praucKatzCum] = dlpPRCurve(adj,predMatKatzCum,'new',directed);
% fprintf('Katz Cum. PRAUC: %.3g\n',praucKatzCum);
[~,~,praucAA_TS] = dlpPRCurve(adj,predMatAA_TS,'new',directed);
fprintf('Adamic-Adar TS PRAUC: %.3g\n',praucAA_TS);
[~,~,praucKatz_TS] = dlpPRCurve(adj,predMatKatz_TS,'new',directed);
fprintf('Katz TS PRAUC: %.3g\n',praucKatz_TS);
% [~,~,praucAA_Adj_TS] = dlpPRCurve(adj,predMatAA_Adj_TS,'new',directed);
% fprintf('Adamic-Adar + Adj TS PRAUC: %.3g\n',praucAA_Adj_TS);
% [~,~,praucKatz_Adj_TS] = dlpPRCurve(adj,predMatKatz_Adj_TS,'new',directed);
% fprintf('Katz + Adj TS PRAUC: %.3g\n',praucKatz_Adj_TS);

%% Compare AUC on existing edges
disp('Computing AUC on existing edges')
[~,~,~,aucDsbm] = dlpROCCurve(adj,predMatDsbm,'existing',directed);
fprintf('HM-SBM AUC: %.3g\n',aucDsbm);
[~,~,~,aucSbtm] = dlpROCCurve(adj,predMatSbtm,'existing',directed);
fprintf('SBTM AUC: %.3g\n',aucSbtm);
[~,~,~,aucEwma] = dlpROCCurve(adj,predMatEwma,'existing',directed);
fprintf('EWMA AUC: %.3g\n',aucEwma);
% [~,~,~,aucAA] = dlpROCCurve(adj,predMatAA,'existing',directed);
% fprintf('Adamic-Adar AUC: %.3g\n',aucAA);
% [~,~,~,aucKatz] = dlpROCCurve(adj,predMatKatz,'existing',directed);
% fprintf('Katz AUC: %.3g\n',aucKatz);
% [~,~,~,aucAACum] = dlpROCCurve(adj,predMatAACum,'existing',directed);
% fprintf('Adamic-Adar Cum. AUC: %.3g\n',aucAACum);
% [~,~,~,aucKatzCum] = dlpROCCurve(adj,predMatKatzCum,'existing',directed);
% fprintf('Katz Cum. AUC: %.3g\n',aucKatzCum);
[~,~,~,aucAA_TS] = dlpROCCurve(adj,predMatAA_TS,'existing',directed);
fprintf('Adamic-Adar TS AUC: %.3g\n',aucAA_TS);
[~,~,~,aucKatz_TS] = dlpROCCurve(adj,predMatKatz_TS,'existing',directed);
fprintf('Katz TS AUC: %.3g\n',aucKatz_TS);
% [~,~,~,aucAA_Adj_TS] = dlpROCCurve(adj,predMatAA_Adj_TS,'existing',directed);
% fprintf('Adamic-Adar + Adj TS AUC: %.3g\n',aucAA_Adj_TS);
% [~,~,~,aucKatz_Adj_TS] = dlpROCCurve(adj,predMatKatz_Adj_TS,'existing', ...
%     directed);
% fprintf('Katz + Adj TS AUC: %.3g\n',aucKatz_Adj_TS);

%% Compute unified metric
disp('Computing unified metric')
unifiedDsbm = unifiedDlpMetric(praucDsbm,aucDsbm,adj,directed);
fprintf('HM-SBM unified: %.3g\n',unifiedDsbm);
unifiedSbtm = unifiedDlpMetric(praucSbtm,aucSbtm,adj);
fprintf('SBTM unified: %.3g\n',unifiedSbtm);
unifiedEwma = unifiedDlpMetric(praucEwma,aucEwma,adj);
fprintf('EWMA unified: %.3g\n',unifiedEwma);
% unifiedAA = unifiedDlpMetric(praucAA,aucAA,adj);
% fprintf('Adamic-Adar unified: %.3g\n',unifiedAA);
% unifiedKatz = unifiedDlpMetric(praucKatz,aucKatz,adj);
% fprintf('Katz unified: %.3g\n',unifiedKatz);
% unifiedAACum = unifiedDlpMetric(praucAACum,aucAACum,adj);
% fprintf('Adamic-Adar Cum. unified: %.3g\n',unifiedAACum);
% unifiedKatzCum = unifiedDlpMetric(praucKatzCum,aucKatzCum,adj);
% fprintf('Katz Cum. unified: %.3g\n',unifiedKatzCum);
unifiedAA_TS = unifiedDlpMetric(praucAA_TS,aucAA_TS,adj);
fprintf('Adamic-Adar TS unified: %.3g\n',unifiedAA_TS);
unifiedKatz_TS = unifiedDlpMetric(praucKatz_TS,aucKatz_TS,adj);
fprintf('Katz TS unified: %.3g\n',unifiedKatz_TS);
% unifiedAA_Adj_TS = unifiedDlpMetric(praucAA_Adj_TS,aucAA_Adj_TS,adj);
% fprintf('Adamic-Adar + Adj TS unified: %.3g\n',unifiedAA_Adj_TS);
% unifiedKatz_Adj_TS = unifiedDlpMetric(praucKatz_Adj_TS,aucKatz_Adj_TS, ...
%     adj);
% fprintf('Katz + Adj TS unified: %.3g\n',unifiedKatz_Adj_TS);
