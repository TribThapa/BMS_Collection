clc; clear all; close all;

%Step 1: Determine path to study directory.
DataDir = ['/projects/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/3_IdentificationScoreTest/4_HCP_dataset/'];

%Step 2: Get healthy subject structure.
SubjectList = dir([DataDir,'1*']); %5=SZ; 6=BPD; 7=ADHD.

%Step 3: Extract healthy subject list from Step 2.
subID = extractfield(SubjectList,'name');
%subID = {'sub-10159'};

%Step 4: Define number of parcels.
NumParc = 360; %Schaefer
%NumParc = 333; %Gordon

%Step 5: Calculate the number of elements above the triangle.
El_triu = ((NumParc^2)-NumParc)/2;

%Step 6: Define matrix to populate later in the loop.
FC_1 = zeros(length(subID), El_triu);
FC_2 = zeros(length(subID), El_triu);
    
%Step 7: Enter denoising approaches.
Variant = {'HCPparc'};

%Step 8: Create loop over denoising pipelines.
for j = 1:length(Variant) 
       
    %Step 9: Create to loop over each subjects timeseries for the denoising pipeline defined above.
    for i = 1:length(subID)
    
        %Step 10: Read in timeseries file. Here, rows=voxel timeseries; columns=volumes.
        TimeSeries = dlmread([DataDir,subID{i},'/',subID{i},'_',Variant{j},'_ts.txt']);
  
        %Step 11: Check for 0 in extracted TimeSeries file.
        if any(TimeSeries == 0) | any(TimeSeries < 0)
            str = sprintf('Check %d. TimeSeries has 0', i)
        else
            disp('All good ^__^ ')
        end
  
        %Step 12: Split Timeseries into top and bottom half.
        TimeSeries1 = TimeSeries(:,1:(size(TimeSeries,2))/2); % automate the halves based upon the time-series inserted.
        TimeSeries2 = TimeSeries(:,(((size(TimeSeries,2))/2)+1):end);
        
        %Step 13: Create a node-by-node correlation matrix for each Timeseries.    
        Corr_mat1 = corr(TimeSeries1');
        Corr_mat2 = corr(TimeSeries2'); 
                
        %Step 14: Extract the upper triangle from the correlation matrix created in Step 13.    
        Corr_mat1_uT = triu(Corr_mat1,1);
        Corr_mat2_uT = triu(Corr_mat2,1); 
        
        %Step 15: Create logical index to extract elements above the diagonal.
        Corr_mat1_logic = (Corr_mat1_uT ~= 0);
        Corr_mat2_logic = (Corr_mat2_uT ~= 0);
        
        %Step 16: Use logic created in Step 15 to extract elements above the diagonal. 
        Corr_mat1_v = Corr_mat1_uT(Corr_mat1_logic);
        Corr_mat2_v = Corr_mat2_uT(Corr_mat1_logic);                      
        
        %Step 17: Add the vectorised matrices into the FC_1, and FC_2 cells created above.    
        FC_1 (i,:) = Corr_mat1_v';
        FC_2 (i,:) = Corr_mat2_v';
    end
            
    %Step 18: Run correlation between the first and second half of the time-series for each subject.
    ID_matrix = corr(FC_1', FC_2');
    %ID_matrix(isnan(ID_matrix))=0;

    %Step 19: Create a matrix the size of subIDxSubID and put 1s off the diagonal, and 0s on the diagonal. Then identfiy each cell with 1s (off-diagonal elements) ignoring 0s (the diagonal)
    idx = find(~eye(size(ID_matrix))); %indices of off-diagonal elements.

    %Step 20: Calculate the ID score using the difference between the mean of the diagonal and off-diagonal elements.
    IDScore = (mean(diag(ID_matrix))-mean(ID_matrix(idx)))*100; %nanmean

    %PLOT FIGURES

    %Step 21: Generate and save correlation matrix.
    figure 
    imagesc(ID_matrix); 
    colormap('jet');
    colorbar;
    caxis([0 1]);
    ylabel('Subjects');
    xlabel('Subjects');
    title(([Variant{j},'; Max IDScore = ',num2str(IDScore)]), 'FontSize', 10);
    %saveas(gcf, [DataDir,'UCLA_healthys_task-rest_variant-',Variant{j},'_CorrPlot_Schaefer'], 'png');

    %Step 22: Determine Diag and off diag elements.
    Diag_IDmatrix = diag(ID_matrix);
    OffDiag_IDmatrix = ID_matrix(idx);
    Mean_DiagIDmatrix = mean(Diag_IDmatrix);
    Mean_OffDiagIDmatrix = mean(OffDiag_IDmatrix);
    
    meanlabel_diag = sprintf('Diag Mean: %f', Mean_DiagIDmatrix);
    meanlabel_offdiag = sprintf('Off-diag Mean: %f', Mean_OffDiagIDmatrix);
    
    %Step 23: Generate and save histogram.
    h1 = histogram(Diag_IDmatrix, 'FaceColor', 'g', 'FaceAlpha', 1);
    hold on;
    h2 = histogram(OffDiag_IDmatrix, 'FaceAlpha', 1);
    hold off;
    ylim([0 1200]);
    xlim([0 1]);
    xticks([0:0.1:1]);
    ylabel('Number of elements');
    xlabel('Pearsons correlation value');
    legend('Diagonal elements', 'Off-diagonal elements');
    h = annotation('textbox', [0.55 0.70 0.1 0.1]);
    set(h, 'String',{meanlabel_diag, meanlabel_offdiag});
    title(([Variant{j},'; Max IDScore = ',num2str(IDScore)]), 'FontSize', 10);
    %saveas(gcf, [DataDir,'UCLA_healthys_task-rest_variant-',Variant{j},'_Histo_Schaefer'], 'png');
        
end

