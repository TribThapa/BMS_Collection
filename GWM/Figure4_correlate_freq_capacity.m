clear; close all; clc;

% Load the data
load('/projects/kg98/Thapa/Sherena/RESTDATAonly/3_Analyseddata/4_20to40Hz/corrFreq.mat');

% Set the frequency parameters
setSize = {'load2';'load4';'load6'};
freqBand = {'delta';'theta';'alpha';'beta';'gamma'};

% Data to plot
n = 0;
for x = 1:length(setSize)
    for y = 1:length(freqBand)
        n = n+1;
        
        dataPlot{n}{1} = freqBand{y};
        dataPlot{n}{2} = setSize{x};
        
    end
end

% Plot the results using EEGLAB
addpath('/projects/kg98/Thapa/Sherena/Scripts/eeglab14_1_1b');
eeglab

EEG = pop_loadset('filename','001_rest_ds_filt_ep_clean1_ica_clean2_avref.set','filepath','/projects/kg98/Thapa/Sherena/RESTDATAonly/3_Analyseddata/20To40Hz/001/');
MAP = colormap;

figure('color','w');
for plotx = 1:length(dataPlot)
    
    subplot(3,5,plotx)
    topoplot(corrFreq.data1.(dataPlot{plotx}{1}).(dataPlot{plotx}{2}).r,EEG.chanlocs,'colormap',MAP,'maplimits',[-1,1]);
    cb = colorbar;
    title(cb,'rho');
    
    if plotx == 1
        text(0,0.7,'delta','horizontalalignment','center','fontsize',16);
        text(-1,0,'load 2','horizontalalignment','center','fontsize',16);
    elseif plotx == 2
        text(0,0.7,'theta','horizontalalignment','center','fontsize',16);
    elseif plotx == 3
        text(0,0.7,'alpha','horizontalalignment','center','fontsize',16);
    elseif plotx == 4
        text(0,0.7,'beta','horizontalalignment','center','fontsize',16);
     elseif plotx == 5
        text(0,0.7,'gamma','horizontalalignment','center','fontsize',16);
     elseif plotx == 6
        text(-1,0,'load 4','horizontalalignment','center','fontsize',16);
     elseif plotx == 11
        text(-1,0,'load 6','horizontalalignment','center','fontsize',16);
    end
        
end

set(gcf,'position',[187,265,1514,537]);
set(gcf,'color','w');
set(gcf,'PaperPositionMode','auto');
print(gcf,'-dpng','/projects/kg98/Thapa/Sherena/RESTDATAonly/3_Analyseddata/20To40Hz/FreqvCapacity_20To40Hz_rho');

for plotx = 1:length(dataPlot)
    
    subplot(3,5,plotx)
    topoplot(corrFreq.data1.(dataPlot{plotx}{1}).(dataPlot{plotx}{2}).p,EEG.chanlocs,'colormap',MAP,'maplimits',[-1,1]);
    cb = colorbar;
    title(cb,'p-value');
    
    if plotx == 1
        text(0,0.7,'delta','horizontalalignment','center','fontsize',16);
        text(-1,0,'load 2','horizontalalignment','center','fontsize',16);
    elseif plotx == 2
        text(0,0.7,'theta','horizontalalignment','center','fontsize',16);
    elseif plotx == 3
        text(0,0.7,'alpha','horizontalalignment','center','fontsize',16);
    elseif plotx == 4
        text(0,0.7,'beta','horizontalalignment','center','fontsize',16);
     elseif plotx == 5
        text(0,0.7,'gamma','horizontalalignment','center','fontsize',16);
     elseif plotx == 6
        text(-1,0,'load 4','horizontalalignment','center','fontsize',16);
     elseif plotx == 11
        text(-1,0,'load 6','horizontalalignment','center','fontsize',16);
    end
        
end

set(gcf,'position',[187,265,1514,537]);
set(gcf,'color','w');
set(gcf,'PaperPositionMode','auto');
print(gcf,'-dpng','/projects/kg98/Thapa/Sherena/RESTDATAonly/3_Analyseddata/20To40Hz/FreqvCapacity_20To40Hz_pval');