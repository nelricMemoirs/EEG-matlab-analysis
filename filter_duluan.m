clc; clear all; close all;


path = 'NewDataset/*.mat';
path2 = 'NewDataset/';
folder = dir(path);
[~,idx] = natsortfiles({folder.name});
folder = folder(idx);
kanal = {};
for file=1:length(folder)
    
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
    oriSig = kanal{j};
                             
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

        Rp =  1;                                                    % Passband Ripple (dB)
        Rs =  50;                                                   % Stopband Attenuation (dB)
        [n,Wp] = ellipord(Wp,Ws,Rp,Rs);                             % Calculate Filter Order
        [z,p,k] = ellip(n,Rp,Rs,Wp,'bandpass');                     % Default Here Is A Lowpass Filter
        [sos,g] = zp2sos(z,p,k);                                    % Use Second-Order-Section Implementation For Stability
        EMG_filtered = filtfilt(sos,g,oriSig);                 % Filter Signal (Here: �x�)

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

data_subject = struct2table(freq_band); 

for x=1:length(freq_band)
    K=emd(data_subject(x,2).Signal{:});
  

    D=2;
    for d=1:D 

       y=abs(fft(K(d,:))/N);   %ambil IMF ke-d



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

for imfList=1:160
    for ll=1:2
        headIMF{1,cc} = data_subject(imfList,1).Name + 'Shan' + ll  ;
        cc = cc + 1;
    end

end  
tabelNama = cell2table(cellNama, 'VariableNames',{'name'}) ;
tabelShan = cell2table(shan2,  'VariableNames', string(headIMF)) ;
finalTab = [tabelNama, tabelShan];
writetable(finalTab, 'cobaFFt_shan3.xlsx', 'sheet', 1);
