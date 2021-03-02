% Tao Shen (2020). hilbert-huang transform?HHT?
clear all
path = 'NewDataset/'
folder = dir(path);
par='AF3';
fs=2*pi;

for i=3:length(folder)
    filename = folder(i).name;
    raw_data = load(sprintf('%s%s',path,filename),par);
    sinyal=emd(raw_data.AF3);
    [hs,f,t] = hht(sinyal(1,:),fs);
    matriks = full(hs);
    for matI=1:size(matriks,1)
        for matJ=1:size(matriks,2)
            if matriks(matI,matJ)~=0
                newMat(1,matJ) = matriks(matI,matJ);
                break
            end
        end
    end 
    if (i>=3 && i<=28)
        data(i-2).kelas=1;
        data(i-2).fitur=newMat;
    else
        data(i-2).kelas=2;
        data(i-2).fitur=newMat;
    end
end
    

