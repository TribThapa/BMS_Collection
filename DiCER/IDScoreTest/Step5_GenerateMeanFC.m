clc; clear all; close all

%Step 1: Set paths.
parentdir = '/projects/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/3_IdentificationScoreTest/';
datadir = [parentdir,'3_UCLA_GordonAtlas/'];      
subIDs = [parentdir,'ScriptsUsed/SubjectIDs.txt'];;

fileID = fopen(subIDs); 
Subjects = textscan(fileID,'%s'); 
Subjects = Subjects{1};
Subjects_cell2table = cell2table(Subjects);
numSubs = size(Subjects,1);

numPrePro= 3;
noiseOptions = {'24P+8P_preproc','AROMAnonaggr_preproc+2P+GSR','AROMAnonaggr_preproc+2P'};
N_methods = 3;

for i = 1:numSubs
    % Load in time series data
    TimeSeriesdir = [datadir,Subjects_cell2table.Subjects{i},'/TimeSeries/'];

    % Compute correlations
    for j = 1:numPrePro
        TS = dlmread([TimeSeriesdir,Subjects_cell2table.Subjects{i},'_task-rest_variant-',noiseOptions{j},'_Gordon_ts.txt'])'; % to read your timeseries file. 
        FC(:,:,i,j) = corr(TS); 
        [coef,score,~,~,explained] = pca(zscore(TS).');
        first_pc(i,j) = explained(1);
        % Perform fisher z transform
        FC(:,:,i,j) = atanh(FC(:,:,i,j)); % Z transform of the func connectivity matrix
    end
end

m2 = squeeze(mean(tanh(FC),3));
	fc_mat = figure('color','white');
    
for j=1:N_methods
    
    subplot(1,N_methods,j)
    
    m3 = m2(:,:,j);
    imagesc(m2(:,:,j));
    axis image
    
     if(j==1)
         caxis([-0.3,0.3]);
     else
         caxis([-0.1,0.1]);
     end
           
	set(gca,'YDir','normal','fontSize',8);

	title(noiseOptions{j},'fontSize',8,'Interpreter','none')
    colormap([flipud(BF_getcmap('blues',9,0));[1,1,1],;BF_getcmap('reds',9,0)])
    p=colorbar;
    pp=get(p,'Limits');
	set(p,'Ticks',[pp(1) 0 pp(2)]);
    
end

%saveas(gcf, [datadir,'FC_mean'], 'png');

