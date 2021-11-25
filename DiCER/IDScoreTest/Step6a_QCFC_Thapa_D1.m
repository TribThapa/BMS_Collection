% ------------------------------------------------------------------------------
% Linden Parkes, Brain & Mental Health Laboratory, 2017
% ------------------------------------------------------------------------------
clear all; close all; clc
rng('default')

%Step 1: Set paths.
parentdir = '/projects/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/3_IdentificationScoreTest/';
ROIDir = [parentdir,'ScriptsUsed/ROIs/'];
scriptdir = [parentdir,'ScriptsUsed/rs-fMRI/'];
addpath(genpath(scriptdir))

%Step 2: Enter project name. 
Projects = {'UCLA'}; %'GSR','Cambridge_MultiEcho'};
WhichProject = Projects{1};

%Step 3: Define parcellation to use. 
WhichParc = 'Gordon'; % 'Gordon' 'Power'

%Step 4: Define project variables.
switch WhichProject
    case 'UCLA'
        datadir = [parentdir,'3_UCLA_dataset_GordonAtlas/'];
        derivsdir = [datadir,'func/'];
        fltFile = [parentdir,'ScriptsUsed/SubjectIDs.txt'];;
        TR = 2;
end

%Step 5: Define parcellation charactersitics.
switch WhichParc
    case 'Gordon'
        parcFile = 'Parcels_MNI_222';
        ROI_Coords = dlmread([ROIDir,'Gordon/Gordon_Centroids.txt']);
    case 'Power'
        parcFile = 'Power';
        ROI_Coords = dlmread([ROIDir,'Power/Power2011_xyz_MNI.txt']);
end

%Step 6: Load ROI coordinates

%Step 7: Calculate pairwise euclidean distance
ROIDist = pdist2(ROI_Coords,ROI_Coords,'euclidean');

%Step 8: Flatten distance matrix i.e., gives you data above the diagonal.
ROIDistVec = LP_FlatMat(ROIDist);

%Step 9: Calculate number of ROIs
numROIs = size(ROIDist,1);

%Step 10: Calculate number of edges
numConnections = numROIs * (numROIs - 1) / 2;

fileID = fopen(fltFile); 
fltSubjects = textscan(fileID,'%s'); 
fltSubjects = fltSubjects{1};

metadata = cell2table(fltSubjects);

numSubs = size(fltSubjects,1);

% ------------------------------------------------------------------------------
% Exclusion
% ------------------------------------------------------------------------------
% Threshold for detecting 'spikes'
fdJenkThr = 0.25;
% threshold for mean FD
fdMeanThr = 0.2;
fdGrossThr = 5;

metadata.fdJenk = cell(numSubs,1); % add column to enter fdJenk values.
metadata.fdJenk_m = zeros(numSubs,1); % add column to enter fdJenk_m values.
metadata.exclude = zeros(numSubs,1); % add column to enter excluded values.

for i = 1:numSubs
    derivsdir_epi = [datadir,metadata.fltSubjects{i},'/func/'];
    TimeSeriesdir = [datadir,metadata.fltSubjects{i},'/dbscan/'];    

    conf = tdfread([datadir,metadata.fltSubjects{i},'/func/',metadata.fltSubjects{i},'_task-rest_bold_confounds.tsv']);
    mov = [conf.X, conf.Y, conf.Z, conf.RotX, conf.RotY, conf.RotZ];
    numVols = size(mov,1);

    % Get FD
    metadata.fdJenk{i} = GetFDJenk(mov); % gives you a vector representing the total framewise displacement.

    % Calculate mean
    metadata.fdJenk_m(i) = mean(metadata.fdJenk{i}); % gives you the mean framewise displacement from metadata.fdJenk column.
    
    metadata.FDfmriprep(i) = mean(str2num(conf.FramewiseDisplacement(2:end,:))); % gives you the mean framewise displacement from confounds file from fMRIPrep.              column.
    
    %Calculate GSSD
    metadata.GSSD(i) = std(conf.GlobalSignal); % std dev of global signal from the counfounds file from fMRIPrep.

    % ------------------------------------------------------------------------------
    % Stringent, multi criteria exclusion
    % ------------------------------------------------------------------------------
    % 1) Exclude on mean rms displacement
    % Calculate whether subject has suprathreshold mean movement
    % If the mean of displacement is greater than 0.2 mm (Ciric), then exclude
    if metadata.fdJenk_m(i) > fdMeanThr; x = 1; else x = 0; end 

    % 2) Exclude on proportion of spikes
    % Calculate whether subject has >20% suprathreshold spikes
    fdJenkThrPerc = round(numVols * 0.20);
    
    % If the number of volumes that exceed fdJenkThr are greater than %20, then exclude
    if sum(metadata.fdJenk{i} > fdJenkThr) > fdJenkThrPerc; y = 1; else y = 0; end

    % 3) Exclude on large spikes (>5mm)
    if any(metadata.fdJenk{i} > fdGrossThr); z = 1; else z = 0; end

    % If any of the above criteria are true of subject i, mark for exclusion
    if x == 1 | y == 1 | z == 1; metadata.exclude(i) = 1; else metadata.exclude(i) = 0; end
end

% metadata.exclude(72)=0;
fprintf(1, 'Excluded %u subjects \n', sum(metadata.exclude));
metadata = metadata(~metadata.exclude,:); numSubs = size(metadata,1);

% ------------------------------------------------------------------------------
% FC
% ------------------------------------------------------------------------------
% noiseOptions = {'AROMA+2P_dbscan','AROMA+2P','AROMA+2P+GSR','24P+8P','24P+8P+GSR'}; % note these MUST match those store in columns of cfg.roiTS
noiseOptions = {'24P+8P_preproc','AROMAnonaggr_preproc+2P+GSR','AROMAnonaggr_preproc+2P'}; % note these MUST match those store in columns of cfg.roiTS
% noiseOptions = {'hpf_dbscan','hpf','hpf_gsr','hpf_aGMR'}; % note these MUST match those store in columns of cfg.roiTS
numPrePro = length(noiseOptions);

FC = zeros(numROIs,numROIs,numSubs,numPrePro);
%FC = zeros(numROIs,numROIs,numSubs,numPrePro);

for i = 1:numSubs
    % Load in time series data
    TimeSeriesdir = [datadir,metadata.fltSubjects{i},'/TimeSeries/'];

    % Compute correlations
    for j = 1:numPrePro
        TS = dlmread([TimeSeriesdir,metadata.fltSubjects{i},'_task-rest_variant-',noiseOptions{j},'_Gordon_ts.txt'])'; % to read your timeseries file. 
        FC(:,:,i,j) = corr(TS); 
        [coef,score,~,~,explained] = pca(zscore(TS).');
        first_pc(i,j) = explained(1);
        % Perform fisher z transform
        FC(:,:,i,j) = atanh(FC(:,:,i,j)); % Z transform of the func connectivity matrix
    end
end


% ------------------------------------------------------------------------------
% QC
% ------------------------------------------------------------------------------
allQC = struct('noiseOptions',noiseOptions,...
                'NaNFilter',[],...
                'QCFC',[],...
                'QCFC_PropSig_corr',[],...
                'QCFC_PropSig_unc',[],...
                'QCFC_AbsMed',[],...
                'QCFC_DistDep',[],...
                'QCFC_DistDep_Pval',[]);

for i = 1:numPrePro
% Using mFD calculated from fdJenk etc..
     [QCFC,P] = GetDistCorr(metadata.fdJenk_m,FC(:,:,:,i)); % corr each FC edge with distance.

%     Do this now with SD
%    [QCFC,P] = GetDistCorr(metadata.GSSD,FC(:,:,:,i));

%     Do this now with FD from fmriprep
   % [QCFC,P] = GetDistCorr(metadata.FDfmriprep,FC(:,:,:,i));

    
    % Flatten QCFC matrix
    allQC(i).QCFC = LP_FlatMat(QCFC);
    P = LP_FlatMat(P);

    % Filter out NaNs:
    allQC(i).NaNFilter = ~isnan(allQC(i).QCFC);
    if ~any(allQC(i).NaNFilter)
        error('FATAL: No data left after filtering NaNs!');
    elseif any(allQC(i).NaNFilter)
        fprintf(1, '\tRemoved %u NaN samples from data \n',sum(~allQC(i).NaNFilter));
        allQC(i).QCFC = allQC(i).QCFC(allQC(i).NaNFilter);
        P = P(allQC(i).NaNFilter);
    end

    % correct p values using FDR (false discovery rates)
    P_corrected = mafdr(P,'BHFDR','true');
    %allQC(i).QCFC_PropSig_corr = round(sum(P_corrected<0.05) / numel(P_corrected) * 100,2);
    allQC(i).QCFC_PropSig_unc = round(sum(P<0.05) / numel(P) * 100,2); % all edges with Pvalues < 0.05.

    % Find absolute median
    allQC(i).QCFC_AbsMed = nanmedian(abs(allQC(i).QCFC));

    % Find nodewise correlation between distance and QC-FC
    [allQC(i).QCFC_DistDep,allQC(i).QCFC_DistDep_Pval] = corr(ROIDistVec(allQC(i).NaNFilter),allQC(i).QCFC,'type','Spearman');
end

save([datadir,WhichProject,'_',WhichParc,'.mat']);