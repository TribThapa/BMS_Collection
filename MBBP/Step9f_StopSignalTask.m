clear; close all; clc;
%------------------------------------------------------------------------------------------------------------------------------------------------------   
%  SETTINGS
%------------------------------------------------------------------------------------------------------------------------------------------------------   
filePath = '/projects/kg98/Thapa/GWM/RESTDATAonly/9_StopSignalTask/';
pathOut = '/projects/kg98/Thapa/GWM/RESTDATAonly/9_StopSignalTask/';

% Subject IDs
ID =  {'001'; '005'; '008'; '010'; '011'; '013'; '014'; '015'; '016'; '017'; '018'; '019'; '020'; '021'; '022'; '023'; '024'; '025'; '027'; '028'; 
       '029'; '031'; '033'; '034'; '036'; '037'; '038'; '039'; '041'; '043'; '044'; '045'; '046'; '048'; '049'; '051'; '052'; '053'; '054'; '055';
       '056'; '057'; '058'; '059'; '063'; '064'; '065'; '067'; '070'; '071'; '073'; '074'; '075'; '079'; '080'; '081'; '082'; '083'; '084'; '086'; 
       '088'; '089'; '090'; '092'; '093'; '095'; '096'; '097'; '098'; '099'; '100'; '104'; '108'; '111'; '112'; '113'; '115'; '117'; '118'; '121'; 
       '122'; '123'; '125'; '126'; '127'; '129'; '130'; '131'; '133'; '135'; '136'; '137'; '138'};
%------------------------------------------------------------------------------------------------------------------------------------------------------   
      %Removed: '007', '012', '032', '035', 040', '047', '077', '087', '105', '106', '107' 
     
      %ChangeDetectionTask File missing on Xnat: '116', '132'. 
      
      %ColourWheelTask logical error: '139'
      
      %BarTask File missing on Xnat and Google Drive: '069', '091', '101', '102', '124', '134'      
                   
      %NbackTask File missing on Xnat and Google Drive: '026', '050', '076' 
      
      %StopSignalTask missing on Xnat and Google Drive: '119', '103'
          
      %SymmetrySpanTask missing: '061'; '110'      
      
      %OperationSpanTask missing: '009'; '068'; '078'

      %BackwardsDigitSpanTask missing: '072'; '094'      
             
      %Did not perform MBBP_tasks: '109'; '128'        
      
%-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------   
% CALCULATE WORKING MEMORY CAPACITY FOR STOP SIGNAL TASK (Link: https://www.millisecond.com/download/library/v6/stopsignaltask/stopsignaltask2019/stopsignaltask2019/stopsignaltask2019.manual)
%-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------   

for i = 1:length(ID)
    
    % File name
    filename = [filePath,'GWM',ID{i},'_SST_raw&summary.iqdat']; 
    
    RawData = tdfread(filename);
    
    DataOut = [];    
    DataOut.SubjID = ID{i};
    DataOut.MeanReactionProbability = nanmean(RawData.expressions0x2Ep_rs(2:end,1));
    DataOut.MeanStopSignalDelays = nanmean(RawData.expressions0x2Essd(2:end,1));
    DataOut.MeanTimeReqToStopGo = mean(RawData.expressions0x2Essrt(2:end,1));
    DataOut.MeanRTssrt = nanmean(RawData.expressions0x2Esr_rt(2:end,1));
    DataOut.MeanRTnosignal = nanmean(RawData.expressions0x2Ens_rt(2:end,1));
    DataOut.HitsNoSignal = nanmean(RawData.expressions0x2Ens_hit(2:end,1));
    DataOut.MissNoSignal = nanmean(RawData.expressions0x2Emiss(2:end,1));
    DataOut.Zscore = nanmean(RawData.expressions0x2Ez_score(2:end,1));
    DataOut.Pvalue = nanmean(RawData.expressions0x2Ep_value(2:end,1));

    T{i} = struct2table(DataOut, 'AsArray', true);
    Table = vertcat(T{:}); 
     
   writetable(Table, [pathOut,'Table_StopSignalTask.csv']);
end

