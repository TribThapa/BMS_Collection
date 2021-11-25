clear; close all; clc;
%------------------------------------------------------------------------------------------------------------------------------------------------------   
%  SETTINGS
%------------------------------------------------------------------------------------------------------------------------------------------------------   
filePath = '/projects/kg98/Thapa/GWM/RESTDATAonly/13_SimonTask/';
pathOut = '/projects/kg98/Thapa/GWM/RESTDATAonly/13_SimonTask/';

% Subject IDs
ID = {'001'; '005'; '007'; '008'; '009'; '010'; '011'; '012'; '013'; '014'; '015'; '016'; '017'; '018'; '019'; '020'; '021'; '022'; '023'; '024'; '025';
      '026'; '027'; '028'; '029'; '031'; '032'; '033'; '034'; '035'; '036'; '037'; '038'; '039'; '040'; '041'; '043'; '044'; '045'; '046'; '047'; '048'; 
      '049'; '050'; '051'; '052'; '053'; '054'; '055'; '056'; '057'; '058'; '059'; '061'; '062'; '063'; '064'; '065'; '066'; '067'; '068'; '069'; '070'; 
      '071'; '072'; '073'; '074'; '075'; '076'; '077'; '078'; '079'; '080'; '081'; '082'; '083'; '084'; '085'; '086'; '087'; '088'; '089'; '090'; '091'; 
      '092'; '093'; '094'; '095'; '096'; '097'; '098'; '099'; '100'; '101'; '102'; '103'; '104'; '105'; '106'; '107'; '108'; '109'; '110'; '111'; '112'; 
      '113'; '114'; '115'; '116'; '117'; '118'; '119'; '120'; '121'; '122'; '123'; '124'; '125'; '126'; '127'; '128'; '129'; '130'; '131'; '132'; '133'; 
      '134'; '135'; '136'; '137'; '138'; '139'};
  
missing = {'031'; '035'; '046'; '057'; '061'; '066'; '070'; '071'; '074'; '085'; '087'; '105'; '106'; '107'; '109'; '110'; '116'; '128'; '131'; '132'; '133'}; 
%'031'; '046'; '070'; & '074' had extreme values
   
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
%----------------------------------------------------------------------------------------------------------------------------------------------------------   
% CALCULATE WORKING MEMORY CAPACITY FOR SIMON TASK (Link: https://www.millisecond.com/download/library/v6/simontask/visualsimontask/visualsimontask.manual)
% Paper: Mahani et al. 2019 Multimodal Simon Effect: A Multimodal Extension of the Diffusion Model for Conflict Tasks.
%----------------------------------------------------------------------------------------------------------------------------------------------------------   

for i = 1:length(ID)
    
    if ismember(ID{i}, missing)        
        DataOut.ID = ID{i};
        DataOut.propCorrect = NaN;
        DataOut.MeanRT = NaN;
        DataOut.propCorrect_Cong = NaN; 
        DataOut.MeanRT_Congruent = NaN;  
        DataOut.propCorrect_Incong = NaN;
        DataOut.MeanRT_Incongruent = NaN;    
        DataOut.SimonEffect = NaN;
       
    else
    
    % File name
    filename = [filePath,'GWM',ID{i},'_SMT_raw.iqdat']; 
    RawData = tdfread(filename);
    
    %Convert cells to string array
    CongvsIncong = cellstr(string(RawData.values0x2Econgruence));
    StimPosition = cellstr(string(RawData.values0x2Estimhpos));
    StimType = cellstr(string(RawData.values0x2Estimtype));
    
    %Count occurances
    CongvsIncong_count = count(CongvsIncong, 'incongruent');
    StimPosition_count = count(StimPosition, 'left');  
    StimType_count = count(StimType, 'blue');
    
    %Create logical operators
    Congruent_logic = CongvsIncong_count(:,1) == 0;
    Incongruent_logic = CongvsIncong_count(:,1) == 1;

    %Mean RT for Congruent and Incongruent 
    MeanRT_Cong = mean(RawData.latency(Congruent_logic));    
    MeanRT_Incong = mean(RawData.latency(Incongruent_logic));
    
    DataOut = [];    
    DataOut.ID = ID{i};
    DataOut.propCorrect = sum(RawData.correct(:,1) == 1) / sum(RawData.correct(:,1));
    DataOut.MeanRT = mean(RawData.latency(RawData.correct == 1));
    DataOut.propCorrect_Cong = (sum(RawData.correct(Congruent_logic) == 1) / length(RawData.correct(Congruent_logic)));    
    DataOut.MeanRT_Congruent = mean(RawData.latency(Congruent_logic));    
    DataOut.propCorrect_Incong = (sum(RawData.correct(Incongruent_logic) == 1) / length(RawData.correct(Incongruent_logic)));     
    DataOut.MeanRT_Incongruent = mean(RawData.latency(Incongruent_logic));    
    DataOut.SimonEffect = DataOut.MeanRT_Incongruent - DataOut.MeanRT_Congruent;
    
    end
    
    T{i} = struct2table(DataOut, 'AsArray', true);
    Table = vertcat(T{:}); 
     
    writetable(Table, [pathOut,'SimonTaskAll.csv']);
   
end

% Save as mat file
save([pathOut,'SimonTaskAll.mat'],'Table');
