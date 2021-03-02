clc; clear all; close all;
load 'NewDataset/subject 1.mat';

K=emd(AF3);
  

D=8;
for d=1:D 
    
   y=K(d,:);   %ambil IMF ke-d
   
   
   
    %entropy tiap skala
    
shan(1,d)= entropy(y);     
end;

m = 5;
subplot(6,1,1)
plot(AF3)
xlabel('Sinyal EEG (time(s))')
% ylim([-1500 1500]);
for i=1:m
z=num2str(i); 
subplot(m+1,1,i+1);
plot(K(i,:));
xlabel(['IMF', z]);
% ylim([-1500 1500]);
grid on;
end