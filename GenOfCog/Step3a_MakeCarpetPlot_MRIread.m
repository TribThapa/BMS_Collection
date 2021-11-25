clc; clear all; close all;

addpath('/usr/local/freesurfer/devel-20190128/matlab/')
setenv('TMP_DIR','~/');

% Step 1: Determine path to fMRIPrep's output directory
DataDir = ['/home/ttha0011/kg98/Thapa/GenOfCog/2_Tests/GenOfCog/3_CarpetPlots/'];

% Step 2: Enter subject ID
subID = {'sub-024'}; %'sub-GAB009'; 

for i = 1:length(subID)
    
        RegFolder= ['/home/ttha0011/kg98/kristina/GenofCog/datadir/derivatives/'];
     
        % Extract time series
        PreGSR_data = MRIread([RegFolder,subID{i},'/prepro.feat/filtered_func_data_clean_mni.nii.gz']); %Use MRIread to read in the nifti file.
              
        GSR_data = MRIread([RegFolder,subID{i},'/gsr/filtered_func_data_clean_gsr4_mni.nii.gz']); %Use MRIread to read in the nifti file.
        
        time_series1 = reshape(PreGSR_data.vol,prod(PreGSR_data.volsize),PreGSR_data.nframes);

        time_series2 = reshape(GSR_data.vol,prod(GSR_data.volsize),GSR_data.nframes);
        
        nz1=find(sum(time_series1,1)~=0);
        nz1=find(sum(time_series1,2)~=0);
        
        nz2=find(sum(time_series2,1)~=0);
        nz2=find(sum(time_series2,2)~=0);
        %gs=mean(zscore(time_series(nz1,:),[],2));
%         
%       % Generate figures
        subplot1 = subplot(2,1,1);
        imagesc(zscore(time_series1(nz1,:),[],2));caxis(1.2*[-1 1]);
        caxis(1.2*[-1 1]);
        title([subID{i} ' Pre GSR']);
        colormap gray;

        subplot2 = subplot(2,1,2);
        imagesc(zscore(time_series2(nz2,:),[],2));caxis(1.2*[-1 1]);
        caxis(1.2*[-1 1]);
        title([subID{i} ' GSR']);
        colormap gray;
        
        saveas(gcf, [DataDir, subID{i}, '_MRIread.png']);
        
        %saveas(gcf,[DataDir,'15_WMCestimates/2_Top3PCs_30092020/WMC_CDT_vs_SlopeOffsetPCs.png']);
    
end

