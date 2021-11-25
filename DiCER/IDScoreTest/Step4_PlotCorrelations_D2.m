clc; clear all; close all;

%Step 1: Determine path to Study design directory.
DataDir = ['/projects/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/3_IdentificationScoreTest/'];

%Step 2: Enter subject IDs.
subID = {'sub-GAB001'};%, 'sub-GAB002', 'sub-GAB003', 'sub-GAB004', 'sub-GAB005'};

%Step 3: Create loop over subjects.
for i = 1:length(subID)
    
    %Step 4: Enter subject's conditions.
    cond = {'Rest3'};%, 'Rest2', 'Rest3', 'Rest4'};
    
    %Step 5: Create loop over subject's conditions.
    for j = 1:length(cond)
        
        %Step 6: Read in timeseries file. Here, rows=voxel timeseries; columns=volumes.
        TimeSeries = dlmread([DataDir,subID{i},'/TimeSeries/',subID{i},'_task-',cond{j},'_ts.txt']);
        
        %Step 7: Get size of TimeSeries file.
        TimeSeries_size = size(TimeSeries);
        
        %Step 8: Split Timeseries into top and bottom half.       
        TimeSeries1 = TimeSeries(:,1:170);
        TimeSeries2 = TimeSeries(:,171:end);
              
        %Step 9: Create a node-by-node correlation matrix for each Timeseries.       
        Corr_mat1 = corr(TimeSeries1');
        Corr_mat2 = corr(TimeSeries2');
        
        %Step 10: Extract the upper triangle (UT_i.e., above the diagonal) from the correlation matrix for each Timeseries.       
        Corr_mat1_UT_i1 = triu(Corr_mat1,1);
        Corr_mat2_UT_i2 = triu(Corr_mat2,1);
                
        Corr_mat1_UT_ii1 = triu(Corr_mat1,1);
        Corr_mat2_UT_ii2 = triu(Corr_mat2,1);
        
        % vertical is subject i's T1 and horizantl is subject ii's T2
        ev1=['CORR_',subID{i}(5:end),'_T1_',subID{ii}(5:end),'_T2=corr(TimeSeries_i1'',TimeSeries_ii2'');'];
        ev2=['CORR_',subID{ii}(5:end),'_T1_',subID{i}(5:end),'_T2=corr(TimeSeries_ii1'',TimeSeries_i2'');'];
        
        eval(ev1);
        eval(ev2);
        
        
        %Step 10: Create correlation for each cell between the Corr_mat1_UT and Corr_mat2_UT.       
        %Corr_mat3 = corr(Corr_mat1_UT, Corr_mat2_UT);
        
%         figure;
%         ax(1) = subplot(1,15,1:5);
%         imagesc(Corr_mat3);
%         title('First v Second half', 'FontSize', 8);
%         
%         ax(2) = subplot(1,15,7:14);
%         imagesc(Corr_mat4);
%         title('First v Second half INVERSE', 'FontSize', 8);
%        
%         colorbar;
%         saveas(gcf, [DataDir,subID{i},'/TimeSeries/',subID{i},'_task-',cond{j},'_CorrelationTimeSeries1and2'], 'png');
      
    end
end

% 
%         
%          for k = 1:170; % k is the number of timepoints (assuming that you have 170 timepoints) 
%              
%              [r,p] = corr(Corr_mat1(:,1:k)', Corr_mat2(:,1:k)'); %Pearson r
%      
%              idx = find(~eye(size(r))); %indices of off-diagonal elements
%          
%              save([DataDir,subID{i},'/TimeSeries/',subID{i},'_task-',cond{j},'_CorrelationTimeSeries1and2'], 'r');
%          end
%     end
%     end

    
        %figure;
%         ax(1) = subplot(1,15,1:3);
%         imagesc(Corr_mat1);
%         title('First half');
%          
%         ax(2) = subplot(1,15,5:7);
%         imagesc(Corr_mat2);
%         title('Second half');
%         
%         ax(3) = subplot(1,15,10:15);
%         imagesc(Corr_mat3);
%         title('Full TimeSeries');
%         
%         colorbar;
%         colormap jet;
%         
%         saveas(gcf, [DataDir,subID{i},'/TimeSeries/',subID{i},'_task-',cond{j},'_IndentityMatrices'], 'png');
%     end
%  

