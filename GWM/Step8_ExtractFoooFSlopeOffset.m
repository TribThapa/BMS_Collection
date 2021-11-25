clear; close all; clc;

% Set path string
pathIn = ('/home/ttha0011/kg98/Thapa/GWM/RESTDATAonly/3_AnalysedEEGdata/2To40Hz_Knee/');

% Set the ID numbers
ID = {'001'; '005'; '007'; '008'; '009'; '010'; '011'; '012'; '013'; '014'; '015'; '016'; '017'; '018'; '019'; '020'; '021'; '022'; '023'; '024'; '025';
      '026'; '027'; '028'; '029'; '031'; '032'; '033'; '034'; '036'; '037'; '038'; '039'; '040'; '041'; '043'; '044'; '045'; '046'; '047'; '048'; '049';
      '050'; '051'; '052'; '053'; '054'; '055'; '056'; '057'; '058'; '059'; '061'; '063'; '064'; '065'; '067'; '068'; '069'; '070'; '071'; '072'; '073';
      '074'; '075'; '076'; '077'; '078'; '079'; '080'; '081'; '082'; '083'; '084'; '085'; '086'; '087'; '088'; '089'; '090'; '091'; '092'; '093'; '094';
      '095'; '096'; '097'; '098'; '099'; '100'; '101'; '102'; '103'; '104'; '105'; '106'; '107'; '108'; '109'; '110'; '111'; '112'; '113'; '114'; '115'; 
      '116'; '117'; '118'; '119'; '120'; '121'; '122'; '123'; '124'; '125'; '126'; '127'; '128'; '129'; '130'; '131'; '132'; '133'; '134'; '135'; '136';
      '137'; '138'; '139'};
  
%Removed: '035'; 062: missing .dat file; 066: missing EEG data 

% Set loop to load in data and then save FOOOF exponents in a matrix (ID x chan)
for x = 1:size(ID)
    
    %load([pathIn,ID{x},filesep,'FOOOF_results',filesep,'BGparams_exponent_',ID{x},'.mat']);
    load([pathIn,ID{x},filesep,'FOOOF_results',filesep,'AperiodicParams_exponent_',ID{x},'.mat']);
    
    slopeAll(x,:) = Exponent;
    
end

save([pathIn,'slopeAll.mat'],'slopeAll','ID');

% Set loop to load in data and then save FOOOF exponents in a matrix (ID x chan)
for x = 1:size(ID)
    
    %load([pathIn,ID{x},filesep,'FOOOF_results',filesep,'BGparams_offset_',ID{x},'.mat']);
    load([pathIn,ID{x},filesep,'FOOOF_results',filesep,'AperiodicParams_offset_',ID{x},'.mat']);
    
    offsetAll(x,:) = Offset;
    
end

save([pathIn,'offsetAll.mat'],'offsetAll','ID');