clear; close all; clc;
%------------------------------------------------------------------------------------------------------------------------------------------------------   
%  SETTINGS
%------------------------------------------------------------------------------------------------------------------------------------------------------   
filePath = '/projects/kg98/Thapa/GWM/RESTDATAonly/13_SimonTask/';
pathOut = '/projects/kg98/Thapa/GWM/RESTDATAonly/13_SimonTask/';

cd (filePath)

ID =  {'133'; '134'; '135'; '136'; '137'; '138'; '139'};
    
for i = 1:length(ID)
    
    FileName = [filePath,'GWM',ID{i},'_SMT_summary.txt'];
    
    FileName2 = strrep(FileName, '_SMT_summary.txt', '_SMT_summary.iqdat');
    
    movefile(FileName, FileName2);
end


