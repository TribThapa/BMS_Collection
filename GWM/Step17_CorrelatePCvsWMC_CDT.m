clc; clear all; close all; 

% Define paths.
DataDir = ['/home/ttha0011/kg98/Thapa/GWM/RESTDATAonly/'];
CDT_FSEs = readtable([DataDir,'4_ChangeDetectionTask/WMC_and_CDT_FSEs_29092020.csv']);
Offset_PCs = readtable([DataDir, '15_WMCestimates/3_Top3PCs_2To40Hz_Knee_19112020/offsetAll_3PCs_2To40Hz_Knee.csv']);
Slope_PCs = readtable([DataDir, '15_WMCestimates/3_Top3PCs_2To40Hz_Knee_19112020/slopeAll_3PCs_2To40Hz_Knee.csv']);

% Remove '035', '62', and '066' from the task dataset. Their EEG data is missing.
B_data = CDT_FSEs;
Col = 2; %Select column to correlate

% Remove '035', '62', and '066' from the task dataset. Their EEG data is missing.
B_data(B_data.ID(:,1) == 35, :) = [];
B_data(B_data.ID(:,1) == 62, :) = [];
B_data(B_data.ID(:,1) == 66, :) = [];
Behav_data = B_data{:, :};
Behav_data2 = array2table(Behav_data);

Behav_data2.Properties.VariableNames = {'ID', 'WMC', 'CDT'};
Offset_PCs.Properties.VariableNames = {'ID', 'PC1_Offset', 'PC2_Offset', 'PC3_Offset'};
Slope_PCs.Properties.VariableNames = {'ID', 'PC1_Slope', 'PC2_Slope', 'PC3_Slope'};

AllVariables = [Behav_data2(:,2), Behav_data2(:,3), Offset_PCs(:,2), Offset_PCs(:,3), Offset_PCs(:,4), Slope_PCs(:,2), Slope_PCs(:,3), Slope_PCs(:,4)];

%Convert table to matrix to run correlation
AllVariables_matrix = AllVariables{:,:};

%Run correlation
[Corr_matR, Corr_matP] = corr(AllVariables_matrix, 'rows','complete');

logic = Corr_matP < 0.05;

x_axis = repmat(1:(length(Corr_matR(:,1))), (length(Corr_matR(:,1))), 1);
y_axis = x_axis';
a = num2cell(round(Corr_matR, 2));
a = cellfun(@num2str, a, 'UniformOutput', false);
a(logic) = cellfun(@(c) [c, '*'], a(logic), 'UniformOutput', false);

VarNames = {'WMC', 'CDT', 'PC1 Offset', 'PC2 Offset', 'PC3 Offset', 'PC1 Slope', 'PC2 Slope', 'PC3 Slope'};

%Generate figure
colormap(jet(256))
imagesc(Corr_matR);
colorbar;
caxis([-1 1]);
set(gca,'xtick',[1:11],'xticklabel',VarNames, 'fontsize', 6);
set(gca,'ytick',[1:11],'yticklabel',VarNames, 'fontsize', 6);
text(x_axis(:), y_axis(:), a, 'HorizontalAlignment', 'Center', 'fontsize', 5);
title('WMC CDT vs PC for Slope&Offset; n=129','fontsize', 10);

%Save figure
saveas(gcf,[DataDir,'15_WMCestimates/3_Top3PCs_2To40Hz_Knee_19112020/WMC_CDT_vs_SlopeOffsetPCs_Knee.png']);

