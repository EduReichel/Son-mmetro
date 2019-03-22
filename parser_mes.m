function [ audioNames ] = parser_mes()
%PARSER Summary of this function goes here
%   Detailed explanation goes here


[fName,fPath]=uigetfile('.wav', 'Cargar...');
[~, fName, fExt] = fileparts(fName);

splitStrCell = strsplit(fName, '');
baseName=strjoin(splitStrCell(1:end-4),' ');



fileList = dir(strcat(fPath,baseName,'',fExt));

audioNames={};

for k=1:length(fileList)
    [~, tmpName] = fileparts(fileList(k).name);
    
    tmpSplitStr = strsplit(tmpName, ' ');
    [micNum, mesNum] = tmpSplitStr{end-3:end-2};
        micNum=str2num(micNum);
        mesNum=str2num(mesNum);
        
       
    audioNames{micNum,mesNum} = strcat(fPath,tmpName,fExt);
    
end

end
