clear; close all; clc;

% Set path
pathIn = '/projects/kg98/Thapa/GWM/RESTDATAonly/3_AnalysedEEGdata/2To40Hz/';

% Load data

ID = {'001'; '005'; '007'; '008'; '009'; '010'; '011'; '012'; '013'; '014'; '015'; '016'; '017'; '018'; '019'; '020'; '021'; '022'; '023'; '024'; '025';
      '026'; '027'; '028'; '029'; '031'; '032'; '033'; '034'; '035'; '036'; '037'; '038'; '039'; '040'; '041'; '043'; '044'; '045'; '046'; '047'; '048'; 
      '049'; '050'; '051'; '052'; '053'; '054'; '055'; '056'; '057'; '058'; '059'; '061'; '063'; '064'; '065'; '067'; '068'; '069'; '070'; '071'; '072';
      '073'; '074'; '075'; '076'; '077'; '078'; '079'; '080'; '081'; '082'; '083'; '084'; '085'; '086'; '087'; '088'; '089'; '090'; '091'; '092'; '093'; 
      '094'; '095'; '096'; '097'; '098'; '099'; '100'; '101'; '102'; '103'; '104'; '105'; '106'; '107'; '108'; '109'; '110'; '111'; '112'; '113'; '114'; 
      '115'; '116'; '117'; '118'; '119'; '120'; '121'; '122'; '123'; '124'; '125'; '126'; '127'; '128'; '129'; '130'; '131'; '132'; '133'; '134'; '135'; 
      '136'; '137'; '138'; '139'};
  
  % Load data
   for idx = 1:length(ID)
       
        load([pathIn,ID{idx},filesep,ID{idx},'_rest_pwelch_output.mat']);
        
        freqAll(:,:,idx) = freqs;
        psdAll(:,:,idx) = psds;
        
   end
   
   load([pathIn,'slopeAll.mat']);
   load([pathIn,'offsetAll.mat']);
      
   % Find the time range of interest
   [~,f1] = min(abs(2 - freqAll(:,1,1)));
   [~,f2] = min(abs(40- freqAll(:,1,1)));
   
   freq = freqAll(:,1,1);
   
   bc = mean(offsetAll(:,5),1);
   xc = mean(slopeAll(:,5),1);
   fc = freq(f1:f2);
   Lc = bc-log10(fc.^xc);
   
   bf = mean(offsetAll(:,19),1);
   xf = mean(slopeAll(:,19),1);
   ff = freq(f1:f2);
   Lf = bf-log10(ff.^xf);
   
   figure('color','w');
   plot(log10(freq(f1:f2)),log10(nanmean(psdAll(f1:f2,5,:),3)),'b'); hold on;
   plot(log10(freq(f1:f2)),Lc,'b--');
   plot(log10(freq(f1:f2)),log10(nanmean(psdAll(f1:f2,19,:),3)),'r');
   plot(log10(freq(f1:f2)),Lf,'r--');
   
   legend({'C3','Pz'});
   
   
   