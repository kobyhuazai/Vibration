clear,clc,close all


x = 0:pi/100:2*pi;
y = sin(x);
plot(x,y);

dcm_obj=datacursormode;
set(dcm_obj,'DisplayStyle','datatip','SnapToDataVertex','off','Enable','on')  %style是小标签；打开；

pause   % 这里要用pause， 因为 这样才能点选 一个点， 点选完 c_info才有了内容，包括坐标，index，点所在整个对象

c_info=getCursorInfo(dcm_obj);  %什么位置 之类的所有信息都存在里面
start=c_info.DataIndex          %点选脉冲的起点，存到start中
set(c_info.Target,'LineWidth',2) % Make selected line wider 
