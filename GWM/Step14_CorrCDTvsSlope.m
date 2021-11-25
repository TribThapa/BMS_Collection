clear; close all; clc;

% Load in the data

load('/projects/kg98/Thapa/GWM/RESTDATAonly/3_AnalysedEEGdata/1To40Hz/slopeAll.mat');
load('/projects/kg98/Thapa/GWM/RESTDATAonly/3_AnalysedEEGdata/1To40Hz/offsetAll.mat');
CDT = readtable('/projects/kg98/Thapa/GWM/RESTDATAonly/4_ChangeDetectionTask/ChangeDetectionTaskAll.csv');

CDT(CDT.ID(:,1) == 35, :) = [];
CDT(CDT.ID(:,1) == 62, :) = [];
CDT(CDT.ID(:,1) == 66, :) = [];
CDT = CDT{:, :};

% Read in all data. Note: no splits here.
set1slope = offsetAll(1:(size(offsetAll,1)),:);
set1wm = CDT(1:(size(offsetAll,1)),4); %Only loads load2 

% Data quality check
set1Log = set1wm>0.1;

% Remove bad data points
set1slope = set1slope(set1Log,:);
set1wm = set1wm(set1Log);

% Run Pearson's correlation between WMC and slope for each channel
[r1,p1] = corr(set1wm,set1slope);

% Plot the results using EEGLAB
addpath ('/projects/kg98/Thapa/GWM/Scripts/eeglab14_1_1b/');
eeglab

EEG = pop_loadset('filename','001_rest_ds_filt_ep_clean1_ica_clean2_avref.set','filepath','/projects/kg98/Thapa/GWM/RESTDATAonly/3_AnalysedEEGdata/1To40Hz/001/');
figure;topoplot(r1,EEG.chanlocs); title('Slope vs WMcapacity');
print(gcf,'-dpng','/projects/kg98/Thapa/GWM/RESTDATAonly/3_AnalysedEEGdata/1To40Hz/OffsetvsWMC_1To40Hz');

