clear,clc,close all

[fnam pnam] = uigetfile({'*.txt'},'Select experiment mode shape');
fnam = [pnam fnam];
modes = importdata(fnam);

for i=1:4
    col=i;
    b=abs(modes(:,col));
    div=max(b);
    I=find(b==div);
    extr=modes(I,col);
    nor(:,i)=modes(:,col)./extr;
end

for i=1:4;
    col=i;
    subplot(2,2,i),plot(nor(1:5,i),'-o')
    hold on
    plot(nor(6:10,i),'-o')
    xlabel('position')
    ylabel('shape')
    legend('pts 1-5','pts 6-10')
end