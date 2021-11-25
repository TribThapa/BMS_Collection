clear; clc; close all;

% Script for building a neighbour template

addpath('/projects/kg98/Thapa/GWM/Scripts/FieldTrip/fieldtrip');
ft_defaults;

cfg = [];
cfg.method      = 'distance';
cfg.neighbourdist = 0.135; % This is the distance setting in mm
cfg.elec = ft_read_sens('/projects/kg98/Thapa/GWM/RESTDATAonly/3_AnalysedEEGdata/1To40Hz/001/001_rest_ds_filt_ep_clean1_ica_clean2_avref.set'); %Need to load an eeglab file here which has all of your electrode locations
cfg.layout = ft_prepare_layout(cfg);
cfg.feedback = 'yes';

cfg.layout = ft_prepare_layout(cfg);

cfg.channel= {'all'};
%cfg.feedback    = 'yes';  
neighbours      = ft_prepare_neighbours(cfg); %Need to replace ALL_m1 with whatever the variable name is for your field trip file

%Now there should be a neighbours variable. The first column gives each
%electrode, the cell in the second column gives all of the electrodes
%considered a neighbour to the electrode on the left column.

%Plot the electrodes and neighbours
cfg.neighbours=neighbours;
ft_neighbourplot(cfg); %Need to replace ALL_m1 with whatever the variable name is for your field trip file

%%

% Remove the F3-F7 connection
neighbours(3).neighblabel(1) = [];
neighbours(11).neighblabel(1) = [];

% Remove the F4-F8 connection
neighbours(4).neighblabel(1) = [];
neighbours(12).neighblabel(1) = [];

% Remove the P3-P7 connection
neighbours(7).neighblabel(1) = [];
neighbours(15).neighblabel(1) = [];

% Remove the P4-P8 connection
neighbours(8).neighblabel(1) = [];
neighbours(16).neighblabel(1) = [];

cfg.neighbours=neighbours;
ft_neighbourplot(cfg);

% Save
save('/projects/kg98/Thapa/GWM/RESTDATAonly/neighbours_GWM.mat','neighbours');