clc; clear all; close all;

% ##### STEP 3: RUN FASTICA #####

% Set paths, and conditions
addpath ('/projects/kg98/Thapa/GWM/Scripts/eeglab14_1_2b/');
addpath('/projects/kg98/Thapa/GWM/Scripts/FastICA_25/');

ID = {'012'; '085'}; %062: missing .dat file; 066: missing EEG data

eeglab;

for idx = 1:length(ID)
    
    % Step 1: load data
    EEG = pop_loadset( 'filename', [ID{idx},'_rest_ds_filt_ep_clean1.set'], 'filepath', ['/projects/kg98/Thapa/GWM/RESTDATAonly/3_AnalysedEEGdata/',ID{idx},filesep]);

    % Step 2: Run FastICA
    EEG = pop_tesa_fastica( EEG, 'approach', 'symm', 'g', 'tanh', 'stabilization', 'off' );

    % Step 3: Save data
    EEG = pop_saveset( EEG, 'filename', [ID{idx},'_rest_ds_filt_ep_clean1_ica.set'], 'filepath', ['/projects/kg98/Thapa/GWM/RESTDATAonly/3_AnalysedEEGdata/',ID{idx},filesep]);
    
    %Print participant finished
    fprintf('%s completed\n',ID{idx});
    
end