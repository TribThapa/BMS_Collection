clear all

%==========================================================================
% Inputs
%==========================================================================

% where the data are
dataDir =  ['/Users/alexfornito/Desktop/Thapa/timeseries/'];
% where to save figures
outDir = ['/Users/alexfornito/Desktop/Thapa/'];
% subject list
subs = dir([dataDir,'sub-1*']);
% preprocessing variations
preproc = {'24P+8P_preproc', 'AROMAnonaggr_preproc+2P', 'AROMAnonaggr_preproc+2P+GSR'};

%==========================================================================
% Analysis
%==========================================================================

for i = 1:length(preproc)
   
   tic; % start timer
   
   % Read data and get FC values
   %-----------------------------------------------------------------------
   
   for j = 1:length(subs)
        
       % read in data
        ts = dlmread([dataDir,subs(j).name,'/TimeSeries/',subs(j).name,'_task-rest_variant-',preproc{i},'_Schaefer_ts.txt']);
        
        % get no. nodes and volumes
        [nNodes nVols] = size(ts);
        % get upper triangle indices of FC matrix
        upperInds = find(triu(ones(nNodes),1));
        
        % check for zeros in time series. Don't want to find any zero - just nodes where all vals are zero
        if length(find(sum(ts) == 0))                       
            sprintf('Check %d. Some nodes have only zeros in time series \n', i)
        end
        
        % get FC matrices for each half
        fc1 = corrcoef(ts(:,1:nVols/2)');
        fc2 = corrcoef(ts(:,(nVols/2)+1:end)');
        
        % vectorize FC matrices
        fcVec1(:,j) = fc1(upperInds);
        fcVec2(:,j) = fc2(upperInds);
        
   end
   
   % Get identifiability
   %-----------------------------------------------------------------------
    
    % identifiability matrix
    idMat = zeros(length(subs));        % initalize
    idMat = corr(fcVec1, fcVec2);       % compute
    
    % check for negative correlations
    if length(find(idMat<0))>0
        sprintf('There are negative correlations in the identifiability matrix \n');
    end
    
    % separate diagonal and off-diagonals 
    offInds = find(~eye(size(idMat)));
    offVals = idMat(offInds);
    onVals = diag(idMat);
    
    % identifiability
    identScore(i) = (mean(onVals) - mean(offVals))*100;
    
    % store results
    identMat(:,:,i) = idMat;
    identOn(:,i) = onVals;
    identOff(:,i) = offVals;
    
    clear offInds offVals onVals
      
   % Generate figure
   %-----------------------------------------------------------------------
    
    % plot matrices
    nCols = length(preproc);
    subplot(2,nCols,i);
    imagesc(identMat(:,:,i));
    colorbar;
    caxis([0 1]);
    ylabel('subject');
    xlabel('subject');
    title([preproc{i},', IDscore=',num2str(identScore(i))],'FontSize', 10);
    saveas(gcf,[outDir,'idMat_',preproc{i}],'jpg');
    
    % plot histograms
    subplot(2,nCols,nCols+i);
    histogram(identOn(:,i), 'FaceColor', 'g', 'FaceAlpha', .8);
    hold on
    histogram(identOff(:,i), 'FaceAlpha', .8);
    xlim([0 1]);
    ylabel('No. elements');
    xlabel('Pearson correlation');
    legend('Diagonal', 'Off-diagonal');
    title([preproc{i}, 'IDscore=',num2str(identScore(i))], 'FontSize',10);
    
    % print progress
    fprintf([preproc{i},' done \n']); toc;  % end timer
    
end

% set figure properties
set(gcf,'color','w','units','centimeters','position', [15 15 50 20]);
saveas(gcf,[outDir,'identResults'],'jpg');


    
   