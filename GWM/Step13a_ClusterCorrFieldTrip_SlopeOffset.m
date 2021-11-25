clc; clear all; close all

% Define paths.
addpath('/projects/kg98/Thapa/GWM/Scripts/FieldTrip/fieldtrip');
DataDir = ['/home/ttha0011/kg98/Thapa/GWM/RESTDATAonly/'];
FieldTripDir = [DataDir,'FieldTrip/'];

% Load files.
freq = ['2To40Hz_Knee'];

load([DataDir,'3_AnalysedEEGdata/',freq,'/slopeAll.mat']);
load([DataDir,'3_AnalysedEEGdata/',freq,'/offsetAll.mat']);

CDT = readtable([DataDir,'4_ChangeDetectionTask/ChangeDetectionTaskAll.csv']);
%CDT_FSEs = readtable([DataDir,'4_ChangeDetectionTask/WMC_and_CDT_FSEs_29092020.csv']);
% CWT = readtable([DataDir,'5_ColourWheelTask/ColourWheelTaskAll.csv']);
% BarT = readtable([DataDir,'6_BarTask/BarTaskAll.csv']);
% BarT_FSEs = readtable([DataDir,'6_BarTask/BarTaskFactorScoreEstimates.csv']);
% nBackT = readtable([DataDir,'8_NbackTask/NbackTaskAll.csv']);
% SSRT = readtable([DataDir,'9_StopSignalReactionTask/StopSignalReactionTaskAll.csv']);
% SymSpanT = readtable([DataDir,'10_SymmetrySpanTask/SymmetrySpanTaskAll.csv']);
% OSpanT = readtable([DataDir,'11_OperationSpanTask/OperationSpanTaskAll.csv']);
% BDS = readtable([DataDir,'12_BackwardsDigitSpanTask/BackwardsDigitSpanTaskAll.csv']);
% SimonT = readtable([DataDir,'13_SimonTask/SimonTaskAll.csv']);
% GNG = readtable([DataDir,'14_GoNoGoTask/GoNoGoTaskAll.csv']);
% WMCestimates = readtable([DataDir,'15_WMCestimates/WMCFactorScoreEstimates.csv']);
% WMCestimates_CWT = readtable([DataDir,'15_WMCestimates/WMCFactorScoreEstimates_CWT.csv']);

load('/projects/kg98/Thapa/GWM/Scripts/eeglabChans'); %All 'z' should be in caps ('Z').
elec = load(['/projects/kg98/Thapa/GWM/Scripts/elec.mat']);

% Name EEG and task data. 
EEG_data = offsetAll'; %try correlating with the actual oscillation values.
B_data = CDT;
Col = 3; %Select column to correlate

ColNames = B_data.Properties.VariableNames;
fprintf('\nBehav data to analyse is %s\n', ColNames{Col});

% Remove '035', '62', and '066' from the task dataset. Their EEG data is missing.
B_data(B_data.ID(:,1) == 35, :) = [];
B_data(B_data.ID(:,1) == 62, :) = [];
B_data(B_data.ID(:,1) == 66, :) = [];
Behav_data = B_data{:, :}';

for i = 1:length(ID)
    
    ID_num(i) = str2num(ID{i});
    
end

% Convert Behav_ID table to double
B_dataID = table2array(B_data(:,1));

% Check BehavIDs match EEG data IDs
if ~isequal(B_dataID, ID_num')
    error('\nIDs dont match\n')
end


%Select task data.
Behav_data = Behav_data(Col, :);

%Identify and remove NANs from task data.
nanlog = find(isnan(Behav_data));

%Create new task and EEG data with NANs removed.
Behav_data(nanlog) = [];
EEG_data(:, nanlog) = [];

label = eeglabChans;
for idx = 1:size(EEG_data,2)
    myData{idx}.label = eeglabChans;
    myData{idx}.powspctrm = EEG_data(:,idx);
    myData{idx}.freq = 1;
    myData{idx}.dimord = 'chan_freq' ; 
    myData{idx}.elec = elec.elec;
end

neighbours = load(['/projects/kg98/Thapa/GWM/Scripts/neighbours_GWM.mat']); 
% --------------------------------------------------------------------------------------------------
% Do the stat
ft_defaults;
cfg = [];
cfg.avgovergfreq = 'yes';
cfg.channel = {'all'};
cfg.method = 'montecarlo'; 
cfg.statistic = 'ft_statfun_correlationT'; %'ft_statfun_correlationT'; 
cfg.correctm = 'cluster'; % is influecing the p-values. 'holm' is closest to result from [r1,p1] = corr(wm_load(:,2),offsetAll);
cfg.clusteralpha = 0.05; 
cfg.clusterstatistic = 'maxsum'; 
cfg.clustertail = 0;
cfg.minnbchan = 2; 
cfg.neighbours = neighbours.neighbours; 
cfg.alpha = 0.05; 
cfg.tail = 0; %
cfg.correcttail = 'prob';
cfg.numrandomization = 1000;  
subj = size(EEG_data,2); % ## length(ID);
design(1,1:subj) = Behav_data;  
cfg.design = design'; % design matrix.
cfg.ivar  = 1;  % number or list with in dices indicating the independent variable(s)
stat = ft_freqstatistics(cfg, myData{:}); % If data is time-amplitude change it to ft_timelockstatistics

% --------------------------------------------------------------------------------------------------
% Look for clusters

% First ensure the channels to have the same order in the average and in the statistical output.
[i1,i2] = match_str(eeglabChans, stat.label);

% Find the elecrodes within significant positive or negetive clusters
if ~isempty(stat.posclusters)
    pos_cluster_pvals = [stat.posclusters(:).prob];
    pos_signif_clust = find(pos_cluster_pvals < stat.cfg.alpha);
    pos = ismember(stat.posclusterslabelmat, pos_signif_clust);
    pos_int(i1) = all(pos(i2, 1), 2);
end

if ~isempty(stat.negclusters)
    neg_cluster_pvals = [stat.negclusters(:).prob];
    neg_signif_clust = find(neg_cluster_pvals < stat.cfg.alpha);
    neg = ismember(stat.negclusterslabelmat, neg_signif_clust);
    neg_int(i1) = all(neg(i2, 1), 2);
end

%---------------------------------------------------------------------------------------------------
% Plot 
close all;
F = figure;
cfg = [];
cfg.highlight = 'on';
% Highlight the identified clusters
if ~exist('pos_int','var')
    cfg.highlightchannel = find(neg_int);
elseif ~exist('neg_int','var')
    cfg.highlightchannel = find(pos_int);
else
    cfg.highlightchannel = find(pos_int|neg_int);
end
cfg.highlightsymbol = '.';   
cfg.highlightcolor = 'red';
cfg.highlightsize = [15];
cfg.colorbar = 'yes';
cfg.colorbartext = 'rho value';
cfg.parameter = 'rho';
cfg.layout = 'quickcap64.mat'; %'easycapM11.mat';
cfg.comment = 'no';
ft_topoplotER(cfg, stat);

%saveas(gcf,[DataDir, '16_Figures/',freq,'_CDT_FSEsvsOffset_',ColNames{Col},'.png']);





