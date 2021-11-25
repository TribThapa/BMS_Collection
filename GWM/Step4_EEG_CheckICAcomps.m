clc; clear all; close all;

% ##### STEP 4: CHECK ICA COMPONENTS #####

% Set paths, and conditions
addpath ('/projects/kg98/Thapa/GWM/Scripts/eeglab14_1_1b/');

ID = {'012'; '085'}; %062: missing .dat file; 066: missing EEG data

eeglab;

for idx = 1:length(ID)
    
    % Step 1: load data
    EEG = pop_loadset( 'filename', [ID{idx},'_rest_ds_filt_ep_clean1_ica.set'], 'filepath', ['/projects/kg98/Thapa/GWM/RESTDATAonly/3_AnalysedEEGdata/',ID{idx},filesep]);

    % Step 2: Run FastICA
    EEG = pop_tesa_compselect( EEG,'compCheck','on','remove','on','saveWeights','off','figSize','medium','plotTimeX',[0 500],'plotFreqX',[1 45],'freqScale','log','tmsMuscle','off','tmsMuscleThresh',8,'tmsMuscleWin',[11 30],'tmsMuscleFeedback','off','blink','on','blinkThresh',2.5,'blinkElecs',{'Fp1','Fp2'},'blinkFeedback','off','move','on','moveThresh',2,'moveElecs',{'F7','F8'},'moveFeedback','off','muscle','on','muscleThresh',-0.31,'muscleFreqIn',[7 45],'muscleFreqEx',[],'muscleFeedback','off','elecNoise','on','elecNoiseThresh',4,'elecNoiseFeedback','off' );

    % Step 3: Save data
    EEG = pop_saveset( EEG, 'filename', [ID{idx},'_rest_ds_filt_ep_clean1_ica_clean2 .set'], 'filepath', ['/projects/kg98/Thapa/GWM/RESTDATAonly/3_AnalysedEEGdata/',ID{idx},filesep]);
    
    %Print participant finished
    fprintf('%s completed\n',ID{idx});
    
end