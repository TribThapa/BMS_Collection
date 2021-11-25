clc; clear all; close all;

%Step 1: Determine path to Study design directory.
DataDir = ['/projects/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/3_IdentificationScoreTest'];


%Step 2: Healthy subjects.
subID = {'sub-10159'}; 

FC = zeros(length(subID), 90000);

%Step 4: Create loop over subjects.
for i = 1:length(subID) 
    
    Variant = {'24P+8P_preproc'};
    
    for j = 1:length(Variant)
    
        %Step 5: Read in timeseries file. Here, rows=voxel timeseries; columns=volumes.
        TimeSeries = dlmread([DataDir,'/2_UCLA_Schaefer/',subID{i},'/TimeSeries/',subID{i},'_task-rest_variant-',Variant{j},'_Schaefer_ts.txt']);
        
        fcMatrix = corrcoef(TimeSeries);
        
        %Step 6: Extract data from above the diagonal.
        fcMatrix_UT = triu(fcMatrix,1);  
        
        %Step 15: Create logical index to extract elements above the diagonal.
        fcMatrix_UT_logic = (fcMatrix_UT ~= 0);
        
        %Step 16: Use logic created in Step 15 to extract elements above the diagonal. 
        fcMatrix_UT_v = fcMatrix_UT(fcMatrix_UT_logic);
                   
    end
end

%Step 13: Generate and save correlation matrix.
figure 
subplot(2,1,1)
imagesc(fcMatrix); 
colormap('jet');
colorbar;
ylabel('Node');
xlabel('Node');
title((['Single subject Node x Node']), 'FontSize', 10);

subplot(2,1,2)
hist(fcMatrix_UT_v);
ylabel('No of elements');
xlabel('Pearsons correlation');


