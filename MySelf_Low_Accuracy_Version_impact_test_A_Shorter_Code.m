%% ����ϰ˵���� ����ʦ�ļ򻯵Ĵ��룬����������������㣬��ֻһ��ĵ㣬ʡȥ��Щ�����õ��� FRF��Amplitude ͼ��Ȼ����ʦ�Ļ�����ͬ
% ���ȣ���Լ�ﵽ��ʦ��70%  ��ʦ���룬 �ڶ����û� �����⣬ �õ���-9.8��3.75��34.5��-7.5���������룬�õ���-7.2��2.2��30.8��-4.9��    

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
Fs=(t(2,1)-t(1,1))^-1;      %sampling frequency
f=(Fs*(0:length(x)-1)/length(x))';  %frequency range

%%
%Y=(     abs (  fft(x)/Fs/ (max(t)/2)   )    );  
%Y2=(    abs (  fft(y)/Fs/ (max(t)/2)  )    );
%h=smooth(Y2./Y);                % ��������ٶȣ� ���� ���루����������Ȼ�� ƽ������

%close all, semilogy(f,h);
%grid on
%xlabel('frequency (Hz)')
%ylabel('accelerance (g/N)')
%axis([0 500 0 max(h)])    % ��ͼ ֻչʾ 0-500 ��һ��Ƶ�ʣ� �ܵ�Զ����500
%%
Ycomp=((fft(x)/Fs/(max(t)/2)));
Y2comp=((fft(y)/Fs/(max(t)/2)));
h=Y2comp./Ycomp;         % �����h��ʵ�����������������Ǹ�����
himag=imag(h);

figure(1),plot(f,himag)
xlabel('frequency (Hz)')
ylabel('imaginary')
axis([100 500 -300 300])







