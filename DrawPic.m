function DrawPic(TMAF,Ts)
%acknowledgement:http://www.mathworks.com/matlabcentral/fileexchange/authors/110216
  subplot(5,5,[1:4,6:9,11:14])
  scatter(TMAF(:,1),TMAF(:,4),10,TMAF(:,3))
  xlim([0 TMAF(end,1)+Ts]);  %Sets x axis limits
  ylim([0.1 max(TMAF(:,4))-5]);
  xlabel('Time('), ylabel('Frequency');
  colorbar('SouthOutside')
  hold on
  subplot(5,5,[5,10])
  edges = 0.1:0.5:max(TMAF(:,4)); 
  [number,center] = hist(TMAF(:,4),edges);
  plot(number,center,'k')
  hold on
  ylim([0.1 max(TMAF(:,4))-5]);
  xlabel('Number')
  colorbar('off')
  subplot(5,5,[16:19,21:24])
  plot(TMAF(:,1),TMAF(:,3))
  colorbar('off')
  xlabel('Time'), ylabel('Amplitude');