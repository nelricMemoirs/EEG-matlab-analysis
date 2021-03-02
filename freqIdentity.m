function [name, Fband, title] = freqIdentity()
name = [];

Channel = ["FP1", "FP2", "AF3", "AF4", "F7", "F3", "FZ", "F4";
           "F8", "FT7", "FC3", "FCZ", "FC4", "FT8", "T7", "C3";
           "CZ", "C4", "T8", "TP7", "CP3", "CPZ", "CP4", "TP8";
            "P7", "P3", "PZ", "P4", "P8", "O1", "OZ", "O2"];
        
pass_cutoff = [1 , 4 , 8 , 12 , 30 , 80];
band_name = {'Delta', 'Theta', 'Alpha', 'Beta', 'Gamma'};

name = Channel;
Fband = pass_cutoff;
title = band_name;
        
return 

