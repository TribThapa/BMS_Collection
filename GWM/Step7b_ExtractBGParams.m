clc; clear all; close all;

% Step 1: Set path to parent directory
PathIn = ('/home/ttha0011/kg98/Thapa/GWM/RESTDATAonly/3_AnalysedEEGdata/2To40Hz_Knee/'); 

% Enter SubjID
SubjID = {'001'; '005'; '007'; '008'; '009'; '010'; '011'; '012'; '013'; '014'; '015'; '016'; '017'; '018'; '019'; '020'; '021'; '022'; '023'; '024'; '025'; 
          '026'; '027'; '028'; '029'; '031'; '032'; '033'; '034'; '036'; '037'; '038'; '039'; '040'; '041'; '043'; '044'; '045'; '046'; '047'; '048'; '049';
          '050'; '051'; '052'; '053'; '054'; '055'; '056'; '057'; '058'; '059'; '061'; '063'; '064'; '065'; '067'; '068'; '069'; '070'; '071'; '072'; '073';
          '074'; '075'; '076'; '077'; '078'; '079'; '080'; '081'; '082'; '083'; '084'; '085'; '086'; '087'; '088'; '089'; '090'; '091'; '092'; '093'; '094';
          '095'; '096'; '097'; '098'; '099'; '100'; '101'; '102'; '103'; '104'; '105'; '106'; '107'; '108'; '109'; '110'; '111'; '112'; '113'; '114'; '115'; 
          '116'; '117'; '118'; '119'; '120'; '121'; '122'; '123'; '124'; '125'; '126'; '127'; '128'; '129'; '130'; '131'; '132'; '133'; '134'; '135'; '136';
          '137'; '138'; '139'};
       
% Name folder where FOOOF ouputs are saved
FileName = ('/FOOOF_results/'); 

% Step 2: Create for loop
for ID = 1:length(SubjID);
    
    %Step 1: Full path to FOOOFSummary
    SubjFolder = [PathIn,filesep,[SubjID{ID}],FileName]; 
     
    % Step 2: Change directory to subject's folder with FOOOFSummary
    cd(SubjFolder); 
    
    % Step 3: Define FOOOFSummary file
    FoooFSummaryFile = (['FOOOFSummary_' num2str([SubjID{ID}]) '.mat']);
    
    % Step 4: Create a matfile from the FOOOFSummary file lodaed in Step 3. This allows you to make changes without effecting the main file.
    m = matfile(FoooFSummaryFile);
    
    % Step 5: Access the Background parameters data in the FOOOFSummary file
    %BGparams = m.Background_params';
    AperiodicParams = m.Aperiodic_params';

    % Step 6: Create a loop to separate the Offset and Exponent components into separate columns. Currenlty these values are all in the one cell.
%     for i = 1:length(BGparams);
%         Offset(i)=BGparams{i}(1);
%         Exponent(i)=BGparams{i}(2);
%     end
    
    for i = 1:length(AperiodicParams);
        Offset(i)=AperiodicParams{i}(1);
        Exponent(i)=AperiodicParams{i}(3);
    end
    
    % Step 7: Name the file summarising the Offset and Exponent components
    %BGparams_Offset=[SubjFolder,'BGparams_offset_',SubjID{ID},'.mat'];
    %BGparams_Exponent=[SubjFolder,'BGparams_exponent_',SubjID{ID},'.mat'];
    
    AperiodicParams_Offset=[SubjFolder,'AperiodicParams_offset_',SubjID{ID},'.mat'];
    AperiodicParams_Exponent=[SubjFolder,'AperiodicParams_exponent_',SubjID{ID},'.mat'];
    
    
    % Step 8: Save the Offset and Exponent components in each subject's FOOOF_results folder.
    %save (BGparams_Offset,'Offset');,
    %save (BGparams_Exponent,'Exponent');,
    
    save (AperiodicParams_Offset,'Offset');,
    save (AperiodicParams_Exponent,'Exponent');,
end

