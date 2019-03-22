function [Lpico,LmaxTotal, LminTotal, Percentiles]=levels(signalOriginal, signal,section)

% Signal must be the filtered and ponderated signal
% section it is the filtered signal, divide by the integration time
% (MATRIX)

%---------Valor pico Max-----------%
p0=2*10^(-5);
Lpico=max(sqrt((signalOriginal).^2));
Lpico=mag2db(Lpico/p0);



%---------Máximos y Mínimos--------%
% s=size(section);
% s=s(1);
% A=zeros(s,2);
%  
% for i=1:s
%      B=max(section(i,:));
%      C=min(section(i,:));
%      A(i,1)=B;
%      A(i,2)=C;
% end    


s=size(section);
f=s(1);
c=s(2);
b=[];
a=[];
for i=1:f   
    for n=1:c
        P(n)=10^(section(i,n)/10);
    end 
    a=[a;P];
end


for i= 1:f
    vector(i)=sum(a(i,:));
end
b=[b;vector];

GlobalPorTercio=[];
for i= 1:c
    vector(i)=sum(a(:,i));
end
GlobalPorTercio=[GlobalPorTercio;vector];
GlobalPorTercio=10*log10(GlobalPorTercio);

leqs=10*log10(b);

assignin('base','GlobalPorTercio',GlobalPorTercio)
assignin('base','leqs',leqs)
assignin('base','a',a)
assignin('base','b',b)

LmaxTotal=max(leqs);
LminTotal=min(leqs);

 
 %-----------------Cálculo de Percentiles------------%
tec = signal;
teco=sort(tec);
per10 = teco(round(length(teco)*0.1));
per25 = teco(round(length(teco)*0.25));
per50 = teco(round(length(teco)*0.5));
per75 = teco(round(length(teco)*0.75));
per90 = teco(round(length(teco)*0.9));
 
Percentiles=[per10 , per25, per50, per75, per90];

end

