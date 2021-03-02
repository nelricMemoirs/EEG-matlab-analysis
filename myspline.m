function [xmaxline,xminline] = myspline(t, x, u , N)
%×óÓÒÁ½¶Ë¸÷ÑÓÍØÁ½¸ö¼«Öµµã
%²Î¿¼ÎÄÏ×£ºÊøºé´º£¬µçÁ¦¹¤³ÌÐÅºÅ´¦ÀíÓ¦ÓÃ£¬¿ÆÑ§³ö°æÉç£¬2009£¬P333
%»Æ´ó¼ª. Ï£¶û²®ÌØ-»Æ±ä»»µÄ¶ËµãÑÓÍØ[J]. º£ÑóÑ§±¨, 2003, 25(1):1-11.
%³õÊ¼»¯
Ts = t(2) - t(1);
Max_Num = u(1,1);
Min_Num = u(1,2);

tmax = zeros(Max_Num + 4,1);
xmax = zeros(Max_Num + 4,1);
tmin = zeros(Min_Num + 4,1);
xmin = zeros(Min_Num + 4,1);

%×óÑÓÍØ
if u(2,1) < u(2,2)
    k = u(3,1) - u(2,1);
elseif u(2,1) > u(2,2)
    k = u(3,2) - u(2,2);
elseif Max_Num == Min_Num && Min_Num == 1
    k = 2 * abs(u(2,1) - u(2,2));
end
tmax(2) = t(u(2,1)) - k * Ts;
tmax(1) = tmax(2) - k * Ts;
xmax(1) = x(u(2,1));
xmax(2) = x(u(2,1));
tmin(2) = t(u(2,2)) - k * Ts;
tmin(1) = tmin(2) - k * Ts;
xmin(1) = x(u(2,2));
xmin(2) = x(u(2,2));
 
%ÓÒÑÓÍØ
if u(Max_Num + 1 ,1) > u(Min_Num + 1,2) %×îºóÒ»¸ö¼«´óÖµµÄÏÂ±ê ´óÓÚ ×îºóÒ»¸ö¼«Ð¡ÖµµÄÏÂ±ê
    k = u(Max_Num + 1,1) - u(Max_Num,1);
elseif u(Max_Num + 1 ,1) < u(Min_Num + 1,2)
    k = u(Min_Num + 1,2) - u(Min_Num,2);
elseif Max_Num == Min_Num && Min_Num == 1
    k = 2 * abs(u(Max_Num + 1,1) - u(Min_Num + 1,2));
end

tmax(Max_Num + 3) = t(u(Max_Num + 1,1)) + k * Ts;
tmax(Max_Num + 4) = tmax(Max_Num + 3) + k * Ts;
xmax(Max_Num + 3) = x(u(Max_Num + 1,1));
xmax(Max_Num + 4) = x(u(Max_Num + 1,1));

tmin(Min_Num + 3) = t(u(Min_Num + 1,2)) + k * Ts;
tmin(Min_Num + 4) = tmin(Min_Num + 3) + k * Ts;
xmin(Min_Num + 3) = x(u(Min_Num + 1,2));
xmin(Min_Num + 4) = x(u(Min_Num + 1,2));

%¶ËµãÊýÖµµÄ´¦Àí
if x(1) > x(u(2,1))
    tmax(2) = t(1);
    xmax(2) = x(1);
elseif x(1) < x(u(2,2))
    tmin(2) = t(1);
    xmin(2) = x(1);
end

if x(N) > x(u(Max_Num + 1,1))
    tmax(Max_Num + 3) = t(N);
    xmax(Max_Num + 3) = x(N);
elseif x(N) < x(u(Min_Num + 1,2))
    tmin(Min_Num + 3) = t(N);
    xmin(Min_Num + 3) = x(N);
end

for i = 2 : Max_Num + 1
    tmax(i + 1) = t(u(i,1));
    xmax(i + 1) = x(u(i,1));
end
for i = 2 : Min_Num + 1
    tmin(i + 1) = t(u(i,2));
    xmin(i + 1) = x(u(i,2));
end
xmaxline = spline(tmax,xmax,t);
xminline = spline(tmin,xmin,t);
% plot(t,x);
% hold on
% plot(t,xmaxline);
% hold on
% plot(t,xminline);
