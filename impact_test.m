clear,clc,close all

%GET DATA FILE
[fnam pnam] = uigetfile({'*.txt'},'Select impact data');
fnam = [pnam fnam];
fid = importdata(fnam); %time (s), force (V), acceleration (mV)
fid=fid.data;
hammer_sens=2.248e-3;   %V/N
accel_sens=10e-3;  %V/g
t=fid(:,1);
t=abs(min(t))+t;
x=fid(:,2)*1/hammer_sens;   %hammer signal converted to N
y=fid(:,3)*1/accel_sens;   %accelerometer signal converted to g

%select data
plot(x),ylabel('force (N)')
dim = [.2 .5 .3 .3];
str = 'zoom in, select start of impulse';
annotation('textbox',dim,'String',str,'FitBoxToText','on');
dcm_obj=datacursormode;
set(dcm_obj,'DisplayStyle','datatip','SnapToDataVertex','off','Enable','on')  %style是小标签；打开；
pause
c_info=getCursorInfo(dcm_obj);  %什么位置 之类的所有信息都存在里面
start=c_info.DataIndex
close all, plot(y), ylabel('acceleration (g)')
dim = [.2 .5 .3 .3];
str = 'select somewhere where signal is steady-state';
annotation('textbox',dim,'String',str,'FitBoxToText','on');
dcm_obj=datacursormode;
set(dcm_obj,'DisplayStyle','datatip','SnapToDataVertex','off','Enable','on')
pause
c_info=getCursorInfo(dcm_obj);
finish=c_info.DataIndex

t=t(start:finish,1);
x=x(start:finish,1);
y=y(start:finish,1);
t=t-min(t);
zerosc=2;
%tzero=(linspace(0,(2^nextpow2(length(t))),(2^nextpow2(length(t)))))';
tzero=((linspace(0,(length(t)*zerosc),(length(t)*zerosc)+1)*t(2))+max(t))';
xzero=tzero*0;
yzero=xzero;
t=vertcat(t,tzero);
x=vertcat(x,xzero);
y=(vertcat(y,yzero));
trunc=[t x y];

close all
figure(1),subplot(2,1,1),plot(t,x),ylabel('force(N)')
subplot(2,1,2),plot(t,y), xlabel('time(s)'), ylabel('acceleration(g)')

Fs=(t(2,1)-t(1,1))^-1;      %sampling frequency
f=(Fs*(0:length(x)-1)/length(x))';  %frequency range
halfpt=floor(length(f)/2);
Y=(abs(fft(x)/Fs/(max(t)/2)));
Y2=(abs(fft(y)/Fs/(max(t)/2)));
h=smooth(Y2./Y);

figure(2),semilogy(f(1:halfpt,1),h(1:halfpt,1))
xlabel('frequency (Hz)')
ylabel('accelerance (g/N)')
axis([0 500 0 max(h)])
FRF=[f(1:halfpt,1) h(1:halfpt,1)];

Ycomp=((fft(x)/Fs/(max(t)/2)));
Y2comp=((fft(y)/Fs/(max(t)/2)));
h=Y2comp./Ycomp;
himag=imag(h);
figure(3),plot(f(1:halfpt,1),himag(1:halfpt,1))
xlabel('frequency (Hz)')
ylabel('imaginary')
axis([100 500 -300 300])
dim = [.2 .5 .3 .3];
str = 'zoom in, select a peak/trough then press enter, repeat for all.';
annotation('textbox',dim,'String',str,'FitBoxToText','on');

%GET DATA FROM FIGURE
dcm_obj=datacursormode;
set(dcm_obj,'DisplayStyle','datatip','SnapToDataVertex','off','Enable','on')
pause
c_info=getCursorInfo(dcm_obj);
y1=c_info.Position;
dcm_obj=datacursormode;
set(dcm_obj,'DisplayStyle','datatip','SnapToDataVertex','off','Enable','on')
pause
c_info=getCursorInfo(dcm_obj);
y2=c_info.Position;
dcm_obj=datacursormode;
set(dcm_obj,'DisplayStyle','datatip','SnapToDataVertex','off','Enable','on')
pause
c_info=getCursorInfo(dcm_obj);
y3=c_info.Position;
dcm_obj=datacursormode;
set(dcm_obj,'DisplayStyle','datatip','SnapToDataVertex','off','Enable','on')
pause
c_info=getCursorInfo(dcm_obj);
y4=c_info.Position;
p=vertcat(y1,y2,y3,y4);     %THIS IS THE FREQUENCY AND MODE SHAPE
yimag=p(:,2);
close all
figure,plot(f(1:halfpt,1),himag(1:halfpt,1))
xlabel('frequency (Hz)')
ylabel('imaginary')
axis([100 500 -2000 2000])
title(['values =' num2str(yimag(1,:)) ' ,' num2str(yimag(2,:)) ' ,' num2str(yimag(3,:)) ' ,' num2str(yimag(4,:)) ])
dim = [.2 .5 .3 .3];
str = 'zoom in, save this figure';
annotation('textbox',dim,'String',str,'FitBoxToText','on');