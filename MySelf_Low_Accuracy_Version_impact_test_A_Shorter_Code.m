%% 本练习说明， 比老师的简化的代码，不扩充二倍，不补零，不只一半的点，省去这些操作得到的 FRF的Amplitude 图依然和老师的基本相同
% 精度：大约达到老师的70%  老师代码， 第二点敲击 第五点测， 得到（-9.8，3.75，34.5，-7.5）；本代码，得到（-7.2，2.2，30.8，-4.9）    

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
Fs=(t(2,1)-t(1,1))^-1;      %sampling frequency
f=(Fs*(0:length(x)-1)/length(x))';  %frequency range

%%
%Y=(     abs (  fft(x)/Fs/ (max(t)/2)   )    );  
%Y2=(    abs (  fft(y)/Fs/ (max(t)/2)  )    );
%h=smooth(Y2./Y);                % 输出（加速度） 除以 输入（锤子力），然后 平滑处理

%close all, semilogy(f,h);
%grid on
%xlabel('frequency (Hz)')
%ylabel('accelerance (g/N)')
%axis([0 500 0 max(h)])    % 本图 只展示 0-500 这一段频率， 总的远大于500
%%
Ycomp=((fft(x)/Fs/(max(t)/2)));
Y2comp=((fft(y)/Fs/(max(t)/2)));
h=Y2comp./Ycomp;         % 上面的h是实数集（振幅），这个是复数集
himag=imag(h);

figure(1),plot(f,himag)
xlabel('frequency (Hz)')
ylabel('imaginary')
axis([100 500 -300 300])







