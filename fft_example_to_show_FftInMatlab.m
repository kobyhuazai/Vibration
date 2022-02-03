clear;clc
Fs = 1000;            % ����Ƶ��
T = 1/Fs;             % ��������
L = 1000;             % �źų���   �ɴ�֪��Ƶ�ʷֱ���Ϊ 1hz
t = (0:L-1)*T;        % ʱ������
S = 0.7*sin(2*pi*50*t+pi/4) + sin(2*pi*150*t-pi/2);   % ԭʼ����
Y = fft(S);

P2 = abs(Y/L);  % ÿ�����������г��� L
P1 = P2(1:L/2+1);  % ȡ�������֣���ȡǰ��һ�룬�����ο�˹�ز�������
P1(2:end-1) = 2*P1(2:end-1); % ��������ģֵ����2

f = Fs*(0:(L/2))/L;
plot(f,P1)
  
title('Single-Sided Amplitude Spectrum of S(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

