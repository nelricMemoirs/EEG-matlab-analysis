clc; clear all; close all;

dataTableName=sprintf('cobaFFt_shan.xlsx');
dataTrain=xlsread(dataTableName);


rng default;

classTrain(1: 0.5*(size(dataTrain, 1)))='D';
classTrain(0.5*(size(dataTrain, 1))+1: size(dataTrain, 1))='N';
classTrain = classTrain';




% Q = size(dataTrain, 1);
% Q1 = floor(Q * 0.80);
% Q2 = Q - Q1;
% ind = randperm(Q);
% ind1 = ind(1:Q1);
% ind2 = ind(Q1 + (1:Q2));
% x1 = dataTrain(ind1, :);
% t1 = classTrain(ind1, :);
% x2 = dataTrain(ind2, :);
% t2 = classTrain(ind2, :);


c = cvpartition(52,'KFold',10);

opts = struct('Optimizer','bayesopt','ShowPlots',true,'CVPartition',c,...
    'AcquisitionFunctionName','expected-improvement-plus');
svmmod = fitcsvm(dataTrain,classTrain,'KernelFunction','rbf',...
    'OptimizeHyperparameters','auto','HyperparameterOptimizationOptions',opts);

lossnew = kfoldLoss(fitcsvm(dataTrain,classTrain,'CVPartition',c,'KernelFunction','rbf',...
    'BoxConstraint',svmmod.HyperparameterOptimizationResults.XAtMinObjective.BoxConstraint,...
    'KernelScale',svmmod.HyperparameterOptimizationResults.XAtMinObjective.KernelScale));

% SVMModel = fitcsvm(x1,t1,'IterationLimit',100,'Verbose',1,'NumPrint',50);
DidConverge = svmmod.ConvergenceInfo.Converged;
Reason = svmmod.ConvergenceInfo.ReasonForConvergence;
partialLoss = resubLoss(svmmod);

% UpdatedSVMModel = resume(svmmod,1500, 'NumPrint',250);
% DidConverge = UpdatedSVMModel.ConvergenceInfo.Converged;
% updatedLoss = resubLoss(UpdatedSVMModel);