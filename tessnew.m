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
for i = size(kanal,1)
    kanal2 = kanal{i,1};
end

ex = 1;
filt_data = {};

for i = 1:length(passband)-1
    
    Fs = 100;
    order = 2;
%     low_freq = 8;
%     high_freq = 13;
    H1 = Bandpass_Butter(passband(i),passband(i+1),Fs,order);
    filt_data{i,ex} = filter(H1, kanal2);
    
    freq_band(M,1).Name = string(strcat(Channel(R,C), string(judul(i))));
    freq_band(M,1).Signal = filt_data;
    M = M + 1;
            
        if R == 4 && C == 8
            R = 1;
            C = 1;
        elseif C == 8 
            R = R + 1;
            C = 1;
        else
            C = C + 1;
        end
        ex = ex+1;
end


for j=1:length(filt_data)   % Jumlah data kanal dari setiap subject Dataset
    oriSig = emd(filt_data{j}); %tambah maxmodes jika mau cari shannon (jumlah IMF), misal 'maxmodes', 7
    oriSig = oriSig';                         
    N = length(oriSig(1,:));                                    % Panjang sinyal                                                  % Sampling Frequency (Hz)
    t = linspace(0, N, N)/Fs;                                   % Time Vector (If One Has Not Been Supplied With Your EEG Record)
    Fn = Fs/2;                                                  % Nyquist Frequency (Hz)
        
end
 
Fv = linspace(0, 1, fix(N/2)+1)*Fn; 
Iv = 1:length(Fv); 
data_subject = struct2table(freq_band); 
delta_index = find(contains(data_subject.Name,'Delta'));
theta_index = find(contains(data_subject.Name,'Theta'));
alpha_index = find(contains(data_subject.Name,'Alpha'));
beta_index = find(contains(data_subject.Name,'Beta'));
gamma_index = find(contains(data_subject.Name,'Gamma'));


for x=1:length(freq_band)
    k=emd(data_subject(x,2).Signal{:});
    
    for IMF=1:3
        y=k(IMF,:);
        shan(x,IMF) = entropy(y);
    end
end

shan = shan/max(shan(:));
shan2 = {};
judulIMF = {};

index1 = 1;
coloumn1 = 1;
coloumn2 = 1;

for i=1:length(shan)
    for j=1:3
        shan2{index1,coloumn1} = {shan(i,j)};
        coloumn1 = coloumn1 + 1;
    end
    
        if coloumn1 > 480
            coloumn1 = 1;
            index1 = index1 + 1;
        end
end

for n = 1:160
    for m = 1:3
        judulIMF{end+1} = data_subject(n,1).Name + 'shan'+ m;
        coloumn2 = coloumn2 + 1;
    end
    
end
cellNama = {folder.name};
cellNama = cellNama' ;
tabelNama = cell2table(cellNama, 'VariableNames',{'name'}) ;
tableShan = cell2table(shan2,'VariableNames',convertStringsToChars(string(judulIMF)));
finaltab = [tabelNama, tableShan];
writetable(finaltab,'PlotOrde14.xlsx','sheet',1);