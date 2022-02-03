clear,clc,close all

Uinput=inputdlg({'a:',...
                 'b:',...
                 'h:',...
                 'rho:',...
                 'E:',...
                 'nu:',...
                 'mode:',...
                 'y:'},...
                 'input',1,{'','','','','','','',''});
a=eval(Uinput{1});
b=eval(Uinput{2});
h=eval(Uinput{3});
rho=eval(Uinput{4});
E=eval(Uinput{5});
nu=eval(Uinput{6});
mnum=eval(Uinput{7});
y=eval(Uinput{8});
%%
%COMMENT FROM HERE TO END
%calculate natural frequency, mode shape, and effective mass
A=a*b;
m=a*b*h*rho;
gamma=m/A;
lambda=[5.664 7.854 10.536 13.421];
fn = [0 0 0 0];
meff = [0 0 0 0];
x=linspace(0,a,100);
figure; 
for mnum = 1:length(lambda)
    fn(mnum)=((lambda(mnum)^2)/(2*pi*(a^2)))*((((E*(h^3))/(12*gamma*(1-(nu^2)))))^(1/2));
    
    phi=(sin((mnum*pi*x)/a))*(sin((mnum*pi*y)/b));
    phin=phi/(max(abs(phi)));
   
    subplot(2,2,mnum);
    plot(x,phin,'-o');
    grid on
    
    GAMMA=2*sqrt(m)*((1/(mnum*(pi^2)))*((cos(mnum*pi)-1)^2))
    meff(mnum)=GAMMA^2

    xlabel('Position (m)')
    ylabel('Normalised Shape');
    title(['Mode ' num2str(mnum) ',  ' num2str(fn(mnum)) ' Hz,', 'Meff = ' num2str(meff(mnum))])
end