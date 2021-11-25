clc; clear all; close all;

Vol = 4;
TR = 0.754;
 
DataDir = char({['/home/ttha0011/kg98/Thapa/GenOfCog/1_DataDir/2_FD_',num2str(Vol),'TR/']});
OutDir = ('/home/ttha0011/kg98/Thapa/GenOfCog/1_DataDir/');

%subID = {'sub-023'}; %'sub-024'}; 

subID = dir([DataDir, 'sub-*']);


for i = 1:length(subID)
    
    FD = textread(append(DataDir, subID(i).name));
    
    %FD = textread([DataDir, subID{i},'_3TR_FD_DeterenPoly1_MultiBand.txt']);
    
    meanFD{i} = mean(FD);
    
    Percentage{i} = (sum(FD>0.2)/length(FD))*100;
    
    GrtThan{i} = sum(FD > 5);
       
    IDs{i} = strrep(subID(i).name, '_4TR_FD_DeterenPoly1_MultiBand.txt', '');
      
    logic = FD > 0.25;
        
    All_FD{i} = FD;    

    Uncensored_FD{i} = FD(logic == 0);    
    
    Censored_FD{i} = FD(logic == 1);    
       
    RemainVols{i} = (length(FD) - length(FD(logic==1)));

    ExclVols{i} = (length(FD) - length(FD(logic==0)));

    MinsIncl{i} = ((length(FD) - length(FD(logic==1))) * TR)/60;

    MinsExcl{i} = ((length(FD) - length(FD(logic==0))) * TR)/60;
    
end

All_FD_mat = cell2mat(All_FD);
All_FD_mat(All_FD_mat > 0.25) = nan;
All_FD_Table = array2table(All_FD_mat, 'VariableNames', IDs);
writetable(All_FD_Table, [OutDir,'NewFDs_',num2str(Vol),'TR.csv']);


Table = table(IDs', meanFD', Percentage', GrtThan', RemainVols', ExclVols', MinsIncl', MinsExcl');
Table.Properties.VariableNames = {'subID', 'meanFD', 'PercentageAbove02', 'FDMoreThan5', 'RemainVols', 'ExclVols', 'MinsIncluded', 'MinsExcluded'};
writetable(Table, [OutDir,'FD_Stats_',num2str(Vol),'TR.csv']);

NumMoreThan055 = sum(cell2mat(Table.meanFD) > 0.55);
NumMoreThan025 = sum(cell2mat(Table.meanFD) > 0.25);
NumMoreThan20 = sum(cell2mat(Table.PercentageAbove02) > 20);
NumMoreThan5 = sum(cell2mat(Table.FDMoreThan5) > 5);
NumLessThan4Vols = sum(cell2mat(Table.MinsIncluded) < 4);

% Find excluded subs
row = find(cell2mat(Table.PercentageAbove02)> 20);
ExcludedSubs = Table(row,:);

subplot(1,7,1)
a = boxplot(cell2mat(Table.meanFD));
xlabel('meanFD')
set(gca, 'FontSize', 4)

subplot(1,7,2)
b = boxplot(cell2mat(Table.PercentageAbove02));
xlabel('20PercentageAbv02')
set(gca, 'FontSize', 4)

subplot(1,7,3)
c = boxplot(cell2mat(Table.FDMoreThan5));
xlabel('FDMoreThan5')
set(gca, 'FontSize', 4)

subplot(1,7,4)
c = boxplot(cell2mat(Table.RemainVols));
xlabel('RemainVols')
set(gca, 'FontSize', 4)

subplot(1,7,5)
c = boxplot(cell2mat(Table.ExclVols));
xlabel('ExclVols')
set(gca, 'FontSize', 4)

subplot(1,7,6)
c = boxplot(cell2mat(Table.MinsIncluded));
xlabel('TotalInclMins')
set(gca, 'FontSize', 4)

subplot(1,7,7)
c = boxplot(cell2mat(Table.MinsExcluded));
xlabel('TotalExclMins')
set(gca, 'FontSize', 4)

saveas(gcf,[OutDir, 'FD_Stats_',num2str(Vol),'TR.png']);

  