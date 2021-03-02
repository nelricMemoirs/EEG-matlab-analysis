clc; clear all; close all;

load Amin_T2.mat;

K=emd(AF4);
  
D=5 

M=1;
for d=1:D 
    
   y=K(d,:);   %ambil IMF ke-d
   
   
   
    %entropy tiap skala
    
shan= entropy(y);       
% reny=renyi_entro(y',2);   %Renyi entropy  q=2
% spec=FFT_entropy(y);
% % wave=compute_WE( y, 'db2', 7 );  %dari hasil DWT-Hjorth 
% % aprox=approx_entropy(2,0.15,y);
% % 
% % [e,A,B]=sampenc(y,2,0.15);
% % samp=e(2,1);
% perm=PE(y,6);    %referensi Arief--> multiscale permutation entropy
% tsa=Tsallis_entro(y',10);   %q =2 , referensi Acharya


shanM(1,M)=shan;
% renyM(1,M)=reny;
% specM(1,M)=spec;
% %   waveM(1,M)=wave;
% % aproxM(1,M)=aprox;
% % sampM(1,M)=samp;
% permM(1,M)=perm;
% tsaM(1,M)=tsa;
M=M+1;
end   
     

% Entro=[shanM renyM specM permM tsaM]; %,shanM,renyM ,specM ,waveM, aproxM, ,permM,tsaM, sampM ];


 