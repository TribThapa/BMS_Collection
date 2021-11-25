clc; clear all; close all;

PathDir = ('/home/ttha0011/kg98/Thapa/GWM/RESTDATAonly/');

%Load Task files
Table_CDT = readtable([PathDir, '4_ChangeDetectionTask/ChangeDetectionTaskAll.csv']);
%Table_CWT = readtable([PathDir, '5_ColourWheelTask/ColourWheelTaskAll.csv']);
%Table_BarT = readtable([PathDir, '6_BarTask/BarTaskAll.csv']);
%Table_OrientationT = readtable([PathDir, '7_OrientationTask/OrientationTaskAll.csv']);
Table_NbackT = readtable([PathDir, '8_NbackTask/NbackTaskAll.csv']);
%Table_SSRT = readtable([PathDir, '9_StopSignalReactionTask/StopSignalReactionTaskAll.csv']);
Table_SymSpanT = readtable([PathDir, '10_SymmetrySpanTask/SymmetrySpanTaskAll.csv']);
Table_OpernSpanT = readtable([PathDir, '11_OperationSpanTask/OperationSpanTaskAll.csv']);
Table_BDST = readtable([PathDir, '12_BackwardsDigitSpanTask/BackwardsDigitSpanTaskAll.csv']);
%Table_SimonT = readtable([PathDir, '13_SimonTask/SimonTaskAll.csv']);
%Table_GoNoGo = readtable([PathDir, '14_GoNoGoTask/GoNoGoTaskAll.csv']);

%Extract outcome measures for each task
CDT = Table_CDT.Load4_6_avg(:);
%CWT = Table_CWT.wmCapacity(:);
%BarTask = Table_BarT.Load4_6_avg(:);
%OrienT = Table_OrientationT.wmCapacity(:);
nBack = Table_NbackT.dPrime(:);
%SSRT = Table_SSRT.SSRT(:);
SymSpan = log(Table_SymSpanT.Partial_Sspan(:)); 
OSpan = log(Table_OpernSpanT.PartialOspan(:));
BDS = Table_BDST.bTE_ML(:);
%Simon = Table_SimonT.SimonEffect(:);
%GNG = Table_GoNoGo.CommssnRate(:);

%Create labels for x and y ticks
TaskNames = {'CDT', 'nBack', 'SymSpan', 'OSpan', 'BDS'};

%Create table with Selected outcome measures.
Tasks = table(CDT, nBack, SymSpan, OSpan, BDS);

%Convert table to matrix to run correlation
Tasks_matrix = Tasks{:,:};

%Run correlation
[Corr_matR, Corr_matP] = corr(Tasks_matrix, 'rows','complete');
%Corr_test = corr(Tasks_matrix(:,1), Tasks_matrix(:,3)); %Uncomment this like to double check the correlational values

%Create logic to get cells with p-value <0.05
logic = Corr_matP < 0.05;

%Create matrix to locate cells in the figure where you will add in the R values, and * for significance (i.e., p < 0.05)
x_axis = repmat(1:(length(Corr_matR(:,1))), (length(Corr_matR(:,1))), 1);
y_axis = x_axis';
%a = arrayfun(@(V) sprintf('<HTML><B>%.16g</B>', V), Corr_matR(logic), 'Uniform', 0);
a = num2cell(round(Corr_matR, 2));
a = cellfun(@num2str, a, 'UniformOutput', false);
a(logic) = cellfun(@(c) [c, '*'], a(logic), 'UniformOutput', false);


%Generate figure
colormap autumn; %(turbo(256));
imagesc(Corr_matR);
colorbar;
caxis([-1 1]);
set(gca,'xtick',[1:11],'xticklabel',TaskNames, 'fontsize', 6);
set(gca,'ytick',[1:11],'yticklabel',TaskNames, 'fontsize', 6);
text(x_axis(:), y_axis(:), a, 'HorizontalAlignment', 'Center', 'fontsize', 5);
title('Task vs Task; n=132','fontsize', 10);

%Save figure
%saveas(gcf,[PathDir,'16_Figures/TaskCorr.png']);
