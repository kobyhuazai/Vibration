% 经过MyFFTWay-matlab官网的快速傅变换自己写代码-得到的图和老师的代码一样。
% 官网的fft 有一个截取一半的动作，将原数据先做fft；除长度；做abs；然后截取前半段；然后乘2
%%
clear,clc,close all
format long
sensitivity= 444.8 ;              %NOTE: hammer sensitivity is in N/V--原始数据是V，转换为力乘一个系数
%%
%Soft Tip
[fnam pnam] = uigetfile({'*.txt'},'请选择软锤的数据');
fnam = [pnam fnam];
soft = importdata(fnam);
Fs=(soft(2,1)-soft(1,1))^-1;            %sampling frequency （采样频率），本例为 50000；时域数据 第一个，第二个点的 时间的差的倒数
t=soft(:,1);
y=soft(:,2)*sensitivity;
L1 = length(t);                             %信号长度，本例为50000
MidRoadYsoft = abs(   ( fft(y) )/L1   );
Ysoft= MidRoadYsoft(1:L1/2+1);    % 取交流部分 

fsoft = Fs*(0:(L1/2))/L1;  %frequency range     
Ysoft(2:end-1) = 2*Ysoft(2:end-1);        % 交流部分模值乘以2 
%%
%Hard Tip
[fnam pnam] = uigetfile({'*.txt'},'Select hard tip file');
fnam = [pnam fnam];
hard = importdata(fnam);
Fs=(hard(2,1)-hard(1,1))^-1;
t=hard(:,1);
y=hard(:,2)*sensitivity;
L2 = length(t);                             %信号长度，本例为50000
MidRoadYhard = abs(   ( fft(y) )/L2   );
Yhard= MidRoadYhard(1:L2/2+1);    % 取交流部分 

fhard = Fs*(0:(L2/2))/L2;  %frequency range     
Yhard(2:end-1) = 2*Yhard(2:end-1);        % 交流部分模值乘以2 
%%
%PLOTTING
%HINT use "plot" command to plot figures. Use the help to find how to use
%it. For the force time domain data you are interested in what the peaks
%only are， so move the start of the peaks to 0s and plot only the range of
%the peaks.

figure(1),plot(soft(:,1),(soft(:,2)*sensitivity)) %时域两个曲线
hold on
plot(hard(:,1),(hard(:,2)*sensitivity),'-k')
axis([0 0.01 0 100])                     % x坐标0到0.01，y坐标0到100
title('Impulse Force')
xlabel('')
ylabel('')
legend('soft tip','hard tip')

figure(2),semilogy(fsoft,Ysoft,fhard,Yhard,'-k')  %频域两个曲线
axis([0 1000 0 5])
title('Force Frequency Response')
xlabel('')
ylabel('')
legend('soft tip','hard tip')