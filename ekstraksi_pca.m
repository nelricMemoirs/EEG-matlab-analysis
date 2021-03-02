
clear all
path = 'NewDataset/'
folder = dir(path);
par='O2';
fs=2*pi;

for i=3:length(folder)
    filename = folder(i).name;
    raw_data = load(sprintf('%s%s',path,filename),par);
    sinyal=emd(raw_data.O2);
    [coeff] = pca(sinyal);
    matriks = full(coeff);
    newMat = reshape(matriks,[1 size(matriks,1)*size(matriks,2)]);
    newMat = newMat/255;
    if size(newMat,2)<25
        newMat(size(newMat,2):25)=0;
    else
        newMat = newMat(:,1:25);
    end
    if (i>=3 && i<=28)
        data(i-2).kelas=1;
        data(i-2).fitur=newMat;
    else
        data(i-2).kelas=2;
        data(i-2).fitur=newMat;
    end
end
    
a = struct2table(data);
writetable(a,'ekstraksi_pca.csv');
