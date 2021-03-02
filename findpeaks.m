function [u, flag]= findpeaks(x , N)
%ÊäÈë²ÎÊýxÎª´ý·ÖÎöµÄÊý¾ÝÐòÁÐ£¬NÎªÊý¾Ý³¤¶È
%·µ»ØÖµÎª¼«´óÖµºÍ¼«Ð¡Öµ×é³ÉµÄN*2Êý×éÒÔ¼°º¯Êýµ¥µ÷ÐÔµÄ±êÖ¾¡£
%uµÄµÚÒ»ÐÐ·Ö±ð¼ÇÂ¼¼«´óÖµµãºÍ¼«Ð¡ÖµµãµÄÊýÁ¿£¬ÆäËûÔªËØ¼ÇÂ¼¼«´óÖµµãºÍ¼«Ð¡Öµµã¶ÔÓ¦µÄÐòÁÐÎ»ÖÃ
u = zeros(N+1,2);
temp = zeros(N,1);
for i = 2 : N
    if x(i) - x(i - 1) > 0
        temp(i) = 1;
    elseif x(i) - x(i - 1) < 0
        temp(i) = -1;
    else
        if temp(i - 1) == 1
            temp(i) = 1;
        else
            temp(i) = -1;
        end
    end
end
j = 1;
k = 1;
for i = 3 : N
    temp1 = temp(i) - temp(i - 1);
    if temp1 == -2
        j = j + 1;
        u(j,1) = i - 1;%¼ÇÂ¼×î´óÖµÐòºÅ
    elseif temp1 == 2
        k = k + 1;
        u(k,2) = i - 1;%¼ÇÂ¼×îÐ¡ÖµÐòºÅ
    end
end
u(1,1) = j - 1;
u(1,2) = k - 1;
if u(1,1) + u(1,2) < 4;
    flag = 0;%ÐòÁÐµ¥µ÷
else
    flag = 1;%ÐòÁÐ´æÔÚ¼«Öµ
end

