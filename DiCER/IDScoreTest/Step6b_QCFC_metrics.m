clc; clear all; close all;

figFolder = '/projects/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/3_IdentificationScoreTest/3_UCLA_dataset_GordonAtlas/';
mFDVE = figure('color','white');
files={'UCLA_Gordon.mat'};
datasites={'UCLA_Gordon'};

% just loading here for odering for all pipelines
id_labels=tdfread('/home/ttha0011/kg98/Thapa/DiCER/1_ParametersProject/3_DiCERParamsTests/3_IdentificationScoreTest/ScriptsUsed/ROIs/Gordon/CommunityModified.txt');
id_all = id_labels.DA;
id_all = ['DA ';id_all]; % need to add DA to the first row, as its treated as a column header.
all_types = unique(id_all,'rows'); % returns same values as id_all, but with no repetitions.

for j=1:size(all_types,1),
    all_types_cell{j} = all_types(j,:);
end

% Order parcels baed upon the asceding order defined above (refer to 'unique' flag).
ids_cell = cell(size(all_types,1),1);

for j=1:size(id_all,1)
	id_find = find(strcmp(id_all(j,:),all_types_cell));
	ids_cell{id_find,1} = [ids_cell{id_find,1},j];
end

% For plotting:
all_idz=cell2mat(ids_cell.');

for j=1:length(ids_cell),
    nums(j) = numel(ids_cell{j}); % gives you the number of parcels in each network.
end

line_breaks = cumsum(nums); % get cumulative sum of parcels for each network. 
line_breaks = line_breaks(1:end-1);
pos_labels = cumsum(nums) - nums/2; % get difference between cumulative sum values, and its half.


% ------------------------------------------------------------------------------
% QC-FC distance dependence
% ------------------------------------------------------------------------------

for opendataset=1:1,		
	disp(['DATASET: ',datasites{opendataset},'.............']);
	load([figFolder,files{opendataset}])
    N_methods = 3;
	numPrePro= 3;
	plotting=1;
    allQC = allQC(1:3);
    first_pc = first_pc(:,:);
	FC=FC(:,:,:,:);
    
    noiseOptions = noiseOptions(1:3);
	noiseOptions = noiseOptions(1:N_methods);

	FSize=8;
	fh = figure('color','white');
	hold on;
	tempColors = num2cell([255,105,97;97,168,255;178,223,138;117,112,179;255,179,71;255,231,152;]./255,2);  
	col_vec=[1 4 2 3 5 6];
	theColors = tempColors(col_vec);
    
    % Plot QC-FC distance-dependence. QC-FC correlations are split into 10 bins based on the distance between nodes. 
    % Circle: mean distance between edges; Solid line: mean edge value; Standard deviation: dotted line of QC-FC correlation are shown.
	for j=1:N_methods,
		subplot(ceil(N_methods/2),2,j)
		%subplot(1,3,j)
		BF_PlotQuantiles(ROIDistVec(allQC(j).NaNFilter),allQC(j).QCFC,11,0,0,tempColors{col_vec(j)})
		hold on;
		plot([0:180],zeros(1,181),'--','Color','k','LineWidth',2)
		xlabel('distance (mm)')
		ylabel('QC-FC')
		set(gca,'fontSize',8)
		title(noiseOptions{j},'fontSize',8,'Interpreter','none')
		% text('FontSize',24,'BoxOpacity',0,'Font','Arial Bold')
		ylim([-0.1 0.4])
		xlim([0 185])
    end
            
        if(plotting)
        saveas(gcf, [figFolder,'/QCFC_DistanceDependence_',datasites{opendataset}], 'png');
        end


% ------------------------------------------------------------------------------
% QC-FC distance dependence
% ------------------------------------------------------------------------------

% Creating a bar chart for QC
x = noiseOptions;
xy = cell(x);
for i = 1:length(x)
	xy{i} = x{i};
end
        
Fig_QCFC_Dist = figure('color','w', 'units', 'centimeters', 'pos', [0 0 16 9], 'name',['Fig_QCFC_Dist']); box('on'); movegui(Fig_QCFC_Dist,'center');
sp = subplot(2,3,[2:3]);
if(opendataset~=2)
    text(0,-25,'A','fontSize',8,'fontWeight','bold')
else
    text(0,-25,'C','fontSize',8,'fontWeight','bold')
end
pos = get(sp,'Position');

% Create data
data = {[allQC(:).QCFC_PropSig_unc]'};
data_std = cell(1,length(data)); [data_std{:}] = deal(zeros(size(data{1})));

% Create table
T = table(data{1},'RowNames',noiseOptions,'VariableNames',{'QCFC_PropSig'})

% Create bar chart
clear extraParams
extraParams.xTickLabels = xy;
extraParams.xLabel = ''; % 'Pipeline'
% extraParams.yLabel = 'QC-FC (%)';
extraParams.yLabel = 'QC-FC uncorrected (%)';
extraParams.theColors = theColors;
extraParams.theLines = {'-','-','-','-','-','-'};
extraParams.yLimits = [0 40];
extraParams.FSize = 8;
TheBarChart(data,data_std,false,extraParams);
set(gca,'fontSize',8)
ax = gca;
      	
% Set axis stuff
ax.FontSize = FSize;
% ------------------------------------------------------------------------------
% QCFC distributions
% ------------------------------------------------------------------------------
sp = subplot(2,3,[4:6]);
data2 = {allQC(:).QCFC};
yy=get(gca,'Ylim');
xlim([-0.6 1]);

if(opendataset~=2)
    text(-.7,yy(2),'B','fontSize',36,'fontWeight','bold');    
else
    text(-.7,yy(2),'D','fontSize',36,'fontWeight','bold');
end
	
% pos = get(sp,'Position');
% set(gca,'Position',[pos(1)*1, pos(2)*1.2, pos(3)*1.4, pos(4)*1]); % [left bottom width height]
clear extraParams
extraParams.theLabels = {allQC(:).noiseOptions};
extraParams.customSpot = '';
extraParams.add0Line = true;
extraParams.theColors = theColors;
BF_JitteredParallelScatter(data2,1,1,0,extraParams);
ax = gca;

% % Set axis stuff
ax.FontSize = FSize;
% ax.XTick = [1:size(data{1},1)];
ax.XTick = [];
ax.XTickLabel = [];
ax.XLim = ([0 numPrePro+1]);
ylabel('QC-FC (Pearson''s r)')

% add text 
TextRotation = 0;
strprec = '%0.2f';
data3 = {allQC(:).QCFC_AbsMed};

text(1:size(data3,2),repmat(ax.YLim(2) - ax.YLim(2)*.05,1,size(data3,2)),num2str([data3{1,:}]',strprec),... 
    'HorizontalAlignment','right',... 
	'VerticalAlignment','middle',...
	'Color','black',...
	'FontSize', FSize,...
	'Rotation',TextRotation)

view(90,90)

if(plotting)
    saveas(gcf, [figFolder,'/QCFC_metrics_uncorr_',datasites{opendataset}], 'png');
end


lbs{1,1} = {'A'};lbs{1,2} = {'D'};
lbs{2,1} = {'B'};lbs{2,2} = {'E'};
lbs{3,1} = {'C'};lbs{3,2} = {'F'};
	
% Take average of FC matrices
m2 = squeeze(mean(tanh(FC),3));
fc_mat = figure('color','white');

for j=1:N_methods,
    subplot(2,N_methods,j)
    m3 = m2(:,:,j);
    % imagesc(m3(all_idz,all_idz));
    imagesc(m2(:,:,j));
    axis image
    if(j==1)
        caxis([-0.3,0.3]);
    else
        caxis([-0.1,0.1]);
    end

    set(gca,'YDir','normal','fontSize',4);
    lb_col=[0.5 0.5 0.5];
    text(-100,380,lbs{j,1},'fontSize',4,'fontWeight','bold')

	title(noiseOptions{j},'fontSize',4,'Interpreter','none')
    colormap([flipud(BF_getcmap('blues',9,0));[1,1,1],;BF_getcmap('reds',9,0)])
    p=colorbar;
    pp=get(p,'Limits');
    set(p,'Ticks',[pp(1) 0 pp(2)]);
    axis off
    subplot(2,N_methods,j+N_methods);
    fc_nm = m2(:,:,j);
    mat = find(triu(ones(333,333),1));
    bb=linspace(-0.5,0.5,50);

	xlabel('Pearson''s r');
    % ylabel('Density');
    set(gca,'fontSize',8,'box','on','YTick',[],'XTick',[-0.4 0 0.5 1])
		
	Ypos=get(gca,'YLim')
    xlim([-0.4 1]);
    text(-0.7,Ypos(2),lbs{j,2},'fontSize',8,'fontWeight','bold')
end

if(plotting)
    saveas(gcf, [figFolder,'/QCFC_FC_average_mat_',datasites{opendataset}], 'png');
end



VE_violin = figure('color','white');

for j=1:N_methods,
    data2{j} = first_pc(:,j);
end

%rain_test;
xlabel('VE by 1st PC (%)')

% add text
TextRotation = 0;
strprec = '%0.2f';
for j=1:N_methods,
    data3{j} = median(first_pc(:,j))
end

% 	% Max for VE1 for AROMA+2P
% 	[vv,ii] = max(h1{2}.XData)
% 	sub_l=plot([h1{2}.XData(ii),h2{2}.XData(ii),h3{2}.XData(ii)],[h1{2}.YData(ii),h2{2}.YData(ii),h3{2}.YData(ii)],'k*','MarkerSize',10);
% 	legend([h1{1} h2{1} h3{1} sub_l], [noiseOptions,metadata.ParticipantID(ii)]);
% 
% 	figure;plot(cell2mat(data2));set(gca,'XTickLabel',metadata.ParticipantID,'XTickLabelRotation',90,'XTick',[1:length(data2{1})])
% 
% 	if(plotting)
%         saveas(gcf, [figFolder,'/VE_',datasites{opendataset}], 'png');
% 		%savePng(VE_violin,[figFolder,'/VE_violin',datasites{opendataset}],[25 15]);
% 	end

	
for nm=1:N_methods,
    figure(mFDVE);
    subplot(3,3,nm + (opendataset-1)*3)
    r = corr(metadata.fdJenk_m,first_pc(:,nm));
    plot(metadata.fdJenk_m,first_pc(:,nm),'.','MarkerSize',18,'Color',theColors{nm});
    text([max(metadata.fdJenk_m)/2],35,['R^2=',num2str(r)],'fontSize',8);
    title(noiseOptions{nm},'fontSize',8,'Interpreter','none')
    xlabel('mFD (mm)');ylabel('1st PC VE (%)');
    ylim([0 40])
    set(gca,'fontSize',8);
end

if(plotting)
    saveas(gcf, [figFolder,'QCFC_mFDVE_',datasites{opendataset}], 'png');
end
end

