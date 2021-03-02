clc; clear all; close all;


path = 'NewDataset/*.mat';
path2 = 'NewDataset/';
folder = dir(path);
[~,idx] = natsortfiles({folder.name});
folder = folder(idx);
kanal = {};
for file=1:1
    
    filename = folder(file).name;
    raw_data = load(sprintf('%s%s',path2,filename));
    kanal1 = struct2cell(raw_data);
    kanal = [kanal ; kanal1];
end

R =1;
C = 1;
M = 1;
[Channel, passband, judul] = freqIdentity();
for j=1:length(kanal)   % Jumlah data kanal dari setiap subject Dataset
    oriSig = emd(kanal{j}, 'interp','pchip', 'maxmodes', 2); %tambah maxmodes jika mau cari shannon (jumlah IMF), misal 'maxmodes', 7
                             
N = length(oriSig(1,:));                                    % Panjang sinyal
Fs = 256;                                                   % Sampling Frequency (Hz)
t = linspace(0, N, N)/Fs;                                   % Time Vector (If One Has Not Been Supplied With Your EEG Record)
Fn = Fs/2;                                                  % Nyquist Frequency (Hz)
        for i=1:length(passband)-1
        % ========================================================== %
        %                       FIlter Design                        %
        % ========================================================== %
                                                                        
        Wp = [passband(i)    passband(i+1)]/Fn;                     % Passband Frequency Vector (Normalised)
        Ws = [passband(i)-0.5    passband(i+1)+1]/Fn;               % Stopband Frequency Vector (Normalised)

        % Wp = 3.5/Fn;  lowpass atau bandpass                                                              
        % Ws = 2.5/Fn;
        Rp =  1;                                                    % Passband Ripple (dB)
        Rs =  50;                                                   % Stopband Attenuation (dB)
        [n,Wp] = ellipord(Wp,Ws,Rp,Rs);                             % Calculate Filter Order
        [z,p,k] = ellip(n,Rp,Rs,Wp,'bandpass');                     % Default Here Is A Lowpass Filter
        [sos,g] = zp2sos(z,p,k);                                    % Use Second-Order-Section Implementation For Stability
        EMG_filtered = filtfilt(sos,g,oriSig(1,:));                 % Filter Signal (Here: ‘x’)
        % ==========================================================%
        %      Jangan di Plot klau subject > 20 orang               %
        % ==========================================================%
        % ==========================================================%
        %      Plot FIlter Design    & FFT Filtered Signal          %
        % ==========================================================%
%         figure
%         freqz(sos, 2^14, Fs)                                      % Bode Plot Of Filter
%         set(subplot(2,1,1), 'XLim',[0 15])                        % Optional, Change Limits As Necessary
%         set(subplot(2,1,2), 'XLim',[0 15])                        % Optional, Change Limits As Necessary% x = rand(1,1E+4);
%         nfft = 2^nextpow2(N);
%         FEMG_filtered = fft(EMG_filtered)/N;
%         Fv = linspace(0, 1, fix(N/2)+1)*Fn;                       % Frequency Vector
%         Iv = 1:length(Fv);                                        % Index Vector
%         % ==========================================================%
        %       Plot Band Delta, Theta, Alpha, Beta, Gamma          %
        %           For each Subject                                %
        % ==========================================================%
        %subplot(5,1,i)
        %plot(Fv, abs(FEMG_filtered(Iv))*2)
        %title(string(judul(i) + " " + string(passband(i)) + " - " + string(passband(i+1))));
        %ylabel('Spectral Amplitude|EEG(f)|'); % nilai absolute dari sinyal EEG terhadap frequency nya
        %xlabel('Active Frequency(Hz)');
        %grid

        % ========================================================== %
        %              Save Frequency Band to Var freq_band          %
        %          To access freq_band -> freq_band.name.TP7Alpha    %
        %           {'Delta', 'Theta', 'Alpha', 'Beta', 'Gamma'}     %
        % ========================================================== %
        
        freq_band(M,1).Name = string(strcat(Channel(R,C), string(judul(i))));
        freq_band(M,1).Signal = EMG_filtered;
        M = M + 1;
          
        
        end
        if R == 4 && C == 8
            R = 1;
            C = 1;
        elseif C == 8 
            R = R + 1;
            C = 1;
        else
            C = C + 1;
        end
        
end
 % ========================================================== %
 %              WARNING : HIGH CPU PROCESS                    %
 %  Untuk data Subject > 20 orang jangan jalankan Program ini %
 %  Limit dulu jumlah Subject nya jadi < 20 orang             %
 % ========================================================== %
 % ========================================================== %
 %         Plot Band Delta, Theta, Alpha, Beta, Gamma         %
 %         gabungkan masing2 frequency band berdasarkan       %
 % rentang frequency dan  nama kanal nya untuk semua Subject  %
 %         FP1->Delta + Theta + Alpha + Beta + Gamma          %
 %         TP7->Delta + Theta + Alpha + Beta + Gamma          %
 %                      ---------                             %
 % ========================================================== %
% Fv = linspace(0, 1, fix(N/2)+1)*Fn; 
% Iv = 1:length(Fv); 
data_subject = struct2table(freq_band); 
delta_index = find(contains(data_subject.Name,'Delta'));
theta_index = find(contains(data_subject.Name,'Theta'));
alpha_index = find(contains(data_subject.Name,'Alpha'));
beta_index = find(contains(data_subject.Name,'Beta'));
gamma_index = find(contains(data_subject.Name,'Gamma'));

% tabelFFT = table('Size', [0,0]);
% x = 1;
% initBand = {};
% for i=1:height(data_subject)
%     initBand{x,1} = abs(fft(data_subject(x,2).Signal)/N) ;
%     x = x + 1;
% end
    
% for i=1:length(delta_index)
% % ==========================================================    %
% % Jika data Subject kurang dari 10 orang,                       %
% % Rubah delta_index(i),2).Signal{:} -> delta_index(i),2).Signal %
% % ==========================================================    %
%     EEG_Band_Delta = fft(data_subject(delta_index(i),2).Signal)/N; 
%     EEG_Band_Theta = fft(data_subject(theta_index(i),2).Signal)/N;
%     EEG_Band_Alpha = fft(data_subject(alpha_index(i),2).Signal)/N;
%     EEG_Band_Beta = fft(data_subject(beta_index(i),2).Signal)/N;
%     EEG_Band_Gamma = fft(data_subject(gamma_index(i),2).Signal)/N;
%     hold on
%     subplot(3,2,1)
%     plot(Fv, abs(EEG_Band_Delta(Iv))*2);
%     title('Delta 1Hz - 4Hz');
%     ylabel('Spectral Amplitude|EEG(f)|');
%     xlabel('Active Frequency(Hz)');
%     hold on
%     subplot(3,2,2)
%     plot(Fv, abs(EEG_Band_Theta(Iv))*2);
%     title('Theta 4Hz - 8Hz');
%     ylabel('Spectral Amplitude|EEG(f)|');
%     xlabel('Active Frequency(Hz)');
%     hold on
%     subplot(3,2,3)
%     plot(Fv, abs(EEG_Band_Alpha(Iv))*2);
%     title('Alpha 8Hz - 12Hz');
%     ylabel('Spectral Amplitude|EEG(f)|');
%     xlabel('Active Frequency(Hz)');
%     hold on
%     subplot(3,2,4)
%     plot(Fv, abs(EEG_Band_Beta(Iv))*2);
%     title('Beta 12Hz - 30Hz');
%     ylabel('Spectral Amplitude|EEG(f)|');
%     xlabel('Active Frequency(Hz)');
%     hold on
%     subplot(3,2,[5,6])
%     plot(Fv, abs(EEG_Band_Gamma(Iv))*2);
%     title('Gamma 30Hz - 80Hz');
%     ylabel('Spectral Amplitude|EEG(f)|');
%     xlabel('Active Frequency(Hz)');
% end
% 
for x=1:length(freq_band)
    K=emd(data_subject(x,2).Signal);
  

    D=2;
    for d=1:D 

       y=abs(K(d,:));   %ambil IMF ke-d



        %entropy tiap skala

    shan(x,d)= entropy(y);     
    end
    
end
cellNama = {folder.name};
cellNama = cellNama' ;
shan2 = {} ;
headIMF = {};
bl = 1;
cc = 1;
oo = 1;
shan = shan / max(shan(:)) ;

% shan = shan - mean(shan(:)) / std(shan(:));
for v=1:length(shan)
    for PP=1:2
        shan2{oo,bl} = shan(v,PP);
        bl = bl + 1;
    end
        if bl > 320
        bl = 1;
        oo = oo + 1;
    end
    
end
tabelNama = cell2table(cellNama, 'VariableNames',{'name'}) ;
for imfList=1:160
    for ll=1:2
        headIMF{1,cc} = data_subject(imfList,1).Name + 'Shan' + ll  ;
        cc = cc + 1;
    end

end
% tabelShan22 = table('Size', [0,0]);
% for o=1:length(headIMF)
%     
%     tabel1 = cell2table(shan2{1,o}, 'VariableNames', string(headIMF{1,o}));
%     tabelShan22 = [tabelShan22, tabel1];
% end
    
tabelShan = cell2table(shan2,  'VariableNames', string(headIMF)) ;
finalTab = [tabelNama, tabelShan];
% writetable(finalTab, 'cobaFFt_shan3.xlsx', 'sheet', 1);
