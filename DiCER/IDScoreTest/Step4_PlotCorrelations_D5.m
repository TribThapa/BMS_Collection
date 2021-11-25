clc; clear all; close all;

%Step 1: Determine path to Study design directory.
DataDir = ['/projects/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/3_IdentificationScoreTest'];

%Step 2: All subejects.
% subID = {'sub-10159'; 'sub-10171'; 'sub-10189'; 'sub-10206'; 'sub-10217'; 'sub-10225'; 'sub-10227'; 'sub-10228'; 'sub-10235';
%          'sub-10249'; 'sub-10269'; 'sub-10271'; 'sub-10273'; 'sub-10274'; 'sub-10280'; 'sub-10290'; 'sub-10292'; 'sub-10304'; 
%          'sub-10316'; 'sub-10321'; 'sub-10325'; 'sub-10329'; 'sub-10339'; 'sub-10340'; 'sub-10345'; 'sub-10347'; 'sub-10356'; 
%          'sub-10361'; 'sub-10365'; 'sub-10376'; 'sub-10377'; 'sub-10388'; 'sub-10429'; 'sub-10438'; 'sub-10440'; 'sub-10448'; 
%          'sub-10455'; 'sub-10460'; 'sub-10471'; 'sub-10478'; 'sub-10487'; 'sub-10492'; 'sub-10506'; 'sub-10517'; 'sub-10523';, 
%          'sub-10525'; 'sub-10527'; 'sub-10530'; 'sub-10557'; 'sub-10565'; 'sub-10570'; 'sub-10575'; 'sub-10624'; 'sub-10629'; 
%          'sub-10631'; 'sub-10638'; 'sub-10668'; 'sub-10672'; 'sub-10674'; 'sub-10678'; 'sub-10680'; 'sub-10686'; 'sub-10692'; 
%          'sub-10696'; 'sub-10697'; 'sub-10704'; 'sub-10707'; 'sub-10708'; 'sub-10719'; 'sub-10724'; 'sub-10746'; 'sub-10762'; 
%          'sub-10779'; 'sub-10785'; 'sub-10788'; 'sub-10844'; 'sub-10855'; 'sub-10871'; 'sub-10877'; 'sub-10882'; 'sub-10891';
%          'sub-10893'; 'sub-10912'; 'sub-10934'; 'sub-10940'; 'sub-10949'; 'sub-10958'; 'sub-10963'; 'sub-10968'; 'sub-10975'; 
%          'sub-10977'; 'sub-10987'; 'sub-10998'; 'sub-11019'; 'sub-11030'; 'sub-11044'; 'sub-11050'; 'sub-11052'; 'sub-11059'; 
%          'sub-11061'; 'sub-11062'; 'sub-11066'; 'sub-11067'; 'sub-11068'; 'sub-11077'; 'sub-11088'; 'sub-11090'; 'sub-11097';
%          'sub-11098'; 'sub-11104'; 'sub-11105'; 'sub-11106'; 'sub-11108'; 'sub-11112'; 'sub-11122'; 'sub-11128'; 'sub-11131'; 
%          'sub-11142'; 'sub-11143'; 'sub-11149'; 'sub-11156'; 'sub-50004'; 'sub-50005'; 'sub-50006'; 'sub-50007'; 'sub-50008'; 
%          'sub-50010'; 'sub-50013'; 'sub-50014'; 'sub-50015'; 'sub-50016'; 'sub-50020'; 'sub-50021'; 'sub-50022'; 'sub-50023'; 
%          'sub-50025'; 'sub-50027'; 'sub-50029'; 'sub-50032'; 'sub-50033'; 'sub-50034'; 'sub-50035'; 'sub-50036'; 'sub-50038'; 
%          'sub-50043'; 'sub-50047'; 'sub-50048'; 'sub-50049'; 'sub-50050'; 'sub-50051'; 'sub-50052'; 'sub-50053'; 'sub-50054'; 
%          'sub-50055'; 'sub-50056'; 'sub-50058'; 'sub-50059'; 'sub-50060'; 'sub-50061'; 'sub-50064'; 'sub-50066'; 'sub-50067'; 
%          'sub-50069'; 'sub-50073'; 'sub-50075'; 'sub-50076'; 'sub-50077'; 'sub-50080'; 'sub-50081'; 'sub-50083'; 'sub-50085'; 
%          'sub-60001'; 'sub-60005'; 'sub-60006'; 'sub-60008'; 'sub-60010'; 'sub-60011'; 'sub-60012'; 'sub-60014'; 'sub-60015'; 
%    	   'sub-60016'; 'sub-60017'; 'sub-60020'; 'sub-60021'; 'sub-60022'; 'sub-60028'; 'sub-60030'; 'sub-60033'; 'sub-60036'; 
%		   'sub-60037'; 'sub-60038'; 'sub-60042'; 'sub-60043'; 'sub-60045'; 'sub-60046'; 'sub-60048'; 'sub-60049'; 'sub-60051'; 
%		   'sub-60052'; 'sub-60053'; 'sub-60055'; 'sub-60056'; 'sub-60057'; 'sub-60060'; 'sub-60062'; 'sub-60065'; 'sub-60066';
%          'sub-60068'; 'sub-60070'; 'sub-60072'; 'sub-60073'; 'sub-60074'; 'sub-60076'; 'sub-60077'; 'sub-60078'; 'sub-60079';
%          'sub-60080'; 'sub-60084'; 'sub-60087'; 'sub-60089'; 'sub-70001'; 'sub-70004'; 'sub-70007'; 'sub-70010'; 'sub-70015';
%          'sub-70017'; 'sub-70020'; 'sub-70021'; 'sub-70022'; 'sub-70026'; 'sub-70029'; 'sub-70033'; 'sub-70034'; 'sub-70037';
%          'sub-70040'; 'sub-70046'; 'sub-70048'; 'sub-70049'; 'sub-70051'; 'sub-70052'; 'sub-70055'; 'sub-70057'; 'sub-70058';
%          'sub-70060'; 'sub-70061'; 'sub-70065'; 'sub-70068'; 'sub-70069'; 'sub-70070'; 'sub-70072'; 'sub-70073'; 'sub-70074';
%          'sub-70075'; 'sub-70076'; 'sub-70077'; 'sub-70079'; 'sub-70080'; 'sub-70081'; 'sub-70083'; 'sub-70086}';


%Step 2: Healthy subjects.
subID = {'sub-10159'}; %'sub-10171'; 'sub-10189'; 'sub-10206'; 'sub-10217'; 'sub-10225'; 'sub-10227'; 'sub-10228'; 'sub-10235';
%          'sub-10249'; 'sub-10269'; 'sub-10271'; 'sub-10273'; 'sub-10274'; 'sub-10280'; 'sub-10290'; 'sub-10292'; 'sub-10304'; 
%          'sub-10316'; 'sub-10321'; 'sub-10325'; 'sub-10329'; 'sub-10339'; 'sub-10340'; 'sub-10345'; 'sub-10347'; 'sub-10356'; 
%          'sub-10361'; 'sub-10365'; 'sub-10376'; 'sub-10377'; 'sub-10388'; 'sub-10429'; 'sub-10438'; 'sub-10440'; 'sub-10448'; 
%          'sub-10455'; 'sub-10460'; 'sub-10471'; 'sub-10478'; 'sub-10487'; 'sub-10492'; 'sub-10506'; 'sub-10517'; 'sub-10523'; 
%          'sub-10525'; 'sub-10527'; 'sub-10530'; 'sub-10557'; 'sub-10565'; 'sub-10570'; 'sub-10575'; 'sub-10624'; 'sub-10629'; 
%          'sub-10631'; 'sub-10638'; 'sub-10668'; 'sub-10672'; 'sub-10674'; 'sub-10678'; 'sub-10680'; 'sub-10686'; 'sub-10692'; 
%          'sub-10696'; 'sub-10697'; 'sub-10704'; 'sub-10707'; 'sub-10708'; 'sub-10719'; 'sub-10724'; 'sub-10746'; 'sub-10762'; 
%          'sub-10779'; 'sub-10785'; 'sub-10788'; 'sub-10844'; 'sub-10855'; 'sub-10871'; 'sub-10877'; 'sub-10882'; 'sub-10891';
%          'sub-10893'; 'sub-10912'; 'sub-10934'; 'sub-10940'; 'sub-10949'; 'sub-10958'; 'sub-10963'; 'sub-10968'; 'sub-10975'; 
%          'sub-10977'; 'sub-10987'; 'sub-10998'; 'sub-11019'; 'sub-11030'; 'sub-11044'; 'sub-11050'; 'sub-11052'; 'sub-11059'; 
%          'sub-11061'; 'sub-11062'; 'sub-11066'; 'sub-11067'; 'sub-11068'; 'sub-11077'; 'sub-11088'; 'sub-11090'; 'sub-11097';
%          'sub-11098'; 'sub-11104'; 'sub-11105'; 'sub-11106'; 'sub-11108'; 'sub-11112'; 'sub-11122'; 'sub-11128'; 'sub-11131'; 
%          'sub-11142'; 'sub-11143'; 'sub-11149'; 'sub-11156'};

%Step 2: Patients with sz.     
%subID = {'sub-50004'; 'sub-50005'; 'sub-50006'; 'sub-50007'; 'sub-50008'; 'sub-50010'; 'sub-50013'; 'sub-50014'; 'sub-50015'; 
%         'sub-50016'; 'sub-50020'; 'sub-50021'; 'sub-50022'; 'sub-50023'; 'sub-50025'; 'sub-50027'; 'sub-50029'; 'sub-50032'; 
%         'sub-50033'; 'sub-50034'; 'sub-50035'; 'sub-50036'; 'sub-50038'; 'sub-50043'; 'sub-50047'; 'sub-50048'; 'sub-50049'; 
%         'sub-50050'; 'sub-50051'; 'sub-50052'; 'sub-50053'; 'sub-50054'; 'sub-50055'; 'sub-50056'; 'sub-50058'; 'sub-50059'; 
%         'sub-50060'; 'sub-50061'; 'sub-50064'; 'sub-50066'; 'sub-50067'; 'sub-50069'; 'sub-50073'; 'sub-50075'; 'sub-50076'; 
%         'sub-50077'; 'sub-50080'; 'sub-50081'; 'sub-50083'; 'sub-50085'}; 
          
%Step 2: Patients with BPD.     
%subID =  {'sub-60001'; 'sub-60005'; 'sub-60006'; 'sub-60008'; 'sub-60010'; 'sub-60011'; 'sub-60012'; 'sub-60014'; 'sub-60015'; 
%    	   'sub-60016'; 'sub-60017'; 'sub-60020'; 'sub-60021'; 'sub-60022'; 'sub-60028'; 'sub-60030'; 'sub-60033'; 'sub-60036'; 
%		   'sub-60037'; 'sub-60038'; 'sub-60042'; 'sub-60043'; 'sub-60045'; 'sub-60046'; 'sub-60048'; 'sub-60049'; 'sub-60051'; 
%		   'sub-60052'; 'sub-60053'; 'sub-60055'; 'sub-60056'; 'sub-60057'; 'sub-60060'; 'sub-60062'; 'sub-60065'; 'sub-60066';
%          'sub-60068'; 'sub-60070'; 'sub-60072'; 'sub-60073'; 'sub-60074'; 'sub-60076'; 'sub-60077'; 'sub-60078'; 'sub-60079';
%          'sub-60080'; 'sub-60084'; 'sub-60087'; 'sub-60089'};

%Step 2: Patients with ADHD.     
%subID = {'sub-70001'; 'sub-70004'; 'sub-70007'; 'sub-70010'; 'sub-70015'; 'sub-70017'; 'sub-70020'; 'sub-70021'; 'sub-70022'; 
%         'sub-70026'; 'sub-70029'; 'sub-70033'; 'sub-70034'; 'sub-70037'; 'sub-70040'; 'sub-70046'; 'sub-70048'; 'sub-70049'; 
%         'sub-70051'; 'sub-70052'; 'sub-70055'; 'sub-70057'; 'sub-70058'; 'sub-70060'; 'sub-70061'; 'sub-70065'; 'sub-70068'; 
%         'sub-70069'; 'sub-70070'; 'sub-70072'; 'sub-70073'; 'sub-70074'; 'sub-70075'; 'sub-70076'; 'sub-70077'; 'sub-70079'; 
%         'sub-70080'; 'sub-70081'; 'sub-70083'; 'sub-70086}';

%Step 3: Define Connetivity matrix.
FC_1 = zeros(length(subID), 90000);
FC_2 = zeros(length(subID), 90000);

%Step 4: Create loop over subjects.
for i = 1:length(subID) 
    
    Variant = {'24P+8P_preproc'};%, '24P+8P_preproc', 'AROMAnonaggr_preproc+2P', 'AROMAnonaggr_preproc+2P+GSR'};
    
    for j = 1:length(Variant)
    
        %Step 5: Read in timeseries file. Here, rows=voxel timeseries; columns=volumes.
        TimeSeries = dlmread([DataDir,'/2_UCLA_Schaefer/',subID{i},'/TimeSeries/',subID{i},'_task-rest_variant-',Variant{j},'_Schaefer_ts.txt']);

        %Step 6: Split Timeseries into top and bottom half.      
        TimeSeries1 = TimeSeries(:,1:76); % automate the halves based upon the time-series inserted.
        TimeSeries2 = TimeSeries(:,77:end);
        
        %Step 7: Create a node-by-node correlation matrix for each Timeseries.    
        Corr_mat1 = corr(TimeSeries1');
        Corr_mat2 = corr(TimeSeries2'); 
                
        %Step 8: Convert the matrices to a vector (i.e., add the entire matrix into one column) for both time-points.    
        Corr_mat1_v = Corr_mat1(:); % use triu to extract data from above the diagonal
        Corr_mat2_v = Corr_mat2(:);

        %Step 9: Add in the vectorised matrices into the FC_1, and FC_2 cells created above.    
        FC_1 (i,:) = Corr_mat1_v;
        FC_2 (i,:) = Corr_mat2_v;
    end
end

%Step 10: Run the correlation between time-point 1, and 2 for each subject.
%ID_matrix = corr(FC_1', FC_2');
ID_matrix = corr(FC_1');

%Step 11: Create a matrix the size of subIDxSubID and put 1s off the diagonal, and 0s on the diagonal. Then identfiy each cell with 1s (off-diagonal elements) ignoring 0s (the diagonal)
idx = find(~eye(size(ID_matrix))); %indices of off-diagonal elements.

%Step 12: Calculate the ID score using the difference between the mean of the diagonal and off-diagonal elements.
IDScore = (mean(diag(ID_matrix))-mean(ID_matrix(idx)))*100; 

%Step 13: Generate and save correlation matrix.
figure 
imagesc(ID_matrix); 
colormap('jet');
colorbar;
ylabel('Subjects');
xlabel('Subjects');
title((['AROMAnonaggr_preproc+2P+GSR; Max IDScore =',num2str(IDScore)]), 'FontSize', 10);
%saveas(gcf, [DataDir,'/2_UCLA_dataset/UCLA_task-rest_AROMAnonaggr_preproc_2P_GSR'], 'png');
