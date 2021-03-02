clear all
fitur_latih = xlsread('PlotDataPCA.xlsx');

fitur = fitur_latih(:,2:end);
label = fitur_latih(:,1);

fiturLatih = fitur(1:2:end);
fiturLatih=reshape(fiturLatih,[size(fitur,1)/2,size(fitur,2)]);
fiturUji = fitur(2:2:end);
fiturUji=reshape(fiturUji,[size(fitur,1)/2,size(fitur,2)]);
labelLatih = label(1:2:end);
labelUji = label(2:2:end)

c = fitcknn(fiturLatih,labelLatih,'NumNeighbors',9,...
    'NSMethod','exhaustive','Distance','euclidean',...
    'Standardize',1); 

[class,score]=predict(c,fiturUji);

akurasi = sum(class(:,1)==labelUji)/numel(labelUji)*100