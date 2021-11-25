clc; clear all; close all;

addpath('/home/ttha0011/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/3_IdentificationScoreTest/ScriptsUsed/');

DataDir = ('/home/ttha0011/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/3_IdentificationScoreTest/5_HCP_dataset/');

% subID = dir([DataDir, '1*']);
% subID = extractfield(subID,'name');
subID = {'100206', '100610', '101006', '101309', '101915', '102311', '102513', '106016', '107321', '107422'};

OutDir = ([DataDir,'Figures/']);

%--------------------------------------------------------------------------------------------------------------------------------------------------
% Create M X N X P matrix, where P = subject.

% for i = 1:length(subID)
%            
%        % read in data
%        ts = dlmread([DataDir,subID{i},'/',subID{i},'_HCPparc_ts.txt']);                    
%        
%        FC_mat{i} = corrcoef(ts');  
%        
% end
% 
% FC_all = cat(3, FC_mat{1,:});
% 
% save([OutDir, 'FC_all.mat'], 'FC_all');

%--------------------------------------------------------------------------------------------------------------------------------------------------

FC_matrices = load([OutDir,'FC_all.mat']); 
%CSVFile = readtable([DataDir, 'HCP_s1200.csv']); 
%BehavData = CSVFile(:, {'WM_Task_0bk_Acc', 'WM_Task_0bk_Median_RT'});
%CovariateFile(:, {'Age', 'Gender'});

BehavData = readtable([DataDir, 'HCP_Behav.csv']); 
BehavData = BehavData{:,:};
CovariateData = readtable([DataDir, 'HCP_AgeSex.csv']); 
CovariateData = CovariateData{:,:}; 

% Split file

% subject_list = ([OutDir, 'SubjectIDs.txt']);
% family_csv = 'none';
% subject_header = '';
% family_header = '';
% num_folds = 5;
% seed = 1;
% outdir = OutDir;
% delimiter = '';
% sub_fold = CBIG_cross_validation_data_split(subject_list, family_csv, subject_header, family_header, num_folds, seed, outdir, delimiter );

%--------------------------------------------------------------------------------------------------------------------------------------------------

%Setup file

% load([OutDir, 'no_relative_5_fold_sub_list.mat']);
% covariates = CovariateData;
% feature_mat = FC_matrices.FC_all;
% ker_param.type = 'corr';
% ker_param.scale = 'Nan';
% lambda_set = [0,0.100000000000000,1,5,10,50,100,500,1000];
% num_inner_folds = 2;
% outdir = OutDir;
% threshold_set = [];
% y = BehavData;
% outstem = 'Test_10HCPsubs';
% save([OutDir, 'setup_file.mat']);

%--------------------------------------------------------------------------------------------------------------------------------------------------
%addpath('/home/ttha0011/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/3_IdentificationScoreTest/ScriptsUsed/Behav/ThapaTest/KernelRidgeRegression/');
%addpath ('/home/ttha0011/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/3_IdentificationScoreTest/ScriptsUsed/Behav/ThapaTest/utilities/');
%try manual loading and reading the setup_file
% add param.y to CBIG_KRR_workflow.m

CBIG_KRR_workflow([OutDir, 'setup_file.mat']);
