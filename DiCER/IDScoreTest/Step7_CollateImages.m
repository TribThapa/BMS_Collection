clc; clear all; close all;

%Step 1: Set  path to parent directory.
PathIn = ('/projects/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/3_IdentificationScoreTest');

%Step 2: Enter SubjID.

Cond = {'24P_8P_preproc', 'AROMAnonaggr_preproc_2P', 'AROMAnonaggr_preproc_2P_GSR'};

AllFileNames = cell(length(Cond),1);

%Step 4: Create for loop
for i = 1:length(Cond)
    
    %Step 5: Full path to FOOOF outputs.
    ImgFolder = [PathIn,filesep,'2_UCLA_dataset/']; 
    
    A = imread([ImgFolder,'UCLA_task-rest_',Cond{i},'.png']);
    
    subplot(2, 2, i);
    
    imshow(A);
       
    saveas (gcf,[ImgFolder 'Merged_CorrPlots.png']);,

end

