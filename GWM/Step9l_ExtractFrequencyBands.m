clear; close all; clc;

% IDs
ID = {'001'; '005'; '007'; '008'; '009'; '010'; '011'; '013'; '014'; '015'; '016'; '017'; '018'; '019'; '020'; '021'; '022'; '023'; '024'; '025'; 
      '026'; '027'; '028'; '029'; '031'; '032'; '033'; '034'; '035'; '036'; '037'; '038'; '039'; '040'; '041'; '043'; '044'; '045'; '046'; '047'; 
      '048'; '049'; '050'; '051'; '052'; '053'; '054'; '055'; '056'; '057'; '058'; '059'; '061'; '063'; '064'; '065'; '067'; '068'; '069'; '070'; 
      '071'; '072'; '073'; '074'; '075'; '076'; '077'; '078'; '079'; '080'; '081'; '082'; '083'; '084'; '086'; '087'; '088'; '089'; '090'; '091';
      '092'; '093'; '094'; '095'; '096'; '097'; '098'; '099'; '100'; '101'; '102'; '103'; '104'; '105'; '108'; '109'; '110'; '111'; '112'; '113'; 
      '114'; '115'; '116'; '117'; '118'; '119'; '120'; '121'; '122'; '123'; '124'; '125'; '126'; '127'; '128'; '129'; '130'; '131'; '132'; '133'; 
      '134'; '135'; '136'; '137'; '138'; '139'};
  
% Define the frequency bands
freqBands = [0,4;... % Delta
    4,8;... % Theta
    8,12;... % Alpha
    12,30;... % Beta
    30,40]; % Gamma

freqNames = {'delta';'theta';'alpha';'beta';'gamma'};

% Loop over IDs
for idx = 1:length(ID)
    
    load(['/home/ttha0011/kg98/Thapa/GWM/RESTDATAonly/3_AnalysedEEGdata/2To40Hz_Knee/',ID{idx},filesep,ID{idx},'_rest_pwelch_output.mat']);
    
    freqi = 1:size(freqs,1)';
    
    for freqx = 1:length(freqNames)
        
        temp1 = freqs(:,1) <= freqBands(freqx,1);
        temp2 = freqs(:,1) >= freqBands(freqx,2);
        
        output1 = freqi(temp1);
        output2 = freqi(temp2);
        
        tp(freqx,1) = output1(end)+1;
        tp(freqx,2) = output2(1)-1;
        
        freqAll.(freqNames{freqx})(idx,:) = mean(psds(tp(freqx,1):tp(freqx,2),:),1);
        
    end
    
end
   
save('/home/ttha0011/kg98/Thapa/GWM/RESTDATAonly/3_AnalysedEEGdata/2To40Hz_Knee/freqAll.mat','freqAll','ID');
    
    