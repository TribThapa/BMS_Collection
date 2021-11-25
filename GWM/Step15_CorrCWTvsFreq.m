clear; close all; clc;

% Datasets
dataName = {'data1'};
setSize = {'load2';'load4';'load6'};
freqName = {'delta';'theta';'alpha';'beta';'gamma'};

% Load in the data

load('/projects/kg98/Thapa/GWM/RESTDATAonly/3_Analyseddata/20To40Hz/freqAll.mat');
load('/projects/kg98/Thapa/GWM/RESTDATAonly/5_ColourWheelTask/colourWheelAll.mat');

% All data. No split.
dataIn.data1 = 1:92;

% Loop over data sets and set sizes for capacity
for datax = 1:length(dataName)
    for freqx = 1:length(freqName)
        for setx = 1:length(setSize)
            [corrFreq.(dataName{datax}).(freqName{freqx}).(setSize{setx}).r,corrFreq.(dataName{datax}).(freqName{freqx}).(setSize{setx}).p] = corr(wmCapacity(dataIn.(dataName{datax}),setx),freqAll.(freqName{freqx})(dataIn.(dataName{datax}),:),'type','Spearman');
        end
    end
end
        
save('/projects/kg98/Thapa/GWM/RESTDATAonly/3_Analyseddata/20to40Hz/corrFreq.mat','corrFreq','ID');
