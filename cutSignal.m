function [muestras, cantidadDeSecciones]=cutSignal(x, fs, tiempoDeIntegracion)

%x = correspond at the signal to cut
%t = integration time (Slow,Fast,Impulse)

t=tiempoDeIntegracion;



t_muestras=ceil(fs*t); %cantiad de muestras por seccion
assignin('base','t_muestras', t_muestras);
L=length(x);

if L < t_muestras
    disp('El audio no es lo suficientemente largo')
end

cantidadDeSecciones=L/t_muestras; %Toma la parte entera


% x=x';

s=zeros(1, t_muestras*ceil(cantidadDeSecciones) - L);

x1 = [x, s];
    
    
muestras=cell(1,ceil(cantidadDeSecciones));

T=ones(1,t_muestras);

    for f = 0:(ceil(cantidadDeSecciones)-1)
       a=[];
        for i= 1:t_muestras
            vector(i)=x1(t_muestras*f +i)*T(i);
        end
       a=[a;vector];
       muestras{f+1}=a;
    end
    

end


