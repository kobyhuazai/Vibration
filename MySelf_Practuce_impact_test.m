clear,clc,close all

%GET DATA FILE
[fnam pnam] = uigetfile({'*.txt'},'Select impact data');
fnam = [pnam fnam];
YuanWenJian = importdata(fnam); %time (s), 锤子的测力计 force (V), 贴在5点的加速度计 acceleration (mV)
YuanWenJian=YuanWenJian.data;   % 源文件是一个txt，有四列，第一列是 时间
hammer_sens=2.248e-3;   %V/N
accel_sens=10e-3;  %V/g
t=YuanWenJian(:,1);
t=abs(min(t))+t;            % t 从零开始计，相当于将(-3,3)的t坐标平移为（0，6）
x=YuanWenJian(:,2)*1/hammer_sens;   %hammer signal converted to N
y=YuanWenJian(:,3)*1/accel_sens;   %accelerometer signal converted to g

%select data - 第1张 - 时间-锤子力
plot(x),ylabel('force (N)')      % 这幅图 没有 t的信息，x轴不是t；y轴是 源文件 第二列（上面的x，意义为 锤子测得力）
dim = [.2 .5 .3 .3];             % 弹框的尺寸信息
str = 'zoom in, select start of impulse';
annotation('textbox',dim,'String',str,'FitBoxToText','on');
dcm_obj=datacursormode;
set(dcm_obj,'DisplayStyle','datatip','SnapToDataVertex','off','Enable','on')  %style是小标签；打开；
pause                           % 这里要用pause， 因为 这样才能点选 一个点， 点选完 c_info才有了内容，包括坐标，index，点所在整个对象
c_info=getCursorInfo(dcm_obj);  %什么位置 之类的所有信息都存在里面
start=c_info.DataIndex          %点选脉冲的起点，存到start中----DataIndex 是 点 在所有点里面 排第几个；做这件事目的是 截掉之前的点
            % -第2张 - 时间-点5的加速度
close all, plot(y), ylabel('acceleration (g)')
dim = [.2 .5 .3 .3];
str = 'select somewhere where signal is steady-state';
annotation('textbox',dim,'String',str,'FitBoxToText','on');
dcm_obj=datacursormode;
set(dcm_obj,'DisplayStyle','datatip','SnapToDataVertex','off','Enable','on')
pause
c_info=getCursorInfo(dcm_obj);
finish=c_info.DataIndex         %点中 你认为信号已经平稳的一点， 该点 是所有点的 第几个 被记录于 finish；做这件事目的是 截掉之后的点

t=t(start:finish,1);    %截掉 前面 和后面
x=x(start:finish,1);
y=y(start:finish,1);
t=t-min(t);             % 置 为从0开始
zerosc=2;
%tzero=(linspace(0,(2^nextpow2(length(t))),(2^nextpow2(length(t)))))';
tzero=(            (     linspace  (     0, (length(t)*zerosc), (length(t)*zerosc)+1     )* t(2)     )+  max(t)            )';% t的个数扩为2倍，间距统一
xzero=tzero*0;          % 2倍的 原t的个数 的0 
yzero=xzero;            % 2倍的 原t的个数 的0 
t=vertcat(t,tzero);     %vertcat，垂直串联;tzero 第一个数 正好是 t的最后一个数，两者接上，（t间隔稍微参差不齐，tzero间隔一致）
x=vertcat(x,xzero);     %  补齐，和补足后的t的总个数对齐，后面全补0
y=(vertcat(y,yzero));    %  补齐，和补足后的t的总个数对齐，后面全补0
trunc=[t x y];           %trunc的意思是 截尾 

close all
figure(1),subplot(2,1,1),plot(t,x),ylabel('force(N)')
subplot(2,1,2),plot(t,y), xlabel('time(s)'), ylabel('acceleration(g)')         % 改造后的 两张图-‘t-锤力’&‘t-点5的加速度’

Fs=(t(2,1)-t(1,1))^-1;      %sampling frequency
f=(Fs*(0:length(x)-1)/length(x))';  %frequency range
halfpt=floor(length(f)/2);      % floor函数是四舍，得到 中点 在所有里面 是 第几个
Y=(abs(fft(x)/Fs/(max(t)/2)));  
Y2=(abs(fft(y)/Fs/(max(t)/2)));
h=smooth(Y2./Y);                % 输出（加速度） 除以 输入（锤子力），然后 平滑处理

figure(2),semilogy(f(1:halfpt,1),h(1:halfpt,1)) % semilogy，对数坐标；amplitude 用对数坐标，虚部不用
xlabel('frequency (Hz)')
ylabel('accelerance (g/N)')
axis([0 500 0 max(h)])    % 本图 只展示 0-500 这一段频率， 总的远大于500
FRF=[f(1:halfpt,1) h(1:halfpt,1)];

Ycomp=((fft(x)/Fs/(max(t)/2)));
Y2comp=((fft(y)/Fs/(max(t)/2)));
h=Y2comp./Ycomp;         % 上面的h是实数集（振幅），这个是复数集
himag=imag(h);
figure(3),plot(f(1:halfpt,1),himag(1:halfpt,1))
xlabel('frequency (Hz)')
ylabel('imaginary')
axis([100 500 -300 300])
dim = [.2 .5 .3 .3];
str = 'zoom in, select a peak/trough then press enter, repeat for all.';
annotation('textbox',dim,'String',str,'FitBoxToText','on');

%GET DATA FROM FIGURE-点一下，出坐标，拿手记下来；点一下，按回车，坐标存入y1...
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
figure,plot(f(1:halfpt,1),himag(1:halfpt,1))   % 所有图全关闭，再 打开之前的 虚部图
xlabel('frequency (Hz)')
ylabel('imaginary')
axis([100 500 -2000 2000])
title(['values =' num2str(Four_Y_Value(1,:)) ' ,' num2str(Four_Y_Value(2,:)) ' ,' num2str(Four_Y_Value(3,:)) ' ,' num2str(Four_Y_Value(4,:)) ])
dim = [.2 .5 .3 .3];
str = 'zoom in, save this figure';
annotation('textbox',dim,'String',str,'FitBoxToText','on');