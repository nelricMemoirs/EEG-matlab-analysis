clc;
clear all;
close all;


%Ngitung jumlah file XLSX di folder
% Jumlah_XLSX = size(dir(['D:\BISMILLAH TUGAS AKHIR\TUGAS AKHIR\RESPONDENQ\Alevtina T EEG\ALEVTINA XLS RAPIH', '/*.xlsx']),1);

% %Proses gabungin
% Matrix_gabung_3D = zeros(1500,18,3);
% for i=2:Jumlah_XLSX+1
%     index = i-1;
%     Matrix_gabung = [];
%     temporary_name = ['alevtina',int2str(i),'.xlsx'];
%     [num] = xlsread(temporary_name);
%     jumlah_baris = size(num,1);
%     Matrix_gabung = [Matrix_gabung;num];
%     Matrix_gabung_3D(:,:,index) = Matrix_gabung;
%     
% end

data1=xlsread('PlotData.xlsx');
% data2=xlsread('alevtina3.xlsx','D:D');
% data3=xlsread('alevtina3.xlsx','E:E');
% data4=xlsread('alevtina3.xlsx','F:F');
% data5=xlsread('alevtina3.xlsx','G:G');
% data6=xlsread('alevtina3.xlsx','H:H');
% data7=xlsread('alevtina3.xlsx','M:M');
% data8=xlsread('alevtina3.xlsx','N:N');
% data9=xlsread('alevtina3.xlsx','O:O');
% data10=xlsread('alevtina3.xlsx','P:P');
% alldata=[data1 data2 data3 data4 data5 data6 data7 data8 data9 data10]

% butterworth filter 8,12 mean alpha, 100 frek sampling, 4 orde filter.
H1 = Bandpass_Butter(8,12,100,4)

% figure(1);
% surf(Matrix_gabung_3D(:,:,1),Matrix_gabung_3D(:,:,2),Matrix_gabung_3D(:,:,3));
% colormap(summer);
% shading interp;
% figure(2)
% plot(Matrix_gabung_3D(:,:,1));
% Matrix_gabung_3D(:,:,2),Matrix_gabung_3D(:,:,3));
claen = filter(H1,data1);

% figure(3)
% plot(claen);

numSelCh = 1;
[SelCh] = spatial_neuro (claen, numSelCh)
% [SelCh1] = spatial_neuro (claen(:,:,1), numSelCh)
% [SelCh2] = spatial_neuro (claen(:,:,2), numSelCh)
% [SelCh3] = spatial_neuro (claen(:,:,3), numSelCh)


