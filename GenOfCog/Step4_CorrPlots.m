clc; clear all; close all;
 
DataDir = ('/home/ttha0011/kg98_scratch/Sid/GoC/output/timeseries/'); 
OutDir = ('/home/ttha0011/kg98_scratch/Sid/GoC/output/conmats/');

NoGSR = [DataDir,'fix_noGsr/'];    
GSR = [DataDir,'fix_gsr/'];
        
subID = dir([GSR, '*.txt']);


for i = 1:length(subID)
          
    ts1 = dlmread(append(NoGSR, subID(i).name));
    ts2 = dlmread(append(GSR, subID(i).name));
     
    fc1 = corrcoef(ts1');  
    fc2 = corrcoef(ts2');

    IDs = regexprep(subID(i).name, {'ts_', '.txt'}, {'', ''});
       
    save([OutDir,'/fix_NoGsr/',IDs,'_NoGSR.mat'],'fc1');
    save([OutDir,'/fix_gsr/',IDs,'_GSR.mat'],'fc2');
    
%     imagesc(fc1);
%     title(['No GSR ', IDs]);
%     saveas(gcf, [OutDir,'/fix_NoGsr/', IDs,'_NoGSR'], 'png');
% 
%     imagesc(fc2);
%     title(['GSR ', IDs]);
%     saveas(gcf, [OutDir,'/fix_gsr/',IDs,'_GSR'], 'png');
    
end

