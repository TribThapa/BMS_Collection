clc; clear all; close all

PathDir = ('/home/ttha0011/kg98/Thapa/GWM/RESTDATAonly/');

Table_CDT = readtable([PathDir, '4_ChangeDetectionTask/ChangeDetectionTaskAll.csv']);
Table_CWT = readtable([PathDir, '5_ColourWheelTask/ColourWheelTaskAll.csv']);
Table_BarT = readtable([PathDir, '6_BarTask/BarTaskAll.csv']);
Table_OrientationT = readtable([PathDir, '7_OrientationTask/OrientationTaskAll.csv']);
Table_NbackT = readtable([PathDir, '8_NbackTask/NbackTaskAll.csv']);
Table_SSRT = readtable([PathDir, '9_StopSignalReactionTask/StopSignalReactionTaskAll.csv']);
Table_SymSpanT = readtable([PathDir, '10_SymmetrySpanTask/SymmetrySpanTaskAll.csv']);
Table_OpernSpanT = readtable([PathDir, '11_OperationSpanTask/OperationSpanTaskAll.csv']);
Table_BDST = readtable([PathDir, '12_BackwardsDigitSpanTask/BackwardsDigitSpanTaskAll.csv']);
Table_SimonT = readtable([PathDir, '13_SimonTask/SimonTaskAll.csv']);
Table_GoNoGo = readtable([PathDir, '14_GoNoGoTask/GoNoGoTaskAll.csv']);

subplot(3,4,1)
h = histogram(Table_CDT.Load4_6_avg(:),10);
xlabel('CDT', 'fontsize', 5)
set(gca, 'FontSize', 6)

subplot(3,4,2)
h = histogram(Table_CWT.mean_MLELoad46(:),10);
xlabel('CWT MLE Load 4&6','fontsize', 5)
set(gca, 'FontSize', 6)

subplot(3,4,3)
h = histogram(Table_CWT.meandValue_Load46(:),10);
xlabel('CWT dValue Load 4&6','fontsize', 5)
set(gca, 'FontSize', 6)

subplot(3,4,4)
h = histogram(Table_BarT.Load4_6_avg(:),10);
xlabel('Bar','fontsize', 5);
set(gca, 'FontSize', 6)

subplot(3,4,5)
h = histogram(Table_OrientationT.wmCapacity(:),10);
ylim([0 30]);
xlabel('OrienT','fontsize', 5)
set(gca, 'FontSize', 6)

subplot(3,4,6)
h = histogram(Table_NbackT.dPrime(:),10);
xlabel('nBack','fontsize', 5);
set(gca, 'FontSize', 6)

subplot(3,4,7)
h = histogram(Table_SSRT.SSRT(:),10);
xlabel('SSRT','fontsize', 5);
set(gca, 'FontSize', 6)

subplot(3,4,8)
h = histogram(Table_SymSpanT.Partial_Sspan(:),10);
xlabel('SymSpan Partial','fontsize', 5);
set(gca, 'FontSize', 6)

subplot(3,4,9)
h = histogram(Table_OpernSpanT.PartialOspan(:),10);
xlabel('OSpan Partial','fontsize', 5);
set(gca, 'FontSize', 6)

subplot(3,4,10)
h = histogram(Table_BDST.Partial_bTE_ML(:),10);
ylim([0, 50]);
xlabel('Partial BDS','fontsize', 5);
set(gca, 'FontSize', 6)

subplot(3,4,11)
h = histogram(Table_SimonT.SimonEffect(:),10);
xlabel('Simon Effect','fontsize', 5);
set(gca, 'FontSize', 6)

subplot(3,4,12)
h = histogram(Table_GoNoGo.CommssnRate(:),10);
ylim([0, 50]);
xlabel('GoNoGo Commission rate','fontsize', 5);
set(gca, 'FontSize', 6)

saveas(gcf, [PathDir, '16_Figures/DistributionPlots_WorkingMemoryTasks.png']);

