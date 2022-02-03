% 老师的代码，有下列问题，第一 Kn 部分的2派怎么来的？应该删掉？ 第二， 怎么模态质量直接用总质量m替代了？ 

clear,clc,close all

Uinput=inputdlg({'width:',...
                 'thickness:',...
                 'length:',...
                 'density:',...
                 'damping ratio:'},...
                 'input',1,{'','','','',''});
w=eval(Uinput{1});
t=eval(Uinput{2});
L=eval(Uinput{3});
rho=eval(Uinput{4});

zn=eval(Uinput{5});
%mnum=eval(Uinput{6});
%%
%COMMENT FROM HERE TO END
fn=[2.7039 16.9460 47.4420 92.9761];
kn=((2*pi.*fn).^2)*(L*w*t*rho);
zn=[zn zn zn zn];
phif=[0.011 0.063 0.159 0.294];     %YOU NEED TO CHANGE THESE. mode shapes for the forcing location for each mode
phir=[1.000 -1.000 1.000 -1.000];     %YOU NEED TO CHANGE THESE. mode shapes for the response location for each mode
%50---0.011 0.063 0.159 0.294
%302---0.345 0.711 -0.008 -0.746
%600---1.000 -1.000 1.000 -1.000
f=linspace(0,100,5000);
for n = 1:length(fn),
    r = f/fn(n);
    hi(:,n) = phif(n)*phir(n)/kn(n)./(1-r.^2+j*2*zn(n)*r);
end
h=abs(sum(hi,2));
loglog(f,h)
ylabel('H')
xlabel('frequency (Hz)')
