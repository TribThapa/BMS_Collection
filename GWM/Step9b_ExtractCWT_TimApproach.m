clear; close all; clc;

% Add the Memtoolbox to the Matlab path
p = genpath('/projects/kg98/Thapa/GWM/Scripts/MemToolbox-1.1.0');
addpath(p);
addpath('/home/ttha0011/kg98/Thapa/GWM/Scripts/TCC_Code_InManuscriptOrder/Model');

% Set the path in
pathIn = '/projects/kg98/Thapa/GWM/RESTDATAonly/5_ColourWheelTask/';

% Set the path to save data out 
pathOut = '/projects/kg98/Thapa/GWM/RESTDATAonly/5_ColourWheelTask/';

% Set the ID (enter all of the participant IDs here)
ID = {'001'; '005'; '007'; '008'; '009'; '010'; '011'; '012'; '013'; '014'; '015'; '016'; '017'; '018'; '019'; '020'; '021'; '022'; '023'; '024'; '025';
      '026'; '027'; '028'; '029'; '031'; '032'; '033'; '034'; '035'; '036'; '037'; '038'; '039'; '040'; '041'; '043'; '044'; '045'; '046'; '047'; '048'; 
      '049'; '050'; '051'; '052'; '053'; '054'; '055'; '056'; '057'; '058'; '059'; '061'; '062'; '063'; '064'; '065'; '066'; '067'; '068'; '069'; '070'; 
      '071'; '072'; '073'; '074'; '075'; '076'; '077'; '078'; '079'; '080'; '081'; '082'; '083'; '084'; '085'; '086'; '087'; '088'; '089'; '090'; '091'; 
      '092'; '093'; '094'; '095'; '096'; '097'; '098'; '099'; '100'; '101'; '102'; '103'; '104'; '105'; '106'; '107'; '108'; '109'; '110'; '111'; '112'; 
      '113'; '114'; '115'; '116'; '117'; '118'; '119'; '120'; '121'; '122'; '123'; '124'; '125'; '126'; '127'; '128'; '129'; '130'; '131'; '132'; '133'; 
      '134'; '135'; '136'; '137'; '138'; '139'};

% Number of sessions
sesNum = {'1';'2';'3';'4'};

% Different loads
loadNum = [2];4;6]; %capacity is typically around 3. To super capacitate average load 4&6.

missing = {'062'; '066'; '106'; '107'; '139'};

%----------------------------------------------------------------------------------------------------------------------------------------------------------   
      %ChangeDetectionTask File missing on Xnat: '116', '132'. 
            
      %ColourWheelTask: '062'; '066'; '106'; '107'; '139'
      
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
% CALCULATE WORKING MEMORY CAPACITY FOR COLOUR WHEEL TASK
%------------------------------------------------------------------------------------------------------------------------------------------------------ 

for idx = 1:length(ID)
    
    if ismember(ID{idx}, missing)
        
        guessRate(idx,1:4) = NaN;
        precision(idx,1:4) = NaN;
        wmCapacity(idx,1:4) = NaN;
    
    else
            
     dataOut = [];
    
    for sesx = 1:length(sesNum)
        
        if ~(strcmp(ID{idx},'077') && strcmp(sesNum{sesx},'1')) && ~(strcmp(ID{idx},'087') && strcmp(sesNum{sesx},'4'))
       
        % Load the data
        load([pathIn,'GWM',ID{idx},'_WM_colour_',sesNum{sesx},'.mat']);
 
        % Rename and then delete the exp variable
        exp1 = exp;
        clear exp; 

        % Calculate the errors and the set sizes for each trial in each session
        dataOut.(['ses',sesNum{sesx}]).errors = (180/pi) .* (angle(exp(1i*data.reportedColor)./exp(1i*data.presentedColor)));       
        dataOut.(['ses',sesNum{sesx}]).setSize = prefs.setSizes(prefs.fullFactorialDesign(prefs.order, 1));
 
        % Extract the errors by load for each session
        for loadx = 1:length(loadNum)
            tempLog = dataOut.(['ses',sesNum{sesx}]).setSize == loadNum(loadx);
            dataOut.(['ses',sesNum{sesx}]).(['err',num2str(loadNum(loadx))]) = dataOut.(['ses',sesNum{sesx}]).errors(tempLog);
        end
        
        end
        
    end    
    
    % Concatenate the data
    for loadx = 1:length(loadNum)
        if strcmp(ID{idx},'077')
            errorAll.(['load',num2str(loadNum(loadx))]){idx} = [dataOut.ses2.(['err',num2str(loadNum(loadx))]),...
            dataOut.ses3.(['err',num2str(loadNum(loadx))]),...
            dataOut.ses4.(['err',num2str(loadNum(loadx))]),...
            ];
        elseif strcmp(ID{idx},'087')
            errorAll.(['load',num2str(loadNum(loadx))]){idx} = [dataOut.ses1.(['err',num2str(loadNum(loadx))]),...
            dataOut.ses2.(['err',num2str(loadNum(loadx))]),...
            dataOut.ses3.(['err',num2str(loadNum(loadx))]),...
            ];
        else
        errorAll.(['load',num2str(loadNum(loadx))]){idx} = [dataOut.ses1.(['err',num2str(loadNum(loadx))]),...
            dataOut.ses2.(['err',num2str(loadNum(loadx))]),...
            dataOut.ses3.(['err',num2str(loadNum(loadx))]),...
            dataOut.ses4.(['err',num2str(loadNum(loadx))]),...
            ];
        end
    
         DataIn.errors = errorAll.(['load',num2str(loadNum(loadx))]){idx};          
         
         posteriorSamples = MLE(DataIn, TCCCorrelated);
         dPrime = TCCCorrelatedMaxLike(DataIn);
         
         fit.posteriorSamples(idx,loadx) = posteriorSamples;        
         fit.dPrime(idx,loadx) = dPrime;        

    end
        
    fprintf('%s complete\n',ID{idx});
    
    end
end

% Generate and save as csv file.
Table = table(ID,fit.posteriorSamples(:,1), fit.posteriorSamples(:,2), fit.posteriorSamples(:,3), fit.dPrime(:,1), fit.dPrime(:,2), fit.dPrime(:,3));
Table.Properties.VariableNames = {'ID', 'MLE_Load2', 'MLE_Load4', 'MLE_Load6', 'dPrime_Load2', 'dPrime_Load4', 'dPrime_Load6'};
writetable(Table, [pathOut,'ColourWheelTaskAll.csv']);

% Save the data
save([pathOut,'ColourWheelTaskAll.mat'],'fit', 'Table');
