clear; close all; clc;

% Load the data
load('/projects/kg98/Thapa/Sherena/RESTDATAonly/3_Analyseddata/20To40Hz/slopeAll.mat');
load('/projects/kg98/Thapa/Sherena/RESTDATAonly/3_Analyseddata/20To40Hz/offsetAll.mat');
load('/projects/kg98/Thapa/Sherena/RESTDATAonly/3_Analyseddata/20To40Hz/freqAll.mat');

% Add slope to freq data structure
freqAll.slope = slopeAll;
freqAll.offset = offsetAll;

% Input names
namesIn = {'slope'; 'offset'; 'delta'; 'theta'; 'alpha'; 'beta'; 'gamma'};

% Plot the results using EEGLAB
addpath('/projects/kg98/Thapa/Sherena/Scripts/eeglab14_1_1b');
eeglab

EEG = pop_loadset('filename','001_rest_ds_filt_ep_clean1_ica_clean2_avref.set','filepath','/projects/kg98/Thapa/Sherena/RESTDATAonly/3_Analyseddata/20To40Hz/001/');

MAP = colormap;

figure('color','w');
for namex = 1:length(namesIn)
    
    subplot(2,4,namex)
    topoplot(mean(freqAll.(namesIn{namex}),1),EEG.chanlocs,'colormap',MAP,'maplimits','maxmin'); %'maxmin', [-1.5,1.5]);
    cb = colorbar;
    title(namesIn{namex});
    
    if namex == 1
        title(cb,'slope');
    else
        title(cb,'(\muV/Hz)^2');
    end
    
    
end

set(gcf,'color','w');
set(gcf,'position',[670,386,1061,423]);
set(gcf,'PaperPositionMode','auto');
print(gcf,'-dpng','/projects/kg98/Thapa/Sherena/RESTDATAonly/3_Analyseddata/20To40Hz/NewAnalysis_20To40Hz');
