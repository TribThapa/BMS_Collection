clear; close all; clc;

% % ID name
ID = {'001'; '005'; '007'; '008'; '009'; '010'; '011'; '012'; '013'; '014'; '015'; '016'; '017'; '018'; '019'; '020'; '021'; '022'; '023'; '024'; '025';
      '026'; '027'; '028'; '029'; '031'; '032'; '033'; '034'; '035'; '036'; '037'; '038'; '039'; '040'; '041'; '043'; '044'; '045'; '046'; '047'; '048'; 
      '049'; '050'; '051'; '052'; '053'; '054'; '055'; '056'; '057'; '058'; '059'; '061'; '062'; '063'; '064'; '065'; '066'; '067'; '068'; '069'; '070'; 
      '071'; '072'; '073'; '074'; '075'; '076'; '077'; '078'; '079'; '080'; '081'; '082'; '083'; '084'; '085'; '086'; '087'; '088'; '089'; '090'; '091'; 
      '092'; '093'; '094'; '095'; '096'; '097'; '098'; '099'; '100'; '101'; '102'; '103'; '104'; '105'; '106'; '107'; '108'; '109'; '110'; '111'; '112'; 
      '113'; '114'; '115'; '116'; '117'; '118'; '119'; '120'; '121'; '122'; '123'; '124'; '125'; '126'; '127'; '128'; '129'; '130'; '131'; '132'; '133'; 
      '134'; '135'; '136'; '137'; '138'; '139'};
  
    
  
% File path for data
filePath = '/projects/kg98/Thapa/GWM/RESTDATAonly/4_ChangeDetectionTask/';
pathOut = '/projects/kg98/Thapa/GWM/RESTDATAonly/4_ChangeDetectionTask/';

% Add path for functions
addpath('/projects/kg98/Thapa/GWM/Scripts/capacity_scripts_ChangeDetectionTask');

% Define loads
N = [2;4;6];

% Loop over participants
wm_load = zeros(length(ID),length(N)); %creates a cell of zeroes where x-axis = no. of subs; y-axis = no.of loads.

missing = {'116'; '132'};

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
%------------------------------------------------------------------------------------------------------------------------------------------------------   
% CALCULATE WORKING MEMORY CAPACITY FOR CHANGE DETECTION TASK
%------------------------------------------------------------------------------------------------------------------------------------------------------ 

for a = 1:length(ID)
    
    % File name
    filename = [filePath,'GWM',ID{a,1},'_CLT.csv']; %Creates file path and file name 
    
    if ismember(ID{a}, missing)
        
        wm_load(a,:) = NaN;
    
    else
        
    % Load data
    Untitled = importData(filename);

    % calculate kp
    kp = zeros(1,length(N)); %pre-allocate

    for x = 1:length(N)
        [kp(x)] = Calculate_kp(Untitled, N(x));
    end
    
    wm_load(a,:) = kp;
    
    end
    
end

wm_load(:,4) = nanmean(wm_load(:,2:3), 2);

% Generate and save as csv file.
 Table = table(ID, wm_load(:,1), wm_load(:,2), wm_load(:,3), wm_load(:,4));
 Table.Properties.VariableNames = {'ID' 'Load2' 'Load4' 'Load6' 'Load4_6_avg'};
 writetable(Table, [pathOut,'ChangeDetectionTaskAll.csv']);

 % Save output
 save([pathOut, 'ChangeDetectionTaskAll'],'Table');
