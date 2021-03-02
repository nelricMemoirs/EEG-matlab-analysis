function HHT_Ver02(t, sig, Fs)
% %example
% clc; clear; close all
% 
% Ts = 0.0005;
% Fs = 1 / Ts;
% N = 600;
% k = 0 : N-1;
% t = k .* Ts;
% t = t';
% sig(1:300,1) = 6 * sin(100 .* pi .* t(1:300))+0.1;
% sig(301:600,1) = 6 * sin(100 .* pi .* t(301:600)) + 1.5 * sin(300 .* pi .* t(301:600))+0.1;
% HHT_Ver02(t, sig, Fs);

Ts = 1 / Fs;
N = length(sig);

[IMF, res, K] = EMD_Ver01(t,sig,N);

Fig_Num = K + 2;
figure(1)  %»æÖÆ·Ö½â½á¹û
subplot(Fig_Num,1,1)
plot(t,sig,'LineWidth',1.5);
hold on
for i = 2 : Fig_Num - 1
    subplot(Fig_Num,1,i)
    plot(t,IMF{1,i-1},'LineWidth',1);
end
subplot(Fig_Num,1,Fig_Num)
plot(t,res,'LineWidth',0.5);

for i = 1 : K
    x = IMF{1,i};
    y = hilbert(x);%½âÎö�?ÅºÅ
    hx = imag(y);
    Xt = abs(y);
    dhx = derivative(hx);
    dx = derivative(x);
    w = (x.*dhx - hx.*dx)./(Xt.^2); %instantaneous radian frequency
    freq = w * Fs / (2 * pi);
    TMAF=[t,x,Xt,freq];
    figure(i + 1)
    DrawPic(TMAF,Ts)
end   