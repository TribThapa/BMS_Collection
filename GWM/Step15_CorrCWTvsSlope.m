clear; close all; clc;

% Datasets
dataName = {'data1'};
setSize = {'load2';'load4';'load6'};

% Load in the data

%load('/projects/kg98/Thapa/GWM/RESTDATAonly/3_Analyseddata/20To40Hz/slopeAll.mat');
load('/projects/kg98/Thapa/GWM/RESTDATAonly/3_Analyseddata/20To40Hz/offsetAll.mat');
load('/projects/kg98/Thapa/GWM/RESTDATAonly/5_ColourWheelTask/colourWheelAll.mat');

% All data. No split.
dataIn.data1 = 1:92;

% Test normality assumptions using Kolmogorov-Smirnov test


% Loop over data sets and set sizes for capacity
for datax = 1:length(dataName)
    for setx = 1:length(setSize)
        [ksCapacity.(dataName{datax}).(setSize{setx}).h,ksCapacity.(dataName{datax}).(setSize{setx}).p] = kstest(wmCapacity(dataIn.(dataName{datax}),setx));
        %[corrCapacity.(dataName{datax}).(setSize{setx}).r,corrCapacity.(dataName{datax}).(setSize{setx}).p] = corr(wmCapacity(dataIn.(dataName{datax}),setx),slopeAll(dataIn.(dataName{datax}),:),'type','Spearman');
        [corrCapacity.(dataName{datax}).(setSize{setx}).r,corrCapacity.(dataName{datax}).(setSize{setx}).p] = corr(wmCapacity(dataIn.(dataName{datax}),setx),offsetAll(dataIn.(dataName{datax}),:),'type','Spearman');

    end
end
        
% Loop over data sets and set sizes for precision
for datax = 1:length(dataName)
    for setx = 1:length(setSize)
        [ksPrecision.(dataName{datax}).(setSize{setx}).h,ksPrecision.(dataName{datax}).(setSize{setx}).p] = kstest(precision(dataIn.(dataName{datax}),setx));
        %[corrPrecision.(dataName{datax}).(setSize{setx}).r,corrPrecision.(dataName{datax}).(setSize{setx}).p] = corr(precision(dataIn.(dataName{datax}),setx),slopeAll(dataIn.(dataName{datax}),:),'type','Spearman');
        [corrPrecision.(dataName{datax}).(setSize{setx}).r,corrPrecision.(dataName{datax}).(setSize{setx}).p] = corr(precision(dataIn.(dataName{datax}),setx),offsetAll(dataIn.(dataName{datax}),:),'type','Spearman');

    end
end

save('/projects/kg98/Thapa/Sherena/RESTDATAonly/3_Analyseddata/20To40Hz/corrCapacityvOffset.mat','corrCapacity','ID');
save('/projects/kg98/Thapa/Sherena/RESTDATAonly/3_Analyseddata/20To40Hz/corrPrecisionvOffset.mat','corrPrecision','ID');

