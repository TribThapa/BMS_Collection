clc; clear all; close all;

% ##### STEP 5: CHECK ICA COMPONENTS #####

% Set paths, and conditions
addpath ('/projects/kg98/Thapa/GWM/Scripts/eeglab14_1_1b/');
pathIn = ('/projects/kg98/Thapa/GWM/RESTDATAonly/3_AnalysedEEGdata/');

ID = {'012'; '085'}; %062: missing .dat file; 066: missing EEG data

eeglab;

for idx = 1:length(ID)
    
    % Step 1: load data
    EEG = pop_loadset( 'filename', [ID{idx},'_rest_ds_filt_ep_clean1_ica_clean2 .set'], 'filepath', ['/projects/kg98/Thapa/GWM/RESTDATAonly/3_AnalysedEEGdata/',ID{idx},filesep]);
    
    % Step 2: Load data with all electrodes
    EEG1 = pop_loadset( 'filename', [ID{idx},'_rest_ds_filt_ep.set'], 'filepath', ['/projects/kg98/Thapa/GWM/RESTDATAonly/3_AnalysedEEGdata/',ID{idx},filesep]);
    
    % Step 3: Interpolate missing channels
    EEG = pop_interp(EEG, EEG1.chanlocs, 'spherical');
    
    % Step 4: Rereference to average
    EEG = pop_reref( EEG, []);
    
    % Step 5: Save data
    EEG = pop_saveset( EEG, 'filename', [ID{idx},'_rest_ds_filt_ep_clean1_ica_clean2_avref.set'], 'filepath', ['/projects/kg98/Thapa/GWM/RESTDATAonly/3_AnalysedEEGdata/',ID{idx},filesep]);

    % Step 6: Calculate pwelch
    for chanx = 1:size(EEG.data,1)
        eegData = squeeze(EEG.data(chanx,:,:));
        [pxx,fp] = pwelch(eegData,2000,[],[],EEG.srate); 
        psds(:,chanx) = mean(pxx,2);
        freqs(:,chanx) = fp;
    end
    
    % Step 7: Save pwelch output for FOOOF
    save(['/projects/kg98/Thapa/GWM/RESTDATAonly/3_AnalysedEEGdata/',ID{idx},filesep,ID{idx},'_rest_pwelch_output.mat'],'psds','freqs');
    
    % Step 8: Print participant finished
    fprintf('%s completed\n',ID{idx});
    
    % Step 9: Create subplots with normal scale between 0-45 Hz, and the log-log scale of 0-45 Hz.
    subplot(2,1,1)    
    plot (freqs(1:95,7),psds(1:95,7));
    xlabel('Frequency', 'FontSize', 3);
    ylabel('Power spectral density (Pxx)', 'FontSize', 3);
    title([ID{idx},' P3 Normal Scale spectra 2000']); 
    ax = gca;
    ax.FontSize=6;
    
    subplot(2,1,2)
    plot(log(freqs(1:95,7)),log(psds(1:95,7)));  
    xlabel('Log Frequency', 'FontSize', 3);
    ylabel('Log Power spectral density (Pxx)', 'FontSize', 3);
    title([ID{idx},' P3 Log Scale spectra 2000']); 
    bx = gca;
    bx.FontSize=6;
    
    % Step 10: Save subplots
    saveas(gcf, ['/projects/kg98/Thapa/GWM/RESTDATAonly/3_AnalysedEEGdata/',ID{idx},filesep,ID{idx},'_spectra_2000'], 'png');
    cd (['/projects/kg98/Thapa/GWM/RESTDATAonly/3_AnalysedEEGdata/',ID{idx}]);
    delete([ID{idx},'_spectra 2000.png']);
    
end