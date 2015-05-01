function [model,hs,ps] = learnClassifier(X,Y)

% num_1s = sum(Y==1);
% num_2s = sum(Y==2);
% data_wts = zeros(size(Y,1),1);
% data_wts(Y==1) = 0.1/num_1s;
% data_wts(Y==2) = 0.9/num_2s;
addpath(genpath('pdollar_toolbox'))
forest_params.M = 10;
forest_params.H = 2;
forest_params.N1 = round(size(X,1)*0.2);
forest_params.F1 = 10;
forest_params.minCount = 2;
forest_params.minChild = 1;
forest_params.maxDepth = 10;
% forest_params.dWts = data_wts';

X_ = full(X);

model = forestTrain(single(X_),Y,forest_params);
save('treeModel.mat','model');
% load treeModel.mat
[hs,ps]=forestApply(single(X_),model,[],[],[]);
end