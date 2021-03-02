clc; clear all; close all;

dataTableName=sprintf('cobaFFt_shan.xlsx');
dataTrain=xlsread(dataTableName);



rng(1234);
classTrain(1, 1: 0.5*(size(dataTrain, 1)))='D';
classTrain(1, 0.5*(size(dataTrain, 1))+1: size(dataTrain, 1))='N';
classTrain=classTrain';

Q = size(dataTrain, 1);
Q1 = floor(Q * 0.70);
Q2 = Q - Q1;
ind = randperm(Q);
ind1 = ind(1:Q1);
ind2 = ind(Q1 + (1:Q2));
x1 = dataTrain(ind1, :);
t1 = classTrain(ind1, :);
x2 = dataTrain(ind2, :);
t2 = classTrain(ind2, :);

figure
gscatter(mean(x1(:,(1:2):9:320), 2),mean(x1(:,(5:6):9:320), 2),t1)
xlabel('shannon Delta');
ylabel('shannon Theta');

raw_sep_D = x1(t1=='D', :);
raw_sep_N = x1(t1=='N', :);

sep_D = mean(raw_sep_D(:, (1:2):9:320));
sep_D_2 = std(raw_sep_D(:, (5:6):9:320));
% sep_D_2 = sep_D_2';
sep_N = mean(raw_sep_N(:, (1:2):9:320));
sep_N_2 = std(raw_sep_N(:, (5:6):9:320));
% sep_N_2 = sep_N_2';



grnpop = mvnrnd(sep_D,eye(36),10);
redpop = mvnrnd(sep_N,eye(36),10);
grnpop_2 = mvnrnd(sep_D_2,eye(36),10);
redpop_2 = mvnrnd(sep_N_2,eye(36),10);

figure
plot(grnpop(:,1:18),grnpop(:,19:end),'go')
hold on
plot(redpop(:,1:18),redpop(:,19:end),'ro')
hold off

% 
% figure
% plot(grnpop_2(:,1:18),grnpop_2(:,19:end),'go')
% hold on
% plot(redpop_2(:,1:18),redpop_2(:,19:end),'ro')
% hold off


D_pts = zeros(50, 36);
N_pts = zeros(50, 36);
D_pts_2 = zeros(50, 36);
N_pts_2 = zeros(50, 36);

for i = 1:50
    D_pts(i,:) = mvnrnd(grnpop(randi(10),:),eye(36)*0.02);
    N_pts(i,:) = mvnrnd(redpop(randi(10),:),eye(36)*0.02);
    D_pts_2(i,:) = mvnrnd(grnpop_2(randi(10),:),eye(36)*0.02);
    N_pts_2(i,:) = mvnrnd(redpop_2(randi(10),:),eye(36)*0.02);
end

figure
plot(D_pts(:,1:18),D_pts(:,19:end),'go')
hold on
plot(N_pts(:,1:18),N_pts(:,19:end),'ro')
hold off
% 
% figure
% plot(D_pts_2(:,1:18),D_pts_2(:,19:end),'go');
% hold on
% plot(N_pts_2(:,1:18),N_pts_2(:,19:end),'ro')
% hold off

cdata = [D_pts;N_pts];
cdata = abs(cdata);

grp = ones(100,1);
% Green label 1, red label -1
grp(51:100) = -1;

c = cvpartition(100,'KFold',15);

opts = struct('Optimizer','bayesopt','ShowPlots',true,'CVPartition',c,...
    'AcquisitionFunctionName','expected-improvement-plus');
svmmod = fitcsvm(cdata,grp,'KernelFunction','rbf',...
    'OptimizeHyperparameters','auto','HyperparameterOptimizationOptions',opts);

lossnew = kfoldLoss(fitcsvm(cdata,grp,'CVPartition',c,'KernelFunction','rbf',...
    'BoxConstraint',svmmod.HyperparameterOptimizationResults.XAtMinObjective.BoxConstraint,...
    'KernelScale',svmmod.HyperparameterOptimizationResults.XAtMinObjective.KernelScale));

DidConverge = svmmod.ConvergenceInfo.Converged;
Reason = svmmod.ConvergenceInfo.ReasonForConvergence;
partialLoss = resubLoss(svmmod);
[label,score] = predict(svmmod,x2);
% for i = 1:500
%     D_pts(i,:) = mvnrnd(sep_D(randi(17),:),eye(1)*0.02);
%     N_pts(i,:) = mvnrnd(sep_N(randi(19),:),eye(1)*0.02);
%     D_pts_2(i,:) = mvnrnd(sep_D_2(randi(17),:),eye(1)*0.02);
%     N_pts_2(i,:) = mvnrnd(sep_N_2(randi(19),:),eye(1)*0.02);
% end
% figure
% plot(D_pts(:,1),D_pts_2(:,1),'go')
% hold on
% plot(N_pts(:,1),N_pts_2(:,1),'ro')
% hold off

% rng(1234);
% SVMModel = fitcsvm(x1,t1,'IterationLimit',100,'Verbose',1,'NumPrint',50);
% DidConverge = SVMModel.ConvergenceInfo.Converged;
% Reason = SVMModel.ConvergenceInfo.ReasonForConvergence;
% partialLoss = resubLoss(SVMModel);
% 
% UpdatedSVMModel = resume(SVMModel,1500, 'NumPrint',250);
% DidConverge = UpdatedSVMModel.ConvergenceInfo.Converged;
% updatedLoss = resubLoss(UpdatedSVMModel);