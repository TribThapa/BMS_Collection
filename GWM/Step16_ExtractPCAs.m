clc; clear all; close all; 

% Define paths.
addpath ('/projects/kg98/Thapa/GWM/Scripts/eeglab14_1_2b/');
addpath('/projects/kg98/Thapa/GWM/Scripts/FieldTrip/fieldtrip');
DataDir = ['/home/ttha0011/kg98/Thapa/GWM/RESTDATAonly/'];
OutDir = ['/home/ttha0011/kg98/Thapa/GWM/RESTDATAonly/15_WMCestimates/'];
FieldTripDir = [DataDir,'FieldTrip/'];

% Load files.
freq = ['2To40Hz_Knee'];

load([DataDir,'3_AnalysedEEGdata/',freq,'/slopeAll.mat']);
load([DataDir,'3_AnalysedEEGdata/',freq,'/offsetAll.mat']);
elec = load(['/projects/kg98/Thapa/GWM/Scripts/elec.mat']);

%score= subject x component = you get as many components as there are channels. 
[coeff, score, latent, tsquared, explained] = pca(offsetAll); 

% Generate and save as csv file.
Table = table(ID,score(:, 1), score(:, 2), score(:, 3));
Table.Properties.VariableNames = {'ID', 'PC1', 'PC2', 'PC3'};

writetable(Table, [OutDir,'offsetAll_3PCs_', freq,'.csv']);

a = str2num((sprintf('%.6f',explained(1,1))));

% Save the data

close all;
PC = 3; 
F = figure;
%title(['Variance explained: ', num2str(str2num((sprintf('%.6f',explained(PC,1)))))]);
title(['Variance explained: ', (sprintf('%.6f',explained(PC,1)))]);

GrandAverage = [];
GrandAverage.individual = coeff(:,PC);
GrandAverage.time = 1;
GrandAverage.label = elec.elec.label;
GrandAverage.dimord = 'chan';

cfg.colorbar = 'yes';
cfg.layout = 'quickcap64.mat';
cfg.comment = 'no';

ft_topoplotER(cfg, GrandAverage);

saveas(gcf,[OutDir, freq,'_PC',num2str(PC),'_Offset.png']);
