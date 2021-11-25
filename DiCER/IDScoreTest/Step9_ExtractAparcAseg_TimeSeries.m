clc; clear all; close all;

Dataset_Dir = ('/projects/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/3_IdentificationScoreTest/4_UCLA_Aparc/');

MatFile = ([Dataset_Dir, 'UCLA_time_series_four_groups.mat']);

load([MatFile]);

subID = table2cell(metadata(1:121, 1));

HealthySubs_TS = time_series(:,:, 1:121, 3);

for i=1:length(subID)
    
    Indv_TS = HealthySubs_TS(:,:,i);
    
    dlmwrite([Dataset_Dir,subID{i},'/',subID{i},'AROMA+2P+DiCER_Aparc_ts.txt' ], Indv_TS);

end

