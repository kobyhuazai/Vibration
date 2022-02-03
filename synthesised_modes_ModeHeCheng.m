% 本工作 主要 做的是 曲线拟合Curvefitting（用解析公式  表示实验结果 ）？？？

clc,close all
%data for pt2_pt5 from FRF
XF=[8.756 2.807 33.48 6.378]';         %amplitudes from FRF [mode1 mode2 mode3 mode4]
Wn=[120.3 270.2 372.1 489.3]';       %natural frequencies [mode1 mode2 mode3 mode4]
z=[4.16e-4 2.78e-4 13.44e-4 1.02e-4]';          %damping ratios阻尼比 [mode1 mode2 mode3 mode4]-用half-power法求的
f=(1:0.1:500)'

mnum=1;
d=z(mnum,1);
fn=Wn(mnum,1);
B1=(f/fn);
H1=((B1.^2)./(sqrt(((1-(B1.^2)).^2)+((2.*d.*B1).^2))));
H1=(H1/max(H1))*XF(mnum,1);              % 一个步骤--比例缩放
fn1=[B1(:,1) H1(:,1)];

mnum=2;
d=z(mnum,1);
fn=Wn(mnum,1);
B2=(f/fn);
H2=((B2.^2)./(sqrt(((1-(B2.^2)).^2)+((2.*d.*B2).^2))));
H2=(H2/max(H2))*XF(mnum,1);
fn2=[B2(:,1) H2(:,1)];

mnum=3;
d=z(mnum,1);
fn=Wn(mnum,1);
B3=(f/fn);
H3=((B3.^2)./(sqrt(((1-(B3.^2)).^2)+((2.*d.*B3).^2))));
H3=(H3/max(H3))*XF(mnum,1);
fn3=[B3(:,1),H3(:,1)];

mnum=4;
d=z(mnum,1);
fn=Wn(mnum,1);
B4=(f/fn);
H4=((B4.^2)./(sqrt(((1-(B4.^2)).^2)+((2.*d.*B4).^2))));
H4=(H4/max(H4))*XF(mnum,1);
fn4=[B4(:,1),H4(:,1)];

figure,semilogy(f(:,1),fn1(:,2))
hold on
plot(f(:,1),fn2(:,2))
hold on
plot(f(:,1),fn3(:,2))
hold on
plot(f(:,1),fn4(:,2))
hold on
semilogy(f(:,1),(fn1(:,2)+fn2(:,2)+fn3(:,2)+fn4(:,2)),'-k')
xlabel('frequency (Hz)')
ylabel('acceleration (g/N)')