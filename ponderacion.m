function [senalPonderada]=ponderacion(senalTercio, ponderacion)


% 
%
 %senalTerciodB = 10*log10((senalTercio).^2);
% assignin('base','senalTerciodB',senalTerciodB);

senalPonderada=90+ponderacion+senalTercio;


assignin('base','senalPonderada',senalPonderada);

end

