clc; clear all; close all;

addpath('/usr/local/freesurfer/devel-20190128/matlab/')
setenv('TMP_DIR','~/');

% Step 1: Determine path to fMRIPrep's output directory
DataDir = ['/projects/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/1_CompareWhenToDenoise/2_SmoothAROMA_Output'];

% Step 2: Enter subject ID
subID = {'sub-GAB007', 'sub-GAB009'};

for i = 1:length(subID)

    % Step 3: Enter condition(s)
    cond = {'Rest3'}; %'Rest1'; 'Rest2'; 'Rest4'}; 
    
    for j = 1:length(cond)

        FuncDir= [DataDir filesep subID{i} filesep];
        
        % Extract framewise displacement, and global signal from fMRIPrep's .tsv file
        CSV_file = ([FuncDir subID{i} '_task-',cond{j},'_desc-confounds_regressors.tsv']);
        FileName = tdfread(CSV_file);
        FD = FileName.framewise_displacement;
        T = table(FileName.framewise_displacement);
        T = standardizeMissing(T,{'n/a', '0'});

        % Generate figures
        figure; 
        plot(str2num(T.Var1));
        xlabel('Volume');
        title([subID{i}  ' ',cond{j},' Framewise Displacement']);
      
        saveas(gcf, [FuncDir filesep '/Figures/' subID{i} '_' cond{j} '_FD'], 'png');
        
    end 
end


