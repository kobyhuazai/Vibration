clear,clc,close all

%% 自己重新编写 FRF<---->ModeShape，此为由 modeShape到FRF
% 联想：那么， 由FRF<---->ModeShape 关系式，也能做 反向的，由FRF 到mode shape
% 老师的代码，有下列问题，第一 Kn 部分的2派怎么来的？应该删掉？ 第二， 怎么模态质量直接用总质量m替代了？ 
%% 
w=0.025 ; t=1.04e-3 ; L=0.6 ; rho=7900;
zn=0.01;    %假设四个阻尼全是0.01

f = linspace(0,100,500); %一共500个点，第一个为0，最后一个为100；用了500个点，如果增加精度可以用5000
h = zeros(500,1);
r = zeros(500,4);

fn = [2.7039 16.9460 47.4420 92.9761];   % 4 固有频率
kn =(  ( 2*pi.*fn ).^2  )*(L*w*t*rho); %4刚度 问题？ 明明  w固有=根号下（k/m），应该kn=fn^2 * Mn!!! 2派哪来的？为什么用总质量m，应该是各模态质量mn啊

faip = [0.011 0.063 0.159 0.294];
faiq = [0.011 0.063 0.159 0.294];

for n = 1:4
	r(:, n) = f/fn(n);
	h = h + (   faip(n)*faiq(n)/kn(n) ./ ( 1-r(:, n).^2+j*2*zn*r(n) )   );
end

loglog(f,abs(h))
ylabel('H')
xlabel('frequency (Hz)')
