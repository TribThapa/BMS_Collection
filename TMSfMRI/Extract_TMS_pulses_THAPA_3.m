clear all; clc;

%Extract time for every TMS pulse_TMS/fMRI project

% Settings
inputPath = 'C:\Users\Tribikram Thapa\Desktop\'; %location of the text file
fileName = 'Pseudo_sham.log';
condName = 'Pseudo_sham'; %name of the condition i.e., stim or rest or sham
projName = 'MRH046'; %this will stay consistent for this project MRH046
id = '_Pilot009_MR02_'; %change participant ID

% Add script folder to path
addpath('C:\Users\Tribikram Thapa\Desktop\Thapa\Monash_Research Officer\Studies\1_TMS-fMRI project\5. Scripts and data analysis\Extract TMS timing');

% Import txt file to matlab
importedText = importTriggerFile([inputPath,projName,id,fileName]); %importTriggerFile
%importedText = importTriggerFile([inputPath,fileName]); %importTriggerFile

ind = strcmp('TMS_Pulse',importedText(:,4)); %locate TMS_Pulse in imported text file in column 4

pulsetime = double(importedText(ind,5)); %locate TMS_Pulse timing in imported text file in column 5

onsets{1} = pulsetime'./10000; %convert time to seconds and transpose to multiple columns
durations{1} = zeros(1,length(pulsetime));
names{1} = condName;

save([inputPath,'stimuli_',id,'_',condName,'.mat'],'onsets','durations','names');
%save([inputPath,'stimuli_','_',condName,'.mat'],'onsets','durations','names');