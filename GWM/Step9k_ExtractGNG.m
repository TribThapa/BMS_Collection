clear; close all; clc;
%------------------------------------------------------------------------------------------------------------------------------------------------------   
%  SETTINGS
%------------------------------------------------------------------------------------------------------------------------------------------------------   
filePath = '/projects/kg98/Thapa/GWM/RESTDATAonly/14_GoNoGoTask/';
pathOut = '/projects/kg98/Thapa/GWM/RESTDATAonly/14_GoNoGoTask/';

% Subject IDs
ID = {'001'; '005'; '007'; '008'; '009'; '010'; '011'; '012'; '013'; '014'; '015'; '016'; '017'; '018'; '019'; '020'; '021'; '022'; '023'; '024'; '025';
      '026'; '027'; '028'; '029'; '031'; '032'; '033'; '034'; '035'; '036'; '037'; '038'; '039'; '040'; '041'; '043'; '044'; '045'; '046'; '047'; '048'; 
      '049'; '050'; '051'; '052'; '053'; '054'; '055'; '056'; '057'; '058'; '059'; '061'; '062'; '063'; '064'; '065'; '066'; '067'; '068'; '069'; '070'; 
      '071'; '072'; '073'; '074'; '075'; '076'; '077'; '078'; '079'; '080'; '081'; '082'; '083'; '084'; '085'; '086'; '087'; '088'; '089'; '090'; '091'; 
      '092'; '093'; '094'; '095'; '096'; '097'; '098'; '099'; '100'; '101'; '102'; '103'; '104'; '105'; '106'; '107'; '108'; '109'; '110'; '111'; '112'; 
      '113'; '114'; '115'; '116'; '117'; '118'; '119'; '120'; '121'; '122'; '123'; '124'; '125'; '126'; '127'; '128'; '129'; '130'; '131'; '132'; '133'; 
      '134'; '135'; '136'; '137'; '138'; '139'};
  
missing = {'029'; '035'; '061'; '066'; '067'; '081'; '085'; '087'; '105'; '106'; '107'; '109'; '110'; '116'; '128'; '132'}; 
   
%------------------------------------------------------------------------------------------------------------------------------------------------------   
      %ChangeDetectionTask File missing on Xnat: '116', '132'. 
            
      %ColourWheelTask: '062'; '066';  '106'; '107'; '139'
      
      %BarTask File missing on Xnat and Google Drive: '035'; '066'; '069'; '091'; '101'; '102'; '116'; '124'; '134'

      %OrientationTask: ''035'; '066'; '116'; '132';
                   
      %NbackTask File missing on Xnat and Google Drive: '026'; '035'; '050'; '052'; '066'; '076'; '101'; '102'; '124' 
      
      %StopSignalTask missing on Xnat and Google Drive: '035'; '066'; '103'; '116'; '119';
          
      %SymmetrySpanTask missing: '035'; '061'; '066'; '085'; '087'; '105'; '106'; '107'; '109'; '110'; '116'; '128'; '132'      
      
      %OperationSpanTask missing: '009'; '035'; '061'; '066'; '068'; '078'; '085'; '087'; '105'; '106'; '107'; '109'; '110'; '116'; '128'; '132'

      %BackwardsDigitSpanTask missing: '035'; '061'; '066'; '072'; '085'; '087'; '094'; '105'; '106'; '107'; '109'; '110'; '116'; '128'; '132'  

      %SimonTask missing: '031'; '035'; '046' '057'; '061'; '066'; '070'; '071'; '074'; '085'; '087'; '105'; '106'; '107'; '109'; '110'; '116'; '128'; '131'; '132'; '133'  
      
      %GoNoGoTask missing: '029'; '035'; '061'; '066'; '067'; '081'; '085'; '087'; '105'; '106'; '107'; '109'; '110'; '116'; '128'; '132'; 

      %Did not perform MBBP_tasks: '109'; '128' 
%----------------------------------------------------------------------------------------------------------------------------------------------------   
% CALCULATE WORKING MEMORY CAPACITY FOR STOP SIGNAL TASK (Link: https://www.millisecond.com/download/library/v6/gonogo/cuedgonogo/cuedgonogo.manual).
% Meule 2019 Reporting and Interpreting Task Performance in Go/No-Go Affective Shifting Tasks
%----------------------------------------------------------------------------------------------------------------------------------------------------   

for i = 1:length(ID)
   
    % File name
    filename = [filePath,'GWM',ID{i},'_GNG_raw.iqdat']; 
       

     if ismember(ID{i}, missing) 
         
        DataOut.ID = ID{i};
        DataOut.NoOfTrials = NaN;
        DataOut.OmssnRate = NaN;
        DataOut.CommssnRate = NaN; 
        DataOut.ErrRate = NaN;  
        DataOut.Err_VertCue = NaN;
        DataOut.Err_HorzCue = NaN;    
        DataOut.OmssnErr_Vert = NaN;
        DataOut.Commssn_Vert = NaN;  
        DataOut.OmssnErr_Horz = NaN;
        DataOut.Commssn_Horz = NaN;    
        DataOut.meanRT_Go = NaN;
        DataOut.meanRT_VertGo = NaN;
        DataOut.meanRT_HorzGo = NaN;

     else
         
    RawData = tdfread(filename);
    
    DataOut = [];    
    DataOut.ID = ID{i};
    DataOut.NoOfTrials = length(RawData.values0x2Etrialcount);
    DataOut.OmssnRate = ((sum(RawData.response(RawData.expressions0x2Etargetcondition == 1) == 0)) / sum(RawData.expressions0x2Etargetcondition == 1));
    DataOut.CommssnRate = ((sum(RawData.response(RawData.expressions0x2Etargetcondition == 2) == 57)) / sum(RawData.expressions0x2Etargetcondition == 2));
    DataOut.ErrRate = (DataOut.OmssnRate + DataOut.CommssnRate);
    
    DataOut.Err_VertCue = (sum(RawData.correct(RawData.values0x2Ecuetype == 1) == 0) / sum(RawData.values0x2Ecuetype == 1));
    DataOut.Err_HorzCue = (sum(RawData.correct(RawData.values0x2Ecuetype == 2) == 0) / sum(RawData.values0x2Ecuetype == 2));
    DataOut.OmssnErr_Vert = (sum(RawData.correct(RawData.values0x2Ecuetype == 1 & RawData.expressions0x2Etargetcondition == 1) == 0) / sum(RawData.values0x2Ecuetype == 1 & RawData.expressions0x2Etargetcondition == 1));
    DataOut.Commssn_Vert = (sum(RawData.correct(RawData.values0x2Ecuetype == 1 & RawData.expressions0x2Etargetcondition == 2) == 0) / sum(RawData.values0x2Ecuetype == 1 & RawData.expressions0x2Etargetcondition == 2));
    DataOut.OmssnErr_Horz = (sum(RawData.correct(RawData.values0x2Ecuetype == 2 & RawData.expressions0x2Etargetcondition == 1) == 0) / sum(RawData.values0x2Ecuetype == 2 & RawData.expressions0x2Etargetcondition == 1));
    DataOut.Commssn_Horz = (sum(RawData.correct(RawData.values0x2Ecuetype == 2 & RawData.expressions0x2Etargetcondition == 2) == 0) / sum(RawData.values0x2Ecuetype == 2 & RawData.expressions0x2Etargetcondition == 2));
   
    DataOut.meanRT_Go = mean(RawData.latency(RawData.expressions0x2Etargetcondition == 1 & RawData.correct == 1));
    DataOut.meanRT_VertGo = mean(RawData.latency(RawData.values0x2Ecuetype == 1 & RawData.expressions0x2Etargetcondition == 1 & RawData.correct == 1));
    DataOut.meanRT_HorzGo = mean(RawData.latency(RawData.values0x2Ecuetype == 2 & RawData.expressions0x2Etargetcondition == 1 & RawData.correct == 1));
     
    end
    
    T{i} = struct2table(DataOut, 'AsArray', true);
    Table = vertcat(T{:}); 
        
    writetable(Table, [pathOut,'GoNoGoTaskAll.csv']);
        
end

% Save as mat file
save([pathOut,'GoNoGoTaskAll.mat'],'Table');
