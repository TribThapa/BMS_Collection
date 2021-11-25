clear; close all; clc;
%------------------------------------------------------------------------------------------------------------------------------------------------------   
%  SETTINGS
%------------------------------------------------------------------------------------------------------------------------------------------------------ 
p = genpath('/projects/kg98/Thapa/GWM/Scripts/MemToolbox_ORT-1.1.0');
addpath(p);
pathIn = '/projects/kg98/Thapa/GWM/RESTDATAonly/7_OrientationTask/';
pathOut = '/projects/kg98/Thapa/GWM/RESTDATAonly/7_OrientationTask/';

% Set the ID (enter all of the participant IDs here)
ID = {'001'; '005'; '007'; '008'; '009'; '010'; '011'; '012'; '013'; '014'; '015'; '016'; '017'; '018'; '019'; '020'; '021'; '022'; '023'; '024'; '025';
      '026'; '027'; '028'; '029'; '031'; '032'; '033'; '034'; '035'; '036'; '037'; '038'; '039'; '040'; '041'; '043'; '044'; '045'; '046'; '047'; '048'; 
      '049'; '050'; '051'; '052'; '053'; '054'; '055'; '056'; '057'; '058'; '059'; '061'; '062'; '063'; '064'; '065'; '066'; '067'; '068'; '069'; '070'; 
      '071'; '072'; '073'; '074'; '075'; '076'; '077'; '078'; '079'; '080'; '081'; '082'; '083'; '084'; '085'; '086'; '087'; '088'; '089'; '090'; '091'; 
      '092'; '093'; '094'; '095'; '096'; '097'; '098'; '099'; '100'; '101'; '102'; '103'; '104'; '105'; '106'; '107'; '108'; '109'; '110'; '111'; '112'; 
      '113'; '114'; '115'; '116'; '117'; '118'; '119'; '120'; '121'; '122'; '123'; '124'; '125'; '126'; '127'; '128'; '129'; '130'; '131'; '132'; '133'; 
      '134'; '135'; '136'; '137'; '138'; '139'};
  
% Loads
loadNum = [2, 4];

missing = {'035'; '066'; '116'; '132'};

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
% CALCULATE GUESS RATE, PRECISION, & WORKING MEMORY CAPACITY FOR ORIENTATION TASK
%------------------------------------------------------------------------------------------------------------------------------------------------------

for i = 1:length(ID)
    
    if ismember(ID{i}, missing)
        
        guessRate(i,1:3) = NaN;
        precision(i,1:3) = NaN;
        wmCapacity(i,1:3) = NaN;
    
    else
    
    dataOut = [];

   % Load the data
    load([pathIn,'GWM',ID{i},'_ORT.mat']);
        
    % Rename and then delete the exp variable
    exp1 = expr;
    clear expr;
    
    % Convert radians to degrees. This is the unit needed to run the MemFit toolbox
    reportedAngle_deg = radtodeg(data.reportedAngle(1,:));
    targetAngle_deg = radtodeg(data.targetAngle(1,:));
    
    % Normalise to 180 degrees by removing 180 from those degrees > 180
    reportedAngle_degCorr = reportedAngle_deg - 180*(reportedAngle_deg>180);
    targetAngle_degCorr = targetAngle_deg - 180*(targetAngle_deg>180);   
    
    % Convert degrees back to radians
    reportedAngle_degCorr_rad = degtorad(reportedAngle_degCorr(1,:));
    targetAngle_degCorr_rad = degtorad(targetAngle_degCorr(1,:));   
        
    dataOut.errors = (90/pi) .* (angle(exp(1i*reportedAngle_degCorr_rad)./exp(1i*targetAngle_degCorr_rad)));
    dataOut.setSize = prefs.setSizes(prefs.fullFactorialDesign(prefs.order, 1));
    
    for loadx = 1:length(loadNum)
        tempLog = dataOut.setSize == loadNum(loadx);        
        dataOut.(['err',num2str(loadNum(loadx))]) = dataOut.errors(tempLog);
    end

    % Concatenate the data
    for loadx = 1:length(loadNum)
        errorAll.(['load',num2str(loadNum(loadx))]){i} = [dataOut.(['err',num2str(loadNum(loadx))]),...
                                                          dataOut.(['err',num2str(loadNum(loadx))])];
    
    
        %DataIn.errors = errorAll.(['load',num2str(loadNum(loadx))]){i};          
        DataIn.errors = dataOut.errors;          
        
        % Fit the standard mixture model to the data
        posteriorSamples = MCMC(DataIn, StandardMixtureModel, 'Verbosity',0, ...
                'ConvergenceVariance', Inf, ...
                'PostConvergenceSamples', 15000, ...
                'BurnInSamplesBeforeCheck', 5000);
         
        fit = MCMCSummarize(posteriorSamples);
        fit.posteriorSamples = posteriorSamples;
         
        % Save out the Guess rate, precision, and wm capacity estimate 
        guessRate(i,loadx) = fit.maxPosterior(1);
        precision(i,loadx) = fit.maxPosterior(2);
        wmCapacity(i,loadx) = loadNum(loadx).*(1-fit.maxPosterior(1));
    
    end
    
    end   
        
    fprintf('%s complete\n',ID{i});
end

% Generate and save as csv file.
Table = table(ID, guessRate(:,2), precision(:,2), wmCapacity(:,2));
Table.Properties.VariableNames = {'ID', 'GuessRate', 'Precision', 'wmCapacity'};
writetable(Table, [pathOut,'OrientationTaskAll.csv']);
 
% Save the data
save([pathOut,'OrientationTaskAll.mat'], 'wmCapacity', 'precision');


