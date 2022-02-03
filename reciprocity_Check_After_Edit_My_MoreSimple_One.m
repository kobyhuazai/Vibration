clear,clc,close all
format long
sensimpact=2.248e-3; %sensitivity in V/N
sensaccel=0.010; %sensitivity in V/g
%%
%Impact Frequency Response����-8����-������-ʱ������
[fnam pnam] = uigetfile({'*.txt'},'Select impact pt 8 data file');
fnam = [pnam fnam];
impact = importdata(fnam);
Fs=(impact(2,1)-impact(1,1))^-1;
t=impact(:,1);                       %time
y=impact(:,2)/sensimpact;          %amplitude
f=(Fs*(0:length(y)-1)/length(y))';  %frequency range
Y=(    abs(  fft(y)  )    );
%%
%Accelerometer Frequency Response ���-18���-���ٶȼ�-ʱ������
[fnam pnam] = uigetfile({'*.txt'},'Select accelerometer pt 18 data file');
fnam = [pnam fnam];
accel = importdata(fnam);
Fs=(accel(2,1)-accel(1,1))^-1;            %sampling frequency
t=accel(:,1);                       %time
y=accel(:,(2))/sensaccel;          %amplitude
f=(Fs*(0:length(y)-1)/length(y))';  %frequency range
X=(   abs(fft(y))   );
%%
%FRF 1
Hpt1=[f(:,1) (X(:,1)./Y)];
%%
%%
%Impact Frequency Response
[fnam pnam] = uigetfile({'*.txt'},'Select impact pt 18 data file');
fnam = [pnam fnam];
impact = importdata(fnam);
Fs=(impact(2,1)-impact(1,1))^-1;
t=impact(:,1);                       %time
y=impact(:,2)/sensimpact;          %amplitude
f=(Fs*(0:length(y)-1)/length(y))';  %frequency range
Y=(   abs(fft(y))   );
%%
%Accelerometer Frequency Response 
[fnam pnam] = uigetfile({'*.txt'},'Select accelerometer pt 8 data file');
fnam = [pnam fnam];
accel = importdata(fnam);
Fs=(accel(2,1)-accel(1,1))^-1;            %sampling frequency
t=accel(:,1);                       %time
y=accel(:,(2))/sensaccel;          %amplitude
f=(Fs*(0:length(y)-1)/length(y))';  %frequency range
X=(   abs(fft(y))   );
%%
%FRF 2
Hpt2=[f(:,1) (X(:,1)./Y)];
%%
%Plot FREQUENCY 0-250
figure,semilogy(Hpt1(:,1),Hpt1(:,2),Hpt2(:,1),Hpt2(:,2))
axis([0  250  1e-4 0.1])
xlabel('frequency (Hz)')
ylabel('H(\omega) (g/N)')
legend('X/F=pt18/pt8','X/F=pt8/pt18')
%Plot����Ƶ��0-4000
figure,semilogy(Hpt1(:,1),Hpt1(:,2),Hpt2(:,1),Hpt2(:,2))
axis([0  4000  1e-4 0.1])
xlabel('frequency (Hz)')
ylabel('H(\omega) (g/N)')
legend('X/F=pt18/pt8','X/F=pt8/pt18')

