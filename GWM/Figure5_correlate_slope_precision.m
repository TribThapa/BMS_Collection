clear; close all; clc;

% Load the data
%load('/projects/kg98/Thapa/Sherena/RESTDATAonly/3_Analyseddata/3To30Hz/corrPrecisionvSlope.mat');
load('/projects/kg98/Thapa/Sherena/RESTDATAonly/3_Analyseddata/3To30Hz/corrPrecisionvOffset.mat');

% Data to plot
dataPlot = {'data1','load2';...
    'data1','load4';...
    'data1','load6'};

% Plot the results using EEGLAB
addpath('/projects/kg98/Thapa/Sherena/Scripts/eeglab14_1_1b');
eeglab

EEG = pop_loadset('filename','001_rest_ds_filt_ep_clean1_ica_clean2_avref.set','filepath','/projects/kg98/Thapa/Sherena/RESTDATAonly/3_Analyseddata/3To30Hz/001/');
MAP = colormap;

figure('color','w');
for plotx = 1:length(dataPlot)
    
    subplot(1,3,plotx)
    topoplot(corrPrecision.(dataPlot{plotx,1}).(dataPlot{plotx,2}).r,EEG.chanlocs,'colormap',MAP,'maplimits',[-1,1]);
    cb = colorbar;
    title(cb,'rho');
    
    if plotx == 1
        text(0,0.7,'Load 2','horizontalalignment','center','fontsize',16);
    elseif plotx == 2
        text(0,0.7,'Load 4','horizontalalignment','center','fontsize',16);
    elseif plotx == 3
        text(0,0.7,'Load 6','horizontalalignment','center','fontsize',16);
    end
        
end

set(gcf,'position',[357,393,1123,409]);
set(gcf,'color','w');
set(gcf,'PaperPositionMode','auto');
print(gcf,'-dpng','/projects/kg98/Thapa/Sherena/RESTDATAonly/3_Analyseddata/3_3to30Hz/OffsetvPrecision_3To30Hz_rho');

for plotx = 1:length(dataPlot)
    
    subplot(1,3,plotx)
    topoplot(corrPrecision.(dataPlot{plotx,1}).(dataPlot{plotx,2}).p,EEG.chanlocs,'colormap',MAP,'maplimits',[-1,1]);
    cb = colorbar;
    title(cb,'p-value');
    
    if plotx == 1
        text(0,0.7,'Load 2','horizontalalignment','center','fontsize',16);
    elseif plotx == 2
        text(0,0.7,'Load 4','horizontalalignment','center','fontsize',16);
    elseif plotx == 3
        text(0,0.7,'Load 6','horizontalalignment','center','fontsize',16);
    end
        
end

set(gcf,'position',[357,393,1123,409]);
set(gcf,'color','w');
set(gcf,'PaperPositionMode','auto');
print(gcf,'-dpng','/projects/kg98/Thapa/Sherena/RESTDATAonly/3_Analyseddata/3To30Hz/OffsetvPrecision_3To30Hz_pval');