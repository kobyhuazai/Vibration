clear,clc,close all


x = 0:pi/100:2*pi;
y = sin(x);
plot(x,y);

dcm_obj=datacursormode;
set(dcm_obj,'DisplayStyle','datatip','SnapToDataVertex','off','Enable','on')  %style��С��ǩ���򿪣�

pause   % ����Ҫ��pause�� ��Ϊ �������ܵ�ѡ һ���㣬 ��ѡ�� c_info���������ݣ��������꣬index����������������

c_info=getCursorInfo(dcm_obj);  %ʲôλ�� ֮���������Ϣ����������
start=c_info.DataIndex          %��ѡ�������㣬�浽start��
set(c_info.Target,'LineWidth',2) % Make selected line wider 
