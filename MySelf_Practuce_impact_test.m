clear,clc,close all

%GET DATA FILE
[fnam pnam] = uigetfile({'*.txt'},'Select impact data');
fnam = [pnam fnam];
YuanWenJian = importdata(fnam); %time (s), ���ӵĲ����� force (V), ����5��ļ��ٶȼ� acceleration (mV)
YuanWenJian=YuanWenJian.data;   % Դ�ļ���һ��txt�������У���һ���� ʱ��
hammer_sens=2.248e-3;   %V/N
accel_sens=10e-3;  %V/g
t=YuanWenJian(:,1);
t=abs(min(t))+t;            % t ���㿪ʼ�ƣ��൱�ڽ�(-3,3)��t����ƽ��Ϊ��0��6��
x=YuanWenJian(:,2)*1/hammer_sens;   %hammer signal converted to N
y=YuanWenJian(:,3)*1/accel_sens;   %accelerometer signal converted to g

%select data - ��1�� - ʱ��-������
plot(x),ylabel('force (N)')      % ���ͼ û�� t����Ϣ��x�᲻��t��y���� Դ�ļ� �ڶ��У������x������Ϊ ���Ӳ������
dim = [.2 .5 .3 .3];             % ����ĳߴ���Ϣ
str = 'zoom in, select start of impulse';
annotation('textbox',dim,'String',str,'FitBoxToText','on');
dcm_obj=datacursormode;
set(dcm_obj,'DisplayStyle','datatip','SnapToDataVertex','off','Enable','on')  %style��С��ǩ���򿪣�
pause                           % ����Ҫ��pause�� ��Ϊ �������ܵ�ѡ һ���㣬 ��ѡ�� c_info���������ݣ��������꣬index����������������
c_info=getCursorInfo(dcm_obj);  %ʲôλ�� ֮���������Ϣ����������
start=c_info.DataIndex          %��ѡ�������㣬�浽start��----DataIndex �� �� �����е����� �ŵڼ������������Ŀ���� �ص�֮ǰ�ĵ�
            % -��2�� - ʱ��-��5�ļ��ٶ�
close all, plot(y), ylabel('acceleration (g)')
dim = [.2 .5 .3 .3];
str = 'select somewhere where signal is steady-state';
annotation('textbox',dim,'String',str,'FitBoxToText','on');
dcm_obj=datacursormode;
set(dcm_obj,'DisplayStyle','datatip','SnapToDataVertex','off','Enable','on')
pause
c_info=getCursorInfo(dcm_obj);
finish=c_info.DataIndex         %���� ����Ϊ�ź��Ѿ�ƽ�ȵ�һ�㣬 �õ� �����е�� �ڼ��� ����¼�� finish���������Ŀ���� �ص�֮��ĵ�

t=t(start:finish,1);    %�ص� ǰ�� �ͺ���
x=x(start:finish,1);
y=y(start:finish,1);
t=t-min(t);             % �� Ϊ��0��ʼ
zerosc=2;
%tzero=(linspace(0,(2^nextpow2(length(t))),(2^nextpow2(length(t)))))';
tzero=(            (     linspace  (     0, (length(t)*zerosc), (length(t)*zerosc)+1     )* t(2)     )+  max(t)            )';% t�ĸ�����Ϊ2�������ͳһ
xzero=tzero*0;          % 2���� ԭt�ĸ��� ��0 
yzero=xzero;            % 2���� ԭt�ĸ��� ��0 
t=vertcat(t,tzero);     %vertcat����ֱ����;tzero ��һ���� ������ t�����һ���������߽��ϣ���t�����΢�β�룬tzero���һ�£�
x=vertcat(x,xzero);     %  ���룬�Ͳ�����t���ܸ������룬����ȫ��0
y=(vertcat(y,yzero));    %  ���룬�Ͳ�����t���ܸ������룬����ȫ��0
trunc=[t x y];           %trunc����˼�� ��β 

close all
figure(1),subplot(2,1,1),plot(t,x),ylabel('force(N)')
subplot(2,1,2),plot(t,y), xlabel('time(s)'), ylabel('acceleration(g)')         % ������ ����ͼ-��t-������&��t-��5�ļ��ٶȡ�

Fs=(t(2,1)-t(1,1))^-1;      %sampling frequency
f=(Fs*(0:length(x)-1)/length(x))';  %frequency range
halfpt=floor(length(f)/2);      % floor���������ᣬ�õ� �е� ���������� �� �ڼ���
Y=(abs(fft(x)/Fs/(max(t)/2)));  
Y2=(abs(fft(y)/Fs/(max(t)/2)));
h=smooth(Y2./Y);                % ��������ٶȣ� ���� ���루����������Ȼ�� ƽ������

figure(2),semilogy(f(1:halfpt,1),h(1:halfpt,1)) % semilogy���������ꣻamplitude �ö������꣬�鲿����
xlabel('frequency (Hz)')
ylabel('accelerance (g/N)')
axis([0 500 0 max(h)])    % ��ͼ ֻչʾ 0-500 ��һ��Ƶ�ʣ� �ܵ�Զ����500
FRF=[f(1:halfpt,1) h(1:halfpt,1)];

Ycomp=((fft(x)/Fs/(max(t)/2)));
Y2comp=((fft(y)/Fs/(max(t)/2)));
h=Y2comp./Ycomp;         % �����h��ʵ�����������������Ǹ�����
himag=imag(h);
figure(3),plot(f(1:halfpt,1),himag(1:halfpt,1))
xlabel('frequency (Hz)')
ylabel('imaginary')
axis([100 500 -300 300])
dim = [.2 .5 .3 .3];
str = 'zoom in, select a peak/trough then press enter, repeat for all.';
annotation('textbox',dim,'String',str,'FitBoxToText','on');

%GET DATA FROM FIGURE-��һ�£������꣬���ּ���������һ�£����س����������y1...
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
Four_Y_Value=p(:,2);
close all
figure,plot(f(1:halfpt,1),himag(1:halfpt,1))   % ����ͼȫ�رգ��� ��֮ǰ�� �鲿ͼ
xlabel('frequency (Hz)')
ylabel('imaginary')
axis([100 500 -2000 2000])
title(['values =' num2str(Four_Y_Value(1,:)) ' ,' num2str(Four_Y_Value(2,:)) ' ,' num2str(Four_Y_Value(3,:)) ' ,' num2str(Four_Y_Value(4,:)) ])
dim = [.2 .5 .3 .3];
str = 'zoom in, save this figure';
annotation('textbox',dim,'String',str,'FitBoxToText','on');