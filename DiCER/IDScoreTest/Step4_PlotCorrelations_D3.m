clc; clear all; close all;

%Step 1: Determine path to Study design directory.
DataDir = ['/projects/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/3_IdentificationScoreTest/'];

%Step 2: Enter subject IDs.
subID = {'sub-10159', 'sub-10171', 'sub-10189', 'sub-10206', 'sub-10217', 'sub-10225', 'sub-10227', 'sub-10228', 'sub-10235', 'sub-10249', 'sub-10269', 'sub-10271'};

%Step 3: Create loop over subjects.
for i = 1:length(subID)
    
    for ii = i:length(subID) % Create a second loop for subjects ii  
        %Step 4: Enter subject's conditions.
        cond = {'rest'};%, 'Rest2', 'Rest3', 'Rest4'};
        
        %Step 5: Create loop over subject's conditions.
        
        for j = 1:length(cond)
        
        %Step 6: Read in timeseries file. Here, rows=voxel timeseries; columns=volumes.
        TimeSeries = dlmread([DataDir,'/2_UCLA_dataset/',subID{i},'/TimeSeries/',subID{i},'_task-',cond{j},'_ts.txt']);
        
        %Step 7: Get size of TimeSeries file.
        TimeSeries_size = size(TimeSeries);
        
        %Step 8: Split Timeseries into top and bottom half.       
        TimeSeries1 = TimeSeries(:,1:76);
        TimeSeries2 = TimeSeries(:,77:end);
              
        %Step 9: Create a node-by-node correlation matrix for each Timeseries.       
        Corr_mat1 = corr(TimeSeries1');
        Corr_mat2 = corr(TimeSeries2');
        
        %Step 10: Extract the upper triangle (UT_i.e., above the diagonal) from the correlation matrix for each Timeseries.       
        Corr_mat1_UT_i1 = triu(Corr_mat1,1);
        Corr_mat2_UT_i2 = triu(Corr_mat2,1);
                
        Corr_mat1_UT_ii1 = triu(Corr_mat1,1);
        Corr_mat2_UT_ii2 = triu(Corr_mat2,1);
        
        % vertical is subject i's T1 and horizantl is subject ii's T2
        ev1=['CORR_',subID{i}(5:end),'_T1_',subID{ii}(5:end),'_T2=corr(Corr_mat1_UT_i1'',Corr_mat2_UT_ii2'');'];
        ev2=['CORR_',subID{ii}(5:end),'_T1_',subID{i}(5:end),'_T2=corr(Corr_mat1_UT_ii1'',Corr_mat2_UT_i2'');'];
        
        eval(ev1);
        eval(ev2);
  
        end
    end    
end
       

        L=[];
        M=[];
        for m=1:12
            for n=1:12
                vname=['CORR_',subID{m}(5:end),'_T1_',subID{n}(5:end),'_T2'];
                L=[L eval(vname)];
            end
            M=[M;L];
            L=[];
        end
        figure, 
        imagesc(M,[-1,1]); 
        title('Sub v Sub', 'FontSize', 8);

 

