clc; clear all; close all;

% ##### STEP 2: REMOVE BAD EPOCHS AND BAD CHANNELS #####

% Set paths, and conditions
addpath ('/projects/kg98/Thapa/GWM/Scripts/eeglab14_1_2b/');

%ID = {'001;'005';'007',..'008';'009'}; % Example of multiple participants
ID = {'012'; '085'}; %062: missing .dat file; 066: missing EEG data

eeglab;

for idx = 1:length(ID)
    
    % Step 1: load data
    EEG = pop_loadset( 'filename', [ID{idx},'_rest_ds_filt_ep.set'], 'filepath', ['/projects/kg98/Thapa/GWM/RESTDATAonly/3_AnalysedEEGdata/',ID{idx},filesep]);

    % Step 2: Highlight bad trails, and update marks to remove bad epochs
    pop_eegplot(EEG, 1, 1, 0);
    R1=input('Highlight bad trials, update marks and then press enter\n');
    EEG.BadTr=unique(find(EEG.reject.rejmanual==1));

    % Step 3: Reject bad epochs, and update dataset
    EEG=pop_rejepoch(EEG,EEG.BadTr,0);

    % Step 4: Check and remove bad channels
    answer = inputdlg('Enter bad channels', 'Bad channel removal', [1 50]);
    str = answer{1};
    EEG.badChan = strsplit(str);
    close all;
    EEG = pop_select( EEG,'nochannel',EEG.badChan);

    % Step 5: Save data
    EEG = pop_saveset( EEG, 'filename', [ID{idx},'_rest_ds_filt_ep_clean1.set'], 'filepath', ['/projects/kg98/Thapa/GWM/RESTDATAonly/3_AnalysedEEGdata/',ID{idx},filesep]);
    
    %Print participant finished
    fprintf('%s completed\n',ID{idx});
    
end