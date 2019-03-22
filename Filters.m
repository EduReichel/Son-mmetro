function [audioFiltradodB,audioFiltradoT] = Filters(SOS,G,audioCortado,F0,fmin,fmax)

% Se le introducen como mínimo las matrices SOS y G obtenidas de la función
% 'Filtros.m' y el audio cortado por repeticiones (audioCortado). También
% puede introducirse la matriz de frecuencias centrales F0 de la función
% 'Filtros.m' junto con las frecuencias centrales mínimas y máximas que se deseen
% filtrar (fmin y fmax). La función devuelve un valor total energético por
% cada tercio filtrado, tanto en presión como en dB (audioFiltradoP y
% audioFiltradodB)

if nargin < 4
    min = 1;
    max = length(SOS(1,1,:));
elseif nargin < 5
    min = 1;
    max = length(SOS(1,1,:));
elseif nargin < 6
    min = find(F0==fmin);
    max = length(SOS(1,1,:));
else
    min = find(F0==fmin);
    max = find(F0==fmax);
end

for i = 1:length(audioCortado)
    p = 0;
    for k = min:max
        p = p + 1;
        audioFiltrado = filtfilt(SOS(:,:,k),G(:,k),audioCortado{i});
        audioFiltradoT1 = fft(audioFiltrado);
        audioFiltradoT = 2*abs(audioFiltradoT1(1:length(audioFiltradoT1/2)));
        audioFiltradoP = sqrt(sum(audioFiltradoT.^2)/length(audioFiltradoT)^2);
        audioFiltradodB(i,p) = 20*log10(audioFiltradoP);
    end
end