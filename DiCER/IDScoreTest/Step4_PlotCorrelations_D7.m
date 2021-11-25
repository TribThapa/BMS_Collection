clc; clear all; close all;

%==========================================================================
% Inputs
%==========================================================================

% where the data are
dataDir =  ['/projects/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/3_IdentificationScoreTest/2_UCLA_Schaefer/'];

% where to save figures
outDir = [dataDir,'Figures/'];
%subject list
subs = dir([dataDir,'sub-1*']);
subs = extractfield(subs,'name')';
 
subs = {'sub-10159'; 'sub-10171'; 'sub-10189'; 'sub-10206'; 'sub-10217'; 'sub-10225'; 'sub-10228'; 'sub-10249'; 'sub-10269'; 'sub-10271'; 
        'sub-10273'; 'sub-10274'; 'sub-10280'; 'sub-10290'; 'sub-10292'; 'sub-10304'; 'sub-10316'; 'sub-10321'; 'sub-10325'; 'sub-10329'; 
        'sub-10339'; 'sub-10340'; 'sub-10345'; 'sub-10347'; 'sub-10356'; 'sub-10361'; 'sub-10365'; 'sub-10376'; 'sub-10377'; 'sub-10388'; 
        'sub-10429'; 'sub-10438'; 'sub-10440'; 'sub-10448'; 'sub-10455'; 'sub-10471'; 'sub-10478'; 'sub-10487'; 'sub-10492'; 'sub-10506'; 
        'sub-10517'; 'sub-10523'; 'sub-10525'; 'sub-10527'; 'sub-10530'; 'sub-10557'; 'sub-10565'; 'sub-10570'; 'sub-10575'; 'sub-10624'; 
        'sub-10629'; 'sub-10631'; 'sub-10638'; 'sub-10668'; 'sub-10672'; 'sub-10674'; 'sub-10678'; 'sub-10680'; 'sub-10686'; 'sub-10692'; 
        'sub-10696'; 'sub-10697'; 'sub-10704'; 'sub-10707'; 'sub-10708'; 'sub-10719'; 'sub-10724'; 'sub-10746'; 'sub-10762'; 'sub-10779'; 
        'sub-10785'; 'sub-10788'; 'sub-10844'; 'sub-10855'; 'sub-10871'; 'sub-10877'; 'sub-10882'; 'sub-10891'; 'sub-10893'; 'sub-10912'; 
        'sub-10934'; 'sub-10940'; 'sub-10949'; 'sub-10958'; 'sub-10963'; 'sub-10968'; 'sub-10975'; 'sub-10977'; 'sub-10987'; 'sub-10998'; 
        'sub-11019'; 'sub-11030'; 'sub-11044'; 'sub-11050'; 'sub-11052'; 'sub-11059'; 'sub-11061'; 'sub-11062'; 'sub-11066'; 'sub-11067'; 
        'sub-11068'; 'sub-11077'; 'sub-11088'; 'sub-11090'; 'sub-11097'; 'sub-11098'; 'sub-11104'; 'sub-11105'; 'sub-11106'; 'sub-11108'; 
        'sub-11112'; 'sub-11122'; 'sub-11128'; 'sub-11131'; 'sub-11142'; 'sub-11143'; 'sub-11149'; 'sub-11156'}; %%Nans in AparcAseg_ts: 'sub-10227'; 'sub-10235'; 'sub-10460'

% preprocessing variations
%preproc = {'24P8P', 'Arm2P', 'Arm2PDetr', 'GSR', 'DicFull', 'Dic1Reg', 'GMR'};
preproc = {'Arm2P', 'DicFull', 'GMR'};

%==========================================================================
% Analysis
%==========================================================================

for i = 1:length(preproc)
   
   tic; % start timer
   
   % Read data and get FC values
   %-----------------------------------------------------------------------
   
   for j = 1:length(subs)
        
       % read in data
        ts = dlmread([dataDir,subs{j},'/TimeSeries/',subs{j},'_',preproc{i},'_Schaefer_ts.txt']);
        %ts = dlmread([dataDir,subs{j},'/',subs{j},'_',preproc{i},'_Aparc_ts.txt']);
        
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
    ylim([0 1200]);
    ylabel('No. elements');
    xlabel('Pearson correlation');
    legend('Diagonal', 'Off-diagonal');
    title([preproc{i}, 'IDscore=',num2str(identScore(i))], 'FontSize',10);
    
    % print progress
    fprintf([preproc{i},' done \n']); toc;  % end timer
    
end

% set figure properties
set(gcf,'color','w','units','centimeters','position', [15 15 50 20]);
%saveas(gcf,[outDir,'identResults'],'jpg');


    
   