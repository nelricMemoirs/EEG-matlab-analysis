function [IMF, res, K] = EMD_Ver01(t,x,N)
IMF = [];
j = 1;
r = x;
while 1
    h = r;
    while 1 %Èô²»Âú×ãIMFÌõ¼þ
        [u, ~] = findpeaks(h , N);%µ¥µ÷ÐòÁÐÊ±flag=0
        [hmaxline,hminline] = myspline(t, h, u , N);%Çó°üÂçÏß
        have = (hmaxline + hminline) ./ 2;%°üÂçÏßµÄÆ½¾ùÖµ
        h = h - have;      
        IMFflag = isIMF(h,have,N);%ÅÐ¶ÏhÊÇ·ñÂú×ãIMFÌõ¼þ
        if IMFflag == 1 %ÈôÂú×ãIMFÌõ¼þ£¬ÔòÖÕÖ¹ÄÚÑ­»·
            break;
        end      
    end
    IMF{j} = h;
    j = j + 1;
    r = r - h;
    [~, flag] = findpeaks(r , N);%µ¥µ÷ÐòÁÐÊ±flag=0
    tempr = r' * r;
    if flag == 0 || tempr < 0.5;
        break;
    end
end
res = r;
K = j - 1;