clc; clear all; close all;
fituruji=[];

dataTableName=sprintf('PlotData.xlsx');
dataTrain=xlsread(dataTableName);



% train1 = dataTrain(1:21,1:end);
% train2 = dataTrain(27:47,1:end);
% trainX = [train1;train2];
% test1 = dataTrain(22:26, 1:end);
% test2 = dataTrain(48:52, 1:end);
% testX = [test1;test2];
% 
% trainX = trainX / max(trainX(:));
% testX = testX / max(testX(:));




% classTrain(1:21)=1;
% classTrain((21)+1:size(trainX,1))=2;
% classTrain=classTrain';

classTrain(1, 1: 0.5*(size(dataTrain, 1)))=1;
classTrain(1, 0.5*(size(dataTrain, 1))+1: size(dataTrain, 1))=2;
classTrain=classTrain';

Q = size(dataTrain, 1);
Q1 = floor(Q * 0.82);
Q2 = Q - Q1;
ind = randperm(Q);
ind1 = ind(1:Q1);
ind2 = ind(Q1 + (1:Q2));
x1 = dataTrain(ind1, :);
t1 = classTrain(ind1, :);
x2 = dataTrain(ind2, :);
t2 = classTrain(ind2, :);

raw_sep_D = x1(t1==1, :);
raw_sep_N = x1(t1==2, :);


% model = fitcsvm(trainX, classTrain);
% sv = model.SupportVectors;
% figure
% gscatter(trainX(:,1),trainX(:,2),classTrain)
% hold on
% plot(sv(:,1),sv(:,2),'ko','MarkerSize',10)
% legend('Dementia','Non-Dementia','Support Vector')
% hold off
% classTest(1:size(testX,1)/2)=1;
% classTest((size(testX,1)/2)+1:size(testX,1))=2;
% classTest=classTest';

% figure
% gscatter(trainX(:,2),trainX(:,1),classTrain);
% h = gca;
% lims = [h.XLim h.YLim]; % Extract the x and y axis limits
% title('{\bf Scatter Diagram}');
% xlabel('shannon X');
% ylabel('shannon Y');
% legend('Location','Northwest');

% for k=1:319
%     format long; 
%     x = 1:21;
%     sz = 25;
%     c = 'b';
%     scatter(x, trainX(1:21,k) + trainX(1:21,k+1), sz, c, 'filled');
%     hold on ;
% end
% figure;
% for k=1:320
%     format long; 
%     x = 1:21;
%     sz = 25;
%     c = 'c';
%     scatter(x, trainX(22:end,k), sz, c, 'filled');
%     hold on ;
% end
% 
[result]=multisvm(x1,t1,x2);

% model = fitcecoc(dataTrainX,groupTrain);
% 
% result = predict(model, dataTestX);
% akurasi=sum(result==groupTrain)/size(groupTrain,1)*100;

akurasi=sum(result==t2)/size(t2,1)*100;

for res=1:length(result)
    if result(res)==1
        resString{res}='stroke non dementia';
    else
        resString{res}='stroke dementia';
    end
end
resString=resString';
tabelHasil=[num2cell(result) resString];

    
        