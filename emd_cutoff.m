function DP=emd_cutoff(D,maxf,srate)
%
% D is MxN input dataset, M is number of trials, N is the number of samples
% maxf is the highest frequency at which to explore denoising performance
% srate is the sampling frequency in Hz
%
% References:
%
% Salvador S and Chan P. Determining the number of clusters/segments in hierarchical clustering/
% segmentation algorithms. November 2004.
%
% Huang NE, Shen Z, Long SR, Wu MC, Shih HH, Zheng Q, Yen N, Tung CC, and Liu HH.
% The empirical mode decomposition and the hilbert spectrum for nonlinear and non-stationary
% time series analysis. Proceedings of the Royal Society of London A, 454:903–95, 1998. doi:
% 10.1098/rspa.1998.0193
%
% Williams NJ, Nasuto SJ, and Saddy JD. Evaluation of empirical mode decomposition for eventrelated
% potential analysis. EURASIP Journal for Advances in Signal Processing, 2011:1–11,
% 2011. doi: 0.1155/2011/965237. 

DP=zeros(maxf,3);

for co=1:maxf,

    D_emd=emd_den(D,co,srate);          % EMD-denoising at given cut-off
       
    NR=(mean(var(D_emd')))^-1;          % measure of noise reduction
    SR=(var(mean(D_emd))/var(mean(D))); % measure of signal retention
    DP(co,1)=NR*SR;                     % measure of denoising performance    
    DP(co,2)=SR;
    DP(co,3)=NR;
    
    display(co);
    
end


end