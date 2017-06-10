% Script to compare link predictors on NIPS data set using either all node
% pairs, only node pairs corresponding to new edges, or only node pairs
% corresponding to previously observed edges.

% Authors: Ruthwik R. Junuthula and Kevin S. Xu, 2016

sbmResultsFile = 'SBTM_NIPS.mat';
simLpResultsFile = 'SimilarityLinkPredictors_NIPS.mat';

links = 'all';  % Can take values 'all', 'new', or 'existing'
directed = false;

%% Load SBM results
disp('Loading SBM results')
load(sbmResultsFile)

%% Load similarity-based link prediction results
disp('Loading similarity-based link prediction results')
load(simLpResultsFile)

%% Compare link prediction accuracy
disp('Computing ROC curves')
figure(1)
[x,y,thres,auc] = dlpROCCurve(adj,predMatDsbm,links,directed);
plot(x,y)
hold on
fprintf('HM-SBM AUC: %.3g\n',auc);
[x,y,thres,auc] = dlpROCCurve(adj,predMatSbtm,links,directed);
plot(x,y)
fprintf('SBTM AUC: %.3g\n',auc);
[x,y,thres,auc] = dlpROCCurve(adj,predMatEwma,links,directed);
plot(x,y)
fprintf('EWMA AUC: %.3g\n',auc);
% [x,y,thres,auc] = dlpROCCurve(adj,predMatAA,links,directed);
% plot(x,y)
% fprintf('Adamic-Adar AUC: %.3g\n',auc);
% [x,y,thres,auc] = dlpROCCurve(adj,predMatKatz,links,directed);
% plot(x,y)
% fprintf('Katz AUC: %.3g\n',auc);
% [x,y,thres,auc] = dlpROCCurve(adj,predMatAACum,links,directed);
% plot(x,y)
% fprintf('Adamic-Adar Cum. AUC: %.3g\n',auc);
% [x,y,thres,auc] = dlpROCCurve(adj,predMatKatzCum,links,directed);
% plot(x,y)
% fprintf('Katz Cum. AUC: %.3g\n',auc);
[x,y,thres,auc,adjVectAA_TS,predVectAA_TS] = dlpROCCurve(adj,predMatAA_TS,links,directed);
plot(x,y)
% hold on
fprintf('Adamic-Adar TS AUC: %.3g\n',auc);
[x,y,thres,auc,adjVectKatz_TS,predVectKatz_TS] = dlpROCCurve(adj,predMatKatz_TS,links,directed);
plot(x,y)
fprintf('Katz TS AUC: %.3g\n',auc);
[x,y,thres,auc] = dlpROCCurve(adj,predMatAA_Adj_TS,links,directed);
plot(x,y)
fprintf('Adamic-Adar + Adj TS AUC: %.3g\n',auc);
[x,y,thres,auc] = dlpROCCurve(adj,predMatKatz_Adj_TS,links,directed);
plot(x,y)
fprintf('Katz + Adj TS AUC: %.3g\n',auc);
hold off
% legend('HM-SBM','SBTM','EWMA','Adamic-Adar','Katz','Adamic-Adar Cum.', ...
%     'Katz Cum.', 'Adamic-Adar TS','Katz TS','Adamic-Adar + Adj TS', ...
%     'Katz + Adj TS','location','best')
legend('HM-SBM','SBTM','EWMA','Adamic-Adar TS','Katz TS', ...
    'Adamic-Adar + Adj TS','Katz + Adj TS','location','best')
% legend('Adamic-Adar TS','Katz TS','location','best')

disp('Computing PR curves')
figure(2)
[x,y,auc,~,~,maxF1Dsbm] = dlpPRCurve(adj,predMatDsbm,links,directed);
plot(x,y)
hold on
fprintf('HM-SBM PRAUC: %.3g\n',auc);
[x,y,auc,~,~,maxF1Sbtm] = dlpPRCurve(adj,predMatSbtm,links,directed);
plot(x,y)
fprintf('SBTM PRAUC: %.3g\n',auc);
[x,y,auc,~,~,maxF1Ewma] = dlpPRCurve(adj,predMatEwma,links,directed);
plot(x,y)
fprintf('EWMA PRAUC: %.3g\n',auc);
% [x,y,auc] = dlpPRCurve(adj,predMatAA,links,directed);
% plot(x,y)
% fprintf('Adamic-Adar PRAUC: %.3g\n',auc);
% [x,y,auc] = dlpPRCurve(adj,predMatKatz,links,directed);
% plot(x,y)
% fprintf('Katz PRAUC: %.3g\n',auc);
% [x,y,auc] = dlpPRCurve(adj,predMatAACum,links,directed);
% plot(x,y)
% fprintf('Adamic-Adar Cum. PRAUC: %.3g\n',auc);
% [x,y,auc] = dlpPRCurve(adj,predMatKatzCum,links,directed);
% plot(x,y)
% fprintf('Katz Cum. PRAUC: %.3g\n',auc);
[x,y,auc,~,~,maxF1AA_TS] = dlpPRCurve(adj,predMatAA_TS,links,directed);
plot(x,y)
% hold on
fprintf('Adamic-Adar TS PRAUC: %.3g\n',auc);
[x,y,auc,~,~,maxF1Katz_TS] = dlpPRCurve(adj,predMatKatz_TS,links,directed);
plot(x,y)
fprintf('Katz TS PRAUC: %.3g\n',auc);
[x,y,auc,~,~,maxF1AA_Adj_TS] = dlpPRCurve(adj,predMatAA_Adj_TS,links, ...
    directed);
plot(x,y)
fprintf('Adamic-Adar + Adj TS PRAUC: %.3g\n',auc);
[x,y,auc,~,~,maxF1Katz_Adj_TS] = dlpPRCurve(adj,predMatKatz_Adj_TS,links, ...
    directed);
plot(x,y)
fprintf('Katz + Adj TS PRAUC: %.3g\n',auc);
hold off
% legend('HM-SBM','SBTM','EWMA','Adamic-Adar','Katz','Adamic-Adar Cum.', ...
%     'Katz Cum.', 'Adamic-Adar TS','Katz TS','Adamic-Adar + Adj TS', ...
%     'Katz + Adj TS','location','best')
legend('HM-SBM','SBTM','EWMA','Adamic-Adar TS','Katz TS', ...
    'Adamic-Adar + Adj TS','Katz + Adj TS','location','best')
% legend('Adamic-Adar TS','Katz TS','location','best')

fprintf('HM-SBM max. F1-score: %.3g\n',maxF1Dsbm);
fprintf('SBTM max. F1-score: %.3g\n',maxF1Sbtm);
fprintf('EWMA max. F1-score: %.3g\n',maxF1Ewma);
fprintf('Adamic-Adar TS max. F1-score: %.3g\n',maxF1AA_TS);
fprintf('Katz TS max. F1-score: %.3g\n',maxF1Katz_TS);
fprintf('Adamic-Adar + Adj TS max. F1-score: %.3g\n',maxF1AA_Adj_TS);
fprintf('Katz TS + Adj max. F1-score: %.3g\n',maxF1Katz_Adj_TS);
