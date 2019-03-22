function [y1, FileName]=calibrationLoad

[FileName, Path] = uigetfile('*.wav' ,'Open File');

    if isequal(FileName,0)
        disp('Canceled');
    else
ubicacion= strcat(Path,FileName); %Concatenar la ubicacion con el nombre del archivo
[y] = audioread(ubicacion);
y1=y';


    end
end