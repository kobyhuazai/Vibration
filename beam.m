clear,clc,close all

%Uinput=inputdlg({'width:',...
%                 'thickness:',...
%                 'length:',...
%                 'density:',...
%                 'modulus of elasticity:',...
%                 'mode:'},...
%                 'input',1,{'','','','','',''});

Uinput=inputdlg({'width:',...
                 'thickness:',...
                 'length:',...
                 'density:',...
               'modulus of elasticity:'},...  
                'input',1,{'','','','',''});
w=eval(Uinput{1});
t=eval(Uinput{2});
L=eval(Uinput{3});
rho=eval(Uinput{4});
E=eval(Uinput{5});
%mnum=eval(Uinput{6});
%%
%COMMENT FROM HERE TO END
fn =[0 0 0 0];
lambda=[1.875 4.694 7.854 10.995];
sigma=[0.73409 1.01846 0.99922 1.00003];
I=(w*(t^3))/12;
m=w*L*t*rho;

x=linspace(0,L,100);
figure;
for mnum = 1:length(lambda)     %mnum is already set,no need to input 'mode'
    fn(mnum)=lambda(mnum)^2/2/pi/L^2*sqrt((E*I*L)/m);
    phi=(cosh((lambda(mnum).*x)./L))-(cos((lambda(mnum).*x)./L))-(sigma(mnum).*((sinh((lambda(mnum).*x)./L))-(sin((lambda(mnum).*x)./L))));   %Blevins
    phin=phi/(max(abs(phi)));
    subplot(2,2,mnum);
    plot(x,phin,'-o');
    grid on
    xlabel('position')
    ylabel('normalised shape')
end