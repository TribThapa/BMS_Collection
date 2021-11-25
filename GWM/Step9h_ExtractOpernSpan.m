clear; close all; clc;
%------------------------------------------------------------------------------------------------------------------------------------------------------   
%  SETTINGS
%------------------------------------------------------------------------------------------------------------------------------------------------------   
filePath = '/projects/kg98/Thapa/GWM/RESTDATAonly/11_OperationSpanTask/';
pathOut = '/projects/kg98/Thapa/GWM/RESTDATAonly/11_OperationSpanTask/';

% Subject IDs
ID = {'001'; '005'; '007'; '008'; '009'; '010'; '011'; '012'; '013'; '014'; '015'; '016'; '017'; '018'; '019'; '020'; '021'; '022'; '023'; '024'; '025';
      '026'; '027'; '028'; '029'; '031'; '032'; '033'; '034'; '035'; '036'; '037'; '038'; '039'; '040'; '041'; '043'; '044'; '045'; '046'; '047'; '048'; 
      '049'; '050'; '051'; '052'; '053'; '054'; '055'; '056'; '057'; '058'; '059'; '061'; '062'; '063'; '064'; '065'; '066'; '067'; '068'; '069'; '070'; 
      '071'; '072'; '073'; '074'; '075'; '076'; '077'; '078'; '079'; '080'; '081'; '082'; '083'; '084'; '085'; '086'; '087'; '088'; '089'; '090'; '091'; 
      '092'; '093'; '094'; '095'; '096'; '097'; '098'; '099'; '100'; '101'; '102'; '103'; '104'; '105'; '106'; '107'; '108'; '109'; '110'; '111'; '112'; 
      '113'; '114'; '115'; '116'; '117'; '118'; '119'; '120'; '121'; '122'; '123'; '124'; '125'; '126'; '127'; '128'; '129'; '130'; '131'; '132'; '133'; 
      '134'; '135'; '136'; '137'; '138'; '139'};
  
missing = {'009'; '035'; '061'; '066'; '068'; '078'; '085'; '087'; '105'; '106'; '107'; '109'; '110'; '116'; '128'; '132'};

% %------------------------------------------------------------------------------------------------------------------------------------------------------   
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
%---------------------------------------------------------------------------------------------------------------------------------------------------------------   
% CALCULATE WORKING MEMORY CAPACITY FOR OPERATION SPAN TASK (Link: https://www.millisecond.com/download/library/v6/ospan/automatedospan/automatedospan.manual)
% Paper: Unsworth et al. (2005) An automated version of the operation span task
% Paper: Conway et al. (2005) WM span tasks. Page 775
%---------------------------------------------------------------------------------------------------------------------------------------------------------------   

for i = 1:length(ID)
    
    if ismember(ID{i}, missing)
        
        DataOut.ID = ID{i};
        DataOut.Ospan = NaN;
        DataOut.PartialOspan = NaN;
        DataOut.TotalCorrectLetters = NaN;
        DataOut.MathTotalErrors = NaN;
        DataOut.MathSpeedErrors = NaN;
        DataOut.MathAccErrors = NaN; 
       
    else
    
    % File name
    filename = [filePath,'/GWM',ID{i},'_OPN_raw.iqdat']; 
    
    RawData = tdfread(filename);
    Response = cellstr(string(RawData.response));
    CurrentItem = cellstr(string(RawData.text0x2Eletters0x2Ecurrentitem));
    RecalledLetters = cellstr(string(RawData.values0x2Erecalledletters));

    
    DataOut = [];    
    DataOut.ID = ID{i};
    DataOut.Ospan = RawData.values0x2Eospan(size(RawData.values0x2Eospan,1), 1);
    DataOut.PartialOspan = max(RawData.values0x2Etotalcorrectletters);
    DataOut.TotalCorrectLetters = RawData.values0x2Etotalcorrectletters(size(RawData.values0x2Etotalcorrectletters,1), 1);
    DataOut.MathTotalErrors = RawData.values0x2Emathtotalerrors(size(RawData.values0x2Emathtotalerrors,1), 1);
    DataOut.MathSpeedErrors = RawData.values0x2Emathspeederrors(size(RawData.values0x2Emathspeederrors,1), 1);
    DataOut.MathAccErrors = RawData.values0x2Emathaccerrors(size(RawData.values0x2Emathaccerrors,1), 1);

    end
    
    T{i} = struct2table(DataOut, 'AsArray', true);
    Table = vertcat(T{:});      
    writetable(Table, [pathOut,'OperationSpanTaskAll.csv']);
end

% Save as mat file
save([pathOut,'OperationSpanTaskAll.mat'],'Table');
