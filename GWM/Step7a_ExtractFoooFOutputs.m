clc; clear all; close all;

% Set path to parent directory
PathIn = ('/projects/kg98/Thapa/GWM/RESTDATAonly/3_AnalysedEEGdata/2To40Hz_Knee');

% Enter SubjID

SubjID = {'001'; '005'; '007'; '008'; '009'; '010'; '011'; '012'; '013'; '014'; '015'; '016'; '017'; '018'; '019'; '020'; '021'; '022'; '023'; '024'; '025'; 
          '026'; '027'; '028'; '029'; '031'; '032'; '033'; '034'; '036'; '037'; '038'; '039'; '040'; '041'; '043'; '044'; '045'; '046'; '047'; '048'; '049';
          '050'; '051'; '052'; '053'; '054'; '055'; '056'; '057'; '058'; '059'; '061'; '063'; '064'; '065'; '067'; '068'; '069'; '070'; '071'; '072'; '073';
          '074'; '075'; '076'; '077'; '078'; '079'; '080'; '081'; '082'; '083'; '084'; '085'; '086'; '087'; '088'; '089'; '090'; '091'; '092'; '093'; '094';
          '095'; '096'; '097'; '098'; '099'; '100'; '101'; '102'; '103'; '104'; '105'; '106'; '107'; '108'; '109'; '110'; '111'; '112'; '113'; '114'; '115'; 
          '116'; '117'; '118'; '119'; '120'; '121'; '122'; '123'; '124'; '125'; '126'; '127'; '128'; '129'; '130'; '131'; '132'; '133'; '134'; '135'; '136';
          '137'; '138'; '139'};

% Name of folder where FOOOF ouputs are saved
FileName = ('/FOOOF_results/'); 

% Step 2: Create for loop
for ID = 1:length(SubjID);
    
    %Step 1: Full path to FOOOF outputs
    SubjFolder = [PathIn,filesep,[SubjID{ID}],FileName]; 
     
    % Step 2: Change directory to subject's folder with FOOOF outputs
    cd(SubjFolder); 

    chanNums = 0:61;
    
    for iFile = 1:length(chanNums) 
        
        FileData = load(['fooof_results',num2str(chanNums(iFile)),'.mat']);
        %Background_params{iFile} = FileData.background_params;
        Aperiodic_params{iFile} = FileData.aperiodic_params; % For aperiodic_knee FoooF analysis 
        Error{iFile} = FileData.error;
        Gaussian_params{iFile} = FileData.gaussian_params;
        Peak_params{iFile} = FileData.peak_params;
        R_squared{iFile} = FileData.r_squared;
        
    end
      
    % Step 5: Name the file summarising FOOOF outputs from each channel
    newname=[SubjFolder,'FOOOFSummary_',SubjID{ID},'.mat'];

    % Step 6: Save each variable within the file summarising FOOOF outputs from each channel
    save (newname,'Aperiodic_params','Error','Gaussian_params','Peak_params','R_squared','SubjFolder');,

end