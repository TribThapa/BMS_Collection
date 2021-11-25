clc; clear all; close all
rng('default')

%Step 1: Set paths.
ParentDir = ('/projects/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/3_IdentificationScoreTest/');
DataDir = ([ParentDir,'2_UCLA_dataset/']);
OutDir = [DataDir,'Figures/'];

SubjectList = dir([DataDir,'sub-1*']); %5=SZ; 6=BPD; 7=ADHD
subID = extractfield(SubjectList,'name');

RhoDir = [ParentDir,'ScriptsUsed/KevExample/'];
addpath(genpath(RhoDir));

MetaData = cell2table(subID');
NumSubs = size(MetaData,1);

for i = 1:NumSubs
    
    tic; 
    
    Variant = {'AROMAnonaggr_preproc+2P_detrended_hpf'};

    for j = 1:length(Variant)
    
    %Folders.
    %AnatDir = [DataDir,MetaData.Var1{i,1},'/anat/'];
    FuncDir = [DataDir,MetaData.Var1{i,1},'/func/'];
    DBScanDir = [DataDir,MetaData.Var1{i,1},'/dbscan/'];
    TimeSeriesDir = [DataDir,MetaData.Var1{i,1},'/TimeSeries/'];
 

    %Define Files.
    mask = [DBScanDir, MetaData.Var1{i,1},'_bold_space-MNI152NLin2009cAsym_dtissue_masked.nii.gz'];
    func = [DBScanDir, MetaData.Var1{i,1},'_task-rest_bold_space-MNI152NLin2009cAsym_variant-',Variant{j},'.nii.gz'];
    Confounds = tdfread([FuncDir,MetaData.Var1{i,1},'_task-rest_bold_confounds.tsv']);
    
    %Calculate standard deviation for GSR.
    MetaData.GSSD(i) = std(Confounds.GlobalSignal);
    
 
    %Calculate first principle component.
    TimeSeries = dlmread([TimeSeriesDir,MetaData.Var1{i,1},'_task-rest_variant-',Variant{j},'_Schaefer_ts.txt'])';  
    FC(:,:,i) = corr(TimeSeries);
    [coef,score,~,~,explained] = pca(zscore(TimeSeries).');
    MetaData.FirstPC(i) = explained(1); 
    
    %Calculate Rho.
    [Rho] = calculate_rho(func, mask);
    MetaData.Rho(i) = Rho(1);
    
    end       
end


plot3(MetaData.GSSD,MetaData.FirstPC,MetaData.Rho, 'o', 'Color', 'r');
xlabel('GSR StdDev')
ylabel('VE1')
zlabel('Rho')
grid on
saveas(gcf,[OutDir,'GSSD_PC_Rho'],'jpg');
toc; 

