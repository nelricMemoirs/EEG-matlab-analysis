clc; clear all; close all;


path = 'NewDataset/*.mat'
path2 = 'NewDataset/'
folder = dir(path);
[~,idx] = natsortfiles({folder.name})
folder = folder(idx);
% for j=3:length(folder)
%     [folder(j).name] = deal(strrep(folder(j).name,' ',''));
%    
% end
par='AF3';
fs=2*pi;
D=5; 
M=1;

for i=1:length(folder)
    filename = folder(i).name;
    raw_data = load(sprintf('%s%s',path2,filename),par);
    volt = raw_data.AF3 / 10e5
    newK = emd(volt);
    K=emd(raw_data.AF3);
        for d=1:D 
            y=K(d,:);
            z=newK(d,:);
            shan1 = entropy(z);
            shanNewM(i,M)=shan1;
            
            shan= entropy(y);
            shan2 = wentropy(y,'shannon');
            waveEntropy(i,M)=shan2;
%             N = numel(y);
%             maxH = entropy([1:N]/N);
            shanM(i,M)=shan;
            
            
%             Hscaled = shanM(i-2,M)/maxH;
            M=M+1;
            
        end  
        M=1;
        C = bsxfun(@rdivide, shanM, max(shanM));
        maxV = max(shanM(:));
        minV = min(shanM(:));
        Vscale   = shanM - minV / maxV;
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
%         Fs = 1000;            % Sampling frequency                    
%         T = 1/Fs;             % Sampling period       
%         L = 1536;             % Length of signal
%         t = (0:L-1)*T; 
%         Y = fft(raw_data.AF3);
%         P2 = abs(Y/L);
%         P1 = P2(1:L/2+1);
%         P1(2:end-1) = 2*P1(2:end-1);
%         f = Fs*(0:(L/2))/L;
%         
%         plot(f,P1) 
%         title('Single-Sided Amplitude Spectrum of X(t)')
%         xlabel('f (Hz)')
%         ylabel('|P1(f)|')
% %         mkdir('data',T);


        
end


