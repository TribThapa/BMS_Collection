clear; close all; clc;

%GrandAverage file

pathIn = ('/home/ttha0011/kg98/Thapa/GWM/RESTDATAonly/3_AnalysedEEGdata/2To40Hz_Knee/');

ID = {'001'; '005'; '007'; '008'; '009'; '010'; '011'; '013'; '014'; '015'; '016'; '017'; '018'; '019'; '020'; '021'; '022'; '023'; '024'; '025'; 
      '026'; '027'; '028'; '029'; '031'; '032'; '033'; '034'; '035'; '036'; '037'; '038'; '039'; '040'; '041'; '043'; '044'; '045'; '046'; '047'; 
      '048'; '049'; '050'; '051'; '052'; '053'; '054'; '055'; '056'; '057'; '058'; '059'; '061'; '063'; '064'; '065'; '067'; '068'; '069'; '070'; 
      '071'; '072'; '073'; '074'; '075'; '076'; '077'; '078'; '079'; '080'; '081'; '082'; '083'; '084'; '086'; '087'; '088'; '089'; '090'; '091';
      '092'; '093'; '094'; '095'; '096'; '097'; '098'; '099'; '100'; '101'; '102'; '103'; '104'; '105'; '108'; '109'; '110'; '111'; '112'; '113'; 
      '114'; '115'; '116'; '117'; '118'; '119'; '120'; '121'; '122'; '123'; '124'; '125'; '126'; '127'; '128'; '129'; '130'; '131'; '132'; '133'; 
      '134'; '135'; '136'; '137'; '138'; '139'};

grandAverage = [];

% Frequencies of interest
foi = [2,40];

% Create Frequency bands of interest
freqBands = [3,7;8,12;15,29;30,40];
freqNames = {'theta','alpha','beta','gamma'};


for i = 1:length(ID)
    
    % FoooFResults
    fooof_results = load([pathIn, ID{i},'/FOOOF_results/FOOOFSummary_',ID{i},'.mat']);

    % PwelchResults
    Pwelch_results = load([pathIn,ID{i},'/',ID{i},'_rest_pwelch_output.mat']);
    
    % Find the indicies of the frequencies of interest
    [~,f1] = min(abs(foi(1) - Pwelch_results.freqs(:,1)));
    [~,f2] = min(abs(foi(2) - Pwelch_results.freqs(:,1)));

%     figure('color','w');
    
    offsetVal = [];
    slopeVal = [];
    
    for x = 1:length(fooof_results.Aperiodic_params) %x = 1:length(fooof_results.Background_params)
        
        %offsetVal{x} = [fooof_results.Background_params{x}(1)];
        %slopeVal{x} = [fooof_results.Background_params{x}(2)];
        offsetVal{x} = [fooof_results.Aperiodic_params{x}(1)];
        slopeVal{x} = [fooof_results.Aperiodic_params{x}(3)];
    
        % Test plot - 1/f on spectra (single channel)
        freqSub = Pwelch_results.freqs(f1:f2); % 3-30 Hz
        if size(freqSub,2)>1
            freqSub=freqSub';
        end
        
        dataSub = Pwelch_results.psds(f1:f2,x);
        
        % Calculate the slope
        SL = offsetVal{x}-log10(0+(freqSub.^slopeVal{x}));
        
        % Generate corrected data
        correctedData = log10(dataSub)-SL;
        
        % Peak frequency 
        [~,tempMaxi] = max(correctedData);
        peakFreq = freqSub(tempMaxi);
        
%         subplot(7,10,x)
%         plot(freqSub,log10(dataSub),'k');hold on;
%         plot(freqSub,SL,'r'); 
%         plot(freqSub,correctedData,'b');
       
        % Create a matrix of corrected band values
        for fx = 1:length(freqBands)
            [~,fb1] = min(abs(freqBands(fx,1)-freqSub));
            [~,fb2] = min(abs(freqBands(fx,2)-freqSub));
            correctedPower.(freqNames{fx})(i,x) = mean(correctedData(fb1:fb2));
        end
        correctedPower.peakFreq(i,x) = peakFreq;
    end
    
end


% Save the data
save([pathIn, 'CorrectedData.mat'], 'correctedPower');


                
              

               