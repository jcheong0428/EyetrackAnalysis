function visitation_example(dat,AOI)
%% This function counts the visitations to the area of interest 
% Input:   AOI is a cell vector (n,2) of a polygon (not quite usefult at this stage because conditions are hardcoded)
%          n is the number of Areas, 
%          n,1 is the x coordinates of the nth area
%          n,2 is the y coordinates of the nth area 
% Output: 
%          This function plots the number of visitations to each AOI
%          for each condition
%
% Jin Hyun Cheong 2016.03.18
if nargin < 1
    dat = importfile; % load default file if no data provided 
elseif nargin <2
AOI = {}; % Cell structure of AOI: Rows are each AOI, column1: x coords column2: y coords
%% Original AOI too small
x1=[470 670 670 470 470];y1=[350 350 550 550 350]; % leftbox
x2=[770 970 970 770 770];y2=y1;
% AOI{1,1}=x1;AOI{1,2}=y1;
% AOI{2,1}=x2;AOI{2,2}=y2;
%% Larger AOI 
AOI{1,1}=x1;AOI{1,2}=[150 150 750 750 150];
AOI{2,1}=x2;AOI{2,2}=[150 150 750 750 150];
end
%% Plot of all the eyetrack data.
% figure;
% plot(x1,y1,'r-',x2,y2,'r-',dat.intp.avgx(dat.intp.avgy~=0),dat.intp.avgy(dat.intp.avgy~=0),'o');
% ylim([0, 900]);xlim([0 1440]);
% set(gca,'XLim',[0 1440],'YLim',[0 900],'YDir','reverse','xaxisLocation','top');

%% Regret visitation plot
sz = size(dat.d.regretx);
f=figure;set(f,'Position',[440 378 560 700]);
for i = 1:size(dat.d.regretx,1)
subplot(sz(1)/2,2,i);
plot(x1,y1,'r-',x2,y2,'r-',dat.d.regretx(i,:),dat.d.regrety(i,:),'o');
set(gca,'XLim',[0 1440],'YLim',[0 900],'YDir','reverse','xaxisLocation','top');
end
suptitle('Regret Condition Eyetrack Plot');
%% non regret visitation plot
sz = size(dat.d.nonregretx);
f=figure;set(f,'Position',[440 378 560 700]);
for i = 1:size(dat.d.nonregretx,1)
subplot(sz(1)/2,2,i);
plot(x1,y1,'r-',x2,y2,'r-',dat.d.nonregretx(i,:),dat.d.nonregrety(i,:),'o');
set(gca,'XLim',[0 1440],'YLim',[0 900],'YDir','reverse','xaxisLocation','top');
end
suptitle('nonRegret Condition Eyetrack Plot');
%%
CFchoice=mod(dat.d.response,2)+1; % which side is the Counterfactual (not chosen one)
ix = find(dat.d.regretCond==1);
regretvisits=[];
for i = 1:length(ix) 
    roix = AOI{CFchoice(ix(i)),1};
    roiy = AOI{CFchoice(ix(i)),2};
    visit = 0;
    for j=3:length(dat.d.regretx)
        if ~inpolygon(dat.d.regretx(i,j-1),dat.d.regrety(i,j-1),roix,roiy)
            if inpolygon(dat.d.regretx(i,j),dat.d.regrety(i,j),roix,roiy)
                visit = visit +1;
            end
        end
    end
    regretvisits(i) = visit;
end
%
CFchoice=mod(dat.d.response,2)+1; % which side is the Counterfactual (not chosen one)
ix = find(dat.d.regretCond==2);
nonregretvisits=[];
for i = 1:length(ix) 
    roix = AOI{CFchoice(ix(i)),1};
    roiy = AOI{CFchoice(ix(i)),2};
    visit = 0;
    for j=3:length(dat.d.nonregretx)
        if ~inpolygon(dat.d.nonregretx(i,j-1),dat.d.nonregrety(i,j-1),roix,roiy)
            if inpolygon(dat.d.nonregretx(i,j),dat.d.nonregrety(i,j),roix,roiy)
                visit = visit +1;
            end
        end
    end
    nonregretvisits(i) = visit;
end
f =figure;set(f,'Position',[440 378 800 420]);
subplot(1,2,1);
[a,b]=barerrorbar([mean(regretvisits) mean(nonregretvisits)]',[sem(regretvisits) sem(nonregretvisits)]');
title('Number of visits to the counterfactual choice','FontSize',14);
set(b,'LineWidth',5);
set(gca,'XTickLabel',{'Regret','nonRegret'},'FontSize',14)
xlim([.5 2.5]); 
colormap winter;

% Proportion of time in the AOI
CFchoice=mod(dat.d.response,2)+1; % which side is the Counterfactual (not chosen one)
ix = find(dat.d.regretCond==1);
regretvisits=[];
for i = 1:length(ix) 
    roix = AOI{CFchoice(ix(i)),1};
    roiy = AOI{CFchoice(ix(i)),2};
    regretvisits(i) = sum(inpolygon(dat.d.regretx(i,:),dat.d.regrety(i,:),roix,roiy))/length(dat.d.regretx(i,:));
end
CFchoice=mod(dat.d.response,2)+1; % which side is the Counterfactual (not chosen one)
ix = find(dat.d.regretCond==2);
nonregretvisits=[];
for i = 1:length(ix) 
    roix = AOI{CFchoice(ix(i)),1};
    roiy = AOI{CFchoice(ix(i)),2};
    nonregretvisits(i) = sum(inpolygon(dat.d.nonregretx(i,:),dat.d.nonregrety(i,:),roix,roiy))/length(dat.d.nonregretx(i,:));
end
subplot(1,2,2);
[a,b]=barerrorbar([mean(regretvisits) mean(nonregretvisits)]',[sem(regretvisits) sem(nonregretvisits)]');
title('Percent lingering in the counterfactual choice','FontSize',14);
set(b,'LineWidth',5);
set(gca,'XTickLabel',{'Regret','nonRegret'},'FontSize',14)
xlim([.5 2.5]); 
colormap winter;
end