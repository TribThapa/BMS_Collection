clc; clear all; close all;
rng('default');

DataDir = ('/home/ttha0011/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/3_IdentificationScoreTest/2_UCLA_Schaefer/');

OutDir = ([DataDir, 'Figures/']);

Subs = dir([DataDir,'sub-1*']);
subID = extractfield(Subs, 'name');%
%subID = {'sub-10159'};%; 'sub-10171'; 'sub-10189'; 'sub-10206'; 'sub-10217'; 'sub-10225'; 'sub-10228'};

for i = 1:length(subID)
    
    DiRegFile = dlmread([DataDir, subID{i}, '/dbscan/', subID{i},'_dbscan_liberal_regressors.tsv']);
    GMRFile = dlmread([DataDir, subID{i}, '/dbscan/', subID{i},'_tissue_signals.txt']);

    K1 = DiRegFile(:,1);      
    GMR = GMRFile(:,4);

    [r(:,i) p(:,i)] = corr(K1, GMR); 
    
    Corr(:,i) = corr(K1, GMR); 

end

subplot(2,1,1);
normplot(Corr);
xlabel('Corr DiCER K1 vs GMR', 'FontSize', 10);

subplot(2,1,2);
histogram(Corr, 10);
xlabel('Corr DiCER K1 vs GMR', 'FontSize', 10);

%saveas(gcf, [OutDir,'UCLA_DiCERK1_vs_GMR_distribution'], 'png');

% subplot(2,1,1)
% imagesc(Corr); 
% xlabel('subject');
% colormap('jet');
% title(['DiCER K1 vs GMR'],'FontSize', 10);
% colorbar;  
% 
% subplot(2,1,2)
% h1 = histogram(K1, 'FaceColor', 'g', 'FaceAlpha', 1);
% hold on;
% h2 = histogram(GMR, 'FaceAlpha', 1);
% ylabel('Values', 'FontSize', 10);
% xlabel('<-- DiCER K1 vs GMR -->','FontSize', 10);
% hold off;
% 
% saveas(gcf, [OutDir,'UCLA_DiCERK1_vs_GMR'], 'png');



