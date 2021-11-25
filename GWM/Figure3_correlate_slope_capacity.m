clear; close all; clc;

% Load the data
load('/projects/kg98/Thapa/Sherena/RESTDATAonly/3_Analyseddata/4_20to40Hz/corrCapacityvSlope.mat');
%load('/projects/kg98/Thapa/Sherena/RESTDATAonly/3_Analyseddata/4_20to40Hz/corrCapacityvOffset.mat');

% Data to plot
dataPlot = {'data1','load2';...
    'data1','load4';...
    'data1','load6'};%...

% Plot the results using EEGLAB
addpath('/projects/kg98/Thapa/Sherena/Scripts/eeglab14_1_1b');
eeglab

EEG = pop_loadset('filename','001_rest_ds_filt_ep_clean1_ica_clean2_avref.set','filepath','/projects/kg98/Thapa/Sherena/RESTDATAonly/3_Analyseddata/4_20to40Hz/001/');
MAP = colormap;

figure('color','w');

for plotx = 1:length(dataPlot)
    
    subplot(1,3,plotx)
    topoplot(corrCapacity.(dataPlot{plotx,1}).(dataPlot{plotx,2}).r,EEG.chanlocs,'colormap',MAP,'maplimits',[-1,1]); 
    cb = colorbar;
    title(cb,'rho');
    
    if plotx == 1
        text(0,0.7,'Load 2','horizontalalignment','center','fontsize',16);
        %text(-1,0,{'n = 92'},'horizontalalignment','center','fontsize',16);
    elseif plotx == 2
        text(0,0.7,'Load 4','horizontalalignment','center','fontsize',16);
    elseif plotx == 3
        text(0,0.7,'Load 6','horizontalalignment','center','fontsize',16);
    end
    
end

set(gcf,'position',[356,161,1153,645]);
set(gcf,'color','w');
set(gcf,'PaperPositionMode','auto');
print(gcf,'-dpng','/projects/kg98/Thapa/Sherena/RESTDATAonly/3_Analyseddata/4_20to40Hz/SlopevCapacity_20To40Hz_rho');

for plotx = 1:length(dataPlot)
    
    subplot(1,3,plotx)
    topoplot(corrCapacity.(dataPlot{plotx,1}).(dataPlot{plotx,2}).p,EEG.chanlocs,'colormap',MAP,'maplimits',[-1,1]);
    cb = colorbar;
    title(cb,'p-value');
    
    if plotx == 1
        text(0,0.7,'Load 2','horizontalalignment','center','fontsize',16);
        %text(-1,0,{'n = 92'},'horizontalalignment','center','fontsize',16);
    elseif plotx == 2
        text(0,0.7,'Load 4','horizontalalignment','center','fontsize',16);
    elseif plotx == 3
        text(0,0.7,'Load 6','horizontalalignment','center','fontsize',16);
    end
    
end

set(gcf,'position',[356,161,1153,645]);
set(gcf,'color','w');
set(gcf,'PaperPositionMode','auto');
print(gcf,'-dpng','/projects/kg98/Thapa/Sherena/RESTDATAonly/3_Analyseddata/4_20to40Hz/SlopevCapacity_20To40Hz_pval');