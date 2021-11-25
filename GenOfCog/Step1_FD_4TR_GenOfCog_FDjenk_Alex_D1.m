clc; clear all; close all;

addpath(genpath('/home/ttha0011/kg98/Thapa/GenOfCog/Scripts/FromAlex'));

DataDir = ('/home/ttha0011/kg98/kristina/GenofCog/datadir/derivatives/');
  
OutDir = ('/home/ttha0011/kg98/Thapa/GenOfCog/1_DataDir/1_FD_3TR/');

TR = 0.754; 

k = 3; %Should ideally be set so the effective TR is 2 < k*TR < 3. Default is k=3. Note: k=1 returns standard FD estimate.

stopband = [0.2 0.5];
%stopband = []; % for no filtering

head = 80; % 

%subID = {'sub-023'}; %'sub-024'}; 

subID = dir([DataDir, 'sub-*']);


for i = 1:length(subID)
    
    MovtParams = ([DataDir, subID(i).name,'/prepro.feat/mc/prefiltered_func_data_mcf.par']);
    
    RegFile = textread(MovtParams);
    
    Table = table(RegFile(:,4), RegFile(:,5), RegFile(:,6), RegFile(:,1), RegFile(:,2), RegFile(:,3));
    Table.Properties.VariableNames = {'X', 'Y', 'Z', 'RotX', 'RotY', 'RotZ'};

    %%-----------------------------------------------------------------------------------------------------------------------------------------------%%
    %%------------------------------------------------------------------------DETREND----------------------------------------------------------------%%
    %%-----------------------------------------------------------------------------------------------------------------------------------------------%%
    %1 = removes linear trend option
    X_DetrenPoly1 = detrend(Table.X,1); 
    Y_DetrenPoly1 = detrend(Table.Y,1);
    Z_DetrenPoly1 = detrend(Table.Z,1);
    RotX_DetrenPoly1 = detrend(Table.RotX,1); 
    RotY_DetrenPoly1 = detrend(Table.RotY,1);
    RotZ_DetrenPoly1 = detrend(Table.RotZ,1);
    
    Table2 = table(RegFile(:,4), RegFile(:,5), RegFile(:,6), RegFile(:,1), RegFile(:,2), RegFile(:,3), X_DetrenPoly1, Y_DetrenPoly1, Z_DetrenPoly1, RotX_DetrenPoly1, RotY_DetrenPoly1, RotZ_DetrenPoly1);
    Table2.Properties.VariableNames = {'X', 'Y', 'Z', 'RotX', 'RotY', 'RotZ', 'X_DetrenPoly1', 'Y_DetrenPoly1', 'Z_DetrenPoly1', 'RotX_DetrenPoly1', 'RotY_DetrenPoly1', 'RotZ_DetrenPoly1'};
    
%     subplot(6, 1, 1)
%     p = plot(Table2.X, 'black');
%     hold on;
%     q = plot(Table2.X_DetrenPoly1, 'blue');
%     lgd = legend('Not detrended', 'DetrendPoly1');
%     lgd.FontSize = 4;
%     xlim([0 750]);
%     set(gca, 'FontSize', 4)
%     title ('X', 'FontSize', 6)


%     subplot(6, 1, 2)
%     p = plot(Table2.Y, 'black');
%     hold on;
%     q = plot(Table2.Y_DetrenPoly1, 'blue');
%     lgd = legend('Not detrended', 'DetrendPoly1');
%     lgd.FontSize = 4;
%     xlim([0 750]);
%     set(gca, 'FontSize', 4)
%     title ('Y', 'FontSize', 6)
% 
%     subplot(6, 1, 3)
%     p = plot(Table2.Z, 'black');
%     hold on;
%     q = plot(Table2.Z_DetrenPoly1, 'blue');
%     lgd = legend('Not detrended', 'DetrendPoly1');
%     lgd.FontSize = 4;
%     xlim([0 750]);
%     set(gca, 'FontSize', 4)
%     title ('Z', 'FontSize', 6)

%     subplot(6, 1, 4)
%     p = plot(Table2.RotX, 'black');
%     hold on;
%     q = plot(Table2.RotX_DetrenPoly1, 'blue');
%     lgd = legend('Not detrended', 'DetrendPoly1');
%     lgd.FontSize = 4;
%     xlim([0 750]);
%     set(gca, 'FontSize', 4)
%     title ('RotX', 'FontSize', 6)
% 
%     subplot(6, 1, 5)
%     p = plot(Table2.RotY, 'black');
%     hold on;
%     q = plot(Table2.RotY_DetrenPoly1, 'blue');
%     lgd = legend('Not detrended', 'DetrendPoly1');
%     lgd.FontSize = 4;
%     xlim([0 750]);
%     set(gca, 'FontSize', 4)
%     title ('RotY', 'FontSize', 6)
% 
% 
%     subplot(6, 1, 6)
%     p = plot(Table2.RotZ, 'black');
%     hold on;
%     q = plot(Table2.RotZ_DetrenPoly1, 'blue');
%     lgd = legend('Not detrended', 'DetrendPoly1');
%     lgd.FontSize = 4;
%     xlim([0 750]);
%     set(gca, 'FontSize', 4)
%     title ('RotZ', 'FontSize', 6)

    %saveas(gcf,[DataDir, '2_Tests/GenOfCog/1_KristinaFSLanalysis/',subID{i},'_',num2str(k),'TR_CompareDetrends.png']);
    
    
    %%--------------------------------------------------------------------------------------------------------------------------------------------------%%
    %%--------------------------------------------------------------FILTER & ESTIMATE FD----------------------------------------------------------------%%
    %%--------------------------------------------------------------------------------------------------------------------------------------------------%%
    
    clc;

    NotDetrended = table(RegFile(:,4), RegFile(:,5), RegFile(:,6), RegFile(:,1), RegFile(:,2), RegFile(:,3));
    NotDetrended.Properties.VariableNames = {'X', 'Y', 'Z', 'RotX', 'RotY', 'RotZ'};
    NotDetrended_matrix = NotDetrended{:,:};

    DetrenPoly1 = table(X_DetrenPoly1, Y_DetrenPoly1, Z_DetrenPoly1, RotX_DetrenPoly1, RotY_DetrenPoly1, RotZ_DetrenPoly1);
    DetrenPoly1.Properties.VariableNames = {'X_DetrenPoly1', 'Y_DetrenPoly1', 'Z_DetrenPoly1', 'RotX_DetrenPoly1', 'RotY_DetrenPoly1', 'RotZ_DetrenPoly1'};
    DetrenPoly1_matrix = DetrenPoly1{:,:};


    FD_NotDetrended = GetFDJenk_multiband(NotDetrended_matrix, TR, k, stopband, head);

    FD_DetrenPoly1 = GetFDJenk_multiband(DetrenPoly1_matrix, TR, k, stopband, head);


    meanFD_NotDetrended = mean(FD_NotDetrended);
    %dlmwrite([OutDir, subID(i).name,'_',num2str(k),'TR_FD_NotDeterended_MultiBand.txt'], FD_NotDetrended);

    meanFD_DetrenPoly1 = mean(FD_DetrenPoly1);
    dlmwrite([OutDir, subID(i).name,'_',num2str(k),'TR_FD_DeterenPoly1_MultiBand.txt'], FD_DetrenPoly1);

%     figure;
%     subplot(2,1,1)
%     p = plot(FD_NotDetrended, 'black');
%     title (['FD NotDetrended. meanFD=',num2str(meanFD_NotDetrended)]);
%     set(gca, 'FontSize', 6);
% 
%     subplot(2,1,2)
%     q = plot(FD_DetrenPoly1, 'blue');
%     title (['FD DetrenPoly1. meanFD=',num2str(meanFD_DetrenPoly1)]);
%     set(gca, 'FontSize', 6);
    
    %saveas(gcf,[DataDir, '2_Tests/GenOfCog/1_KristinaFSLanalysis/',subID{i},'_',num2str(k),'TR_NewFDs.png']);
    
end





