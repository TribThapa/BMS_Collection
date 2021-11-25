clear; close all; clc;

% Load the data
load('/projects/kg98/Thapa/Sherena/RESTDATAonly/5_ColourWheelTask/colourWheelAll.mat');

% Plot the data

figure('color','w');

% Plot working memory capacity across loads
subplot(1,3,1)
for x = 1:size(wmCapacity,1)
    plot(1:3,wmCapacity(x,:),'-','color',[0.5,0.5,0.5]); hold on;
end
plot(1:3,mean(wmCapacity,1),'k-','linewidth',3);

set(gca,'box','off','tickdir','out','xlim',[0.5,3.5],'xtick',1:3,'xticklabel',{'2','4','6'});

xlabel('Load');
ylabel('Capacity (k)');

% Plot precision across loads
subplot(1,3,2)
for x = 1:size(precision,1)
    plot(1:3,precision(x,:),'-','color',[0.5,0.5,0.5]); hold on;
end
plot(1:3,mean(precision,1),'k-','linewidth',3);

set(gca,'box','off','tickdir','out','xlim',[0.5,3.5],'xtick',1:3,'xticklabel',{'2','4','6'});

xlabel('Load');
ylabel('Precision (SD)');

% Plot the relationship between precision and capacity for load 4

% First calculate the Pearson's correlation between the two
[r,p] = corr(wmCapacity(:,2),precision(:,2),'type','Spearman');

% Then calculate the line of best fit
pf = polyfit(wmCapacity(:,2),precision(:,2),1);
f = polyval(pf,wmCapacity(:,2));

% Plot the data
subplot(1,3,3)
scatter(wmCapacity(:,2),precision(:,2),'k.'); hold on;
plot(wmCapacity(:,2),f,'k-');

set(gca,'box','off','tickdir','out');
xlabel('Load 4 capacity (k)');
ylabel('Load 4 precision (SD)');
set(gca,'xlim',[0,4],'ylim',[0,60]);
text(0.5,55,{['rho=',num2str(round(r,2))],['p=',num2str(round(p,3))]});

set(gcf,'position',[396,438,1204,367]);
set(gcf,'PaperPositionMode','auto');
print(gcf,'-dpng','/projects/kg98/Thapa/Sherena/RESTDATAonly/5_ColourWheelTask/figure1');
