function [D_emd]=emd_den(D,co,srate)
%
% D is MxN matrix, which is the input dataset. M is number of trials, N is number of samples
% co is cut-off frequency in Hz
% srate is sampling frequency in Hz
%
% References:
%
% Huang NE, Shen Z, Long SR, Wu MC, Shih HH, Zheng Q, Yen N, Tung CC, and Liu HH.
% The empirical mode decomposition and the hilbert spectrum for nonlinear and non-stationary
% time series analysis. Proceedings of the Royal Society of London A, 454:903–95, 1998. doi:
% 10.1098/rspa.1998.0193
%
% Williams NJ, Nasuto SJ, and Saddy JD. Evaluation of empirical mode decomposition for eventrelated
% potential analysis. EURASIP Journal for Advances in Signal Processing, 2011:1–11,
% 2011. doi: 0.1155/2011/965237.

[M,N]=size(D);
D_emd=zeros(M,N);

for idx=1:M,

    % applying EMD
    
    imf=emd(D(idx,:));
    num_of_imfs=length(imf(:,1));

    % code for finding relevant IMFs

        for k=1:num_of_imfs,
    
        segment=imf(k,:)';
        p=powerspectrum(segment,srate);
    
        [c,index]=max(p(2,:));
            
            if p(1,index)<co,
        
            % building EMD-denoised single-trial
                
            D_emd(idx,:)=D_emd(idx,:)+imf(k,:);
                    
            end
           

        end
    
    display(idx);
    
end
   
end