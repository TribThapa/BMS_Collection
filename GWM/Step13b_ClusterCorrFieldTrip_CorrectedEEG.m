clc; clear all; close all

% Define paths.
addpath('/projects/kg98/Thapa/GWM/Scripts/FieldTrip/fieldtrip');
DataDir = ['/home/ttha0011/kg98/Thapa/GWM/RESTDATAonly/'];
FieldTripDir = [DataDir,'FieldTrip/'];

ID ={'001'; '005'; '007'; '008'; '009'; '010'; '011'; '013'; '014'; '015'; '016'; '017'; '018'; '019'; '020'; '021'; '022'; '023'; '024'; '025'; 
     '026'; '027'; '028'; '029'; '031'; '032'; '033'; '034'; '035'; '036'; '037'; '038'; '039'; '040'; '041'; '043'; '044'; '045'; '046'; '047'; 
     '048'; '049'; '050'; '051'; '052'; '053'; '054'; '055'; '056'; '057'; '058'; '059'; '061'; '063'; '064'; '065'; '067'; '068'; '069'; '070'; 
     '071'; '072'; '073'; '074'; '075'; '076'; '077'; '078'; '079'; '080'; '081'; '082'; '083'; '084'; '086'; '087'; '088'; '089'; '090'; '091';
     '092'; '093'; '094'; '095'; '096'; '097'; '098'; '099'; '100'; '101'; '102'; '103'; '104'; '105'; '108'; '109'; '110'; '111'; '112'; '113'; 
     '114'; '115'; '116'; '117'; '118'; '119'; '120'; '121'; '122'; '123'; '124'; '125'; '126'; '127'; '128'; '129'; '130'; '131'; '132'; '133'; 
     '134'; '135'; '136'; '137'; '138'; '139'};

% Load files.
freq = ['2To40Hz_Knee'];

load([DataDir,'3_AnalysedEEGdata/',freq,'/CorrectedData.mat']);

CDT_FSEs = readtable([DataDir,'4_ChangeDetectionTask/WMC_and_CDT_FSEs_29092020.csv']);

load('/projects/kg98/Thapa/GWM/Scripts/eeglabChans'); %All 'z' should be in caps ('Z').
elec = load(['/projects/kg98/Thapa/GWM/Scripts/elec.mat']);

% Name EEG and task data. 
EEG_data = correctedPower.gamma'; %try correlating with the actual oscillation values.
B_data = CDT_FSEs;
Col = 2; %Select column to correlate

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
MatchIDs = [B_dataID, ID_num'];

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

%saveas(gcf,[DataDir, '16_Figures/',freq,'_CDT_FSEsvsCorrectedEEG_',ColNames{Col},'.png']);



