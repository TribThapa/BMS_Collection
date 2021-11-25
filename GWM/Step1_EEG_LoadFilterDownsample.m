clc; clear all; close all;

% ##### STEP 1: LOAD DATA, DOWNSAMPLE, FILTER, EPOCH #####

% Set paths, and conditions
addpath ('/projects/kg98/Thapa/GWM/Scripts/eeglab14_1_2b/');
pathIn = ('/projects/kg98/Thapa/GWM/RESTDATAonly/1_Rawdata/');

%ID = {'GWM001_REST'}; % activate if preprocessing a single participant  
ID = {'012'; '085'}; %062: missing .dat file; 066: missing EEG data

for idx = 1:length(ID)
    
    % Step 1: Open EEGLAB
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    
    % Step 2: Load raw data
    %EEG = loadcurry([pathIn, ID filesep ID, '.dap', 'CurryLocations', 'False']);
    EEG = loadcurry([pathIn, 'GWM', ID{idx}, '_REST', filesep, 'GWM' ID{idx}, '_REST.dap', 'CurryLocations', 'False']);
    
    % Step 3: Resample data to 1000
    EEG = pop_resample( EEG, 1000);
    
    % Step 4: Filter data between 1 to 45 Hz
    EEG = pop_eegfiltnew(EEG, 1,45,3300,0,[],1);
    
    % Step 5: Add an event marker every 2 s between the start and end of the recording
    currentEvents = [EEG.event.type];
    [~,iStart] = min(abs(currentEvents - 200001)); % Find the event row with the start marker. Should result 0.
    [~,iEnd] = min(abs(currentEvents - 200002)); % Find the event row with the end marker. Should result in 1.
    
    % If the end marker is missing, make it the last data point
    if isequal(iStart,iEnd)
        x=1;
        EEG.event(x+length(currentEvents)).latency = EEG.times(end);
        EEG.event(x+length(currentEvents)).type = 200002;
        EEG.event(x+length(currentEvents)).urevent = x+length(currentEvents);
        EEG.urevent(x+length(currentEvents)).latency = EEG.times(end);
        EEG.urevent(x+length(currentEvents)).type = 200002;
        currentEvents = [EEG.event.type];
        [~,iEnd] = min(abs(currentEvents - 200002));
    end
    
    eventTimes = EEG.event(iStart).latency:2000:EEG.event(iEnd).latency-2000; % Create a vector with values every 2000 ms from the start of the recording period to the end (-2000ms).
    
    for x = 1:length(eventTimes)
        EEG.event(x+length(currentEvents)).latency = eventTimes(x);
        EEG.event(x+length(currentEvents)).type = 1;
        EEG.event(x+length(currentEvents)).urevent = x+length(currentEvents);
        EEG.urevent(x+length(currentEvents)).latency = eventTimes(x);
        EEG.urevent(x+length(currentEvents)).type = 1;
    end
    
    % Step 6: Epoch data
    EEG = pop_epoch( EEG, {  '1'  }, [0  2], 'newname', 'Neuroscan Curry file resampled epochs', 'epochinfo', 'yes');
    
    % Step 7: Save data
    mkdir('/projects/kg98/Thapa/GWM/RESTDATAonly/analysedEEGdata/',ID{idx});
    EEG = pop_saveset( EEG, 'filename',[ID{idx},'_rest_ds_filt_ep.set'],'filepath',['/projects/kg98/Thapa/GWM/RESTDATAonly/3_AnalysedEEGdata/',ID{idx},filesep]);
    
end
