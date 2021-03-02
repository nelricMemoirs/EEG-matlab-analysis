function IMFflag = isIMF(h, xave, N)
temp = 0;
for i = 1 : 1 : N - 1%ÅÐ¶ÏÌõ¼þ1¼ÆËã¹ýÁãµãÊýÁ¿
    if h(i) * h(i + 1) < 0
        temp = temp + 1;
    end
end
[u, ~]= findpeaks(h , N);
%view1(t,u,h);

if (temp - u(1,1) - u(1,2) > 1) || (temp - u(1,1) - u(1,2) < -1)
    IMFflag = 0;
else
    IMFflag = 1;
end
tempxave = xave' * xave;%ÅÐ¶ÏÌõ¼þ2
% tempx = h' * h;
% sd = tempxave / tempx;
% if sd > 0.005
%     IMFflag = 0;
% end
if tempxave > 0.1
    IMFflag = 0;
end



