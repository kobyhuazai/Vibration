clear,clc,close all
format long
sensitivity= 444.8 ;              %NOTE: hammer sensitivity is in N/V--ԭʼ������V��ת��Ϊ����һ��ϵ��
%%
%Soft Tip
[fnam pnam] = uigetfile({'*.txt'},'��ѡ����������');
fnam = [pnam fnam];
soft = importdata(fnam);
Fs=(soft(2,1)-soft(1,1))^-1;            %sampling frequency ������Ƶ�ʣ�������Ϊ 50000��ʱ������ ��һ�����ڶ������ ʱ��Ĳ�ĵ���
t=soft(:,1);
y=soft(:,2)*sensitivity;
fsoft=(Fs*(0:length(y)-1)/length(y))';  %frequency range    50000����1-50000����һ�д���  
Ysoft=(abs  (fft(y)/Fs/(max(t)/2))  );    
%%
%Hard Tip
[fnam pnam] = uigetfile({'*.txt'},'Select hard tip file');
fnam = [pnam fnam];
hard = importdata(fnam);
Fs=(hard(2,1)-hard(1,1))^-1;
t=hard(:,1);
y=hard(:,2)*sensitivity;
fhard=(Fs*(0:length(y)-1)/length(y))';    
Yhard=(abs    (fft(y)/Fs/(max(t)/2))    );
%%
%PLOTTING
%HINT use "plot" command to plot figures. Use the help to find how to use
%it. For the force time domain data you are interested in what the peaks
%only are�� so move the start of the peaks to 0s and plot only the range of
%the peaks.

figure(1),plot(soft(:,1),(soft(:,2)*sensitivity)) %ʱ����������
hold on
plot(hard(:,1),(hard(:,2)*sensitivity),'-k')
axis([0 0.01 0 100])                     % x����0��0.01��y����0��100
title('Impulse Force')
xlabel('')
ylabel('')
legend('soft tip','hard tip')

figure(2),semilogy(fsoft,Ysoft,fhard,Yhard,'-k')  %Ƶ����������
axis([0 1000 0 5])
title('Force Frequency Response')
xlabel('')
ylabel('')
legend('soft tip','hard tip')