]clc; clear all; close all;

%Step 1: Determine path to Study design directory.
DataDir = ['/projects/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/3_IdentificationScoreTest/'];

%Step 2: Enter subject IDs.
subID = {'sub-GAB007'};%, 'sub-GAB009'}; 

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
        
        Corr_mat1 = corr(TimeSeries1');
        Corr_mat2 = corr(TimeSeries2');
        Corr_mat3 = corr(TimeSeries');
        
        %figure;
        ax(1) = subplot(1,15,1:3);
        imagesc(Corr_mat1);
        title('First half');
         
        ax(2) = subplot(1,15,5:7);
        imagesc(Corr_mat2);
        title('Second half');
        
        ax(3) = subplot(1,15,10:15);
        imagesc(Corr_mat3);
        title('Full TimeSeries');
        
        colorbar;
        colormap jet;
        
        saveas(gcf, [DataDir,subID{i},'/TimeSeries/',subID{i},'_task-',cond{j},'_IndentityMatrices'], 'png');
    end
    
    IDScore = zeros(1,170);
        
    for k = 1:170; % k is the number of signal/eigenvalues (assuming that you have 170 signal points) 
    
        [r,p] = corr(Corr_mat1(:,1:k)', Corr_mat2(:,1:k)'); %Pearson r
    
        idx = find(~eye(size(r))); %indices of off-diagonal elements
    
        IDScore(k) = (mean(diag(r))-mean(r(idx)))*100; %above line is the difference between the mean of diagonal and the mean of off-diagonal elements;you also can try median instead of mean
    end

    MaxIDScore = find(IDScore==max(IDScore));

    figure;plot(IDScore);
    xlabel('Number of volumes');
    legend (['Max IDscore=',num2str(MaxIDScore)]);

    saveas(gcf, [DataDir,subID{i},'/TimeSeries/',subID{i},'_task-',cond{j},'_IDScore'], 'png');
end
