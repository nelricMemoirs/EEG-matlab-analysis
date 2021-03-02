clc; clear all; close all;

dataTableName=sprintf('cobaFFt_shan.xlsx');
dataTrain=xlsread(dataTableName);




classTrain(1, 1: 0.5*(size(dataTrain, 1)))=1;
classTrain(1, 0.5*(size(dataTrain, 1))+1: size(dataTrain, 1))=2;
classTrain=classTrain';


Q = size(dataTrain, 1);
Q1 = floor(Q * 0.65);
Q2 = Q - Q1;
ind = randperm(Q);
ind1 = ind(1:Q1);
ind2 = ind(Q1 + (1:Q2));
x1 = dataTrain(ind1, :);
t1 = classTrain(ind1, :);
x2 = dataTrain(ind2, :);
t2 = classTrain(ind2, :);

figure
gscatter(x1(:,(1:2):9:320), x1(:,(5:6):9:320),t1)
xlabel('shannon Delta');
ylabel('shannon Theta');

raw_sep_D = x1(t1==1, :);
raw_sep_N = x1(t1==2, :);

figure
gscatter(raw_sep_D(1:15,(1:2):9:320), raw_sep_N(1:15,(5:6):9:320),t1)
xlabel('shannon Delta');
ylabel('shannon Theta');

sep_D = raw_sep_D(:, (1:2):9:320);
sep_D_2 = raw_sep_D(:, (5:6):9:320);
% sep_D_2 = sep_D_2';
sep_N = raw_sep_N(:, (1:2):9:320);
sep_N_2 = raw_sep_N(:, (5:6):9:320);
% sep_N_2 = sep_N_2';

% grnpop = mvnrnd(sep_D, eye(36));
% redpop = mvnrnd(sep_N, eye(36));

% figure
% plot(grnpop(:,1:18),grnpop(:,19:end),'go')
% hold on
% plot(redpop(:,1:18),redpop(:,19:end),'ro')
% hold off
% 
% D_pts = zeros(100, 36);
% N_pts = zeros(100, 36);
% D_pts_2 = zeros(500, 36);
% N_pts_2 = zeros(500, 36);
% 
% for i = 1:100
%     D_pts(i,:) = mvnrnd(grnpop(randi(10),:),eye(36)*0.02);
%     N_pts(i,:) = mvnrnd(redpop(randi(10),:),eye(36)*0.02);
% end
% 
% figure
% plot(D_pts(:,1:18),D_pts(:,19:end),'go')
% hold on
% plot(N_pts(:,1:18),N_pts(:,19:end),'ro')
% hold off

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


SVMModel = fitcsvm(x1,t1,'IterationLimit',50,'Verbose',1,'NumPrint',5, 'KernelFunction','linear');
DidConverge = SVMModel.ConvergenceInfo.Converged;
Reason = SVMModel.ConvergenceInfo.ReasonForConvergence;
partialLoss = resubLoss(SVMModel);

UpdatedSVMModel = resume(SVMModel,150, 'NumPrint',50);
DidConverge = UpdatedSVMModel.ConvergenceInfo.Converged;
updatedLoss = resubLoss(UpdatedSVMModel);

[label,score] = predict(UpdatedSVMModel,x2);