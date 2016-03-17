%% This function counts the visitations to the area of interest 

AOI = {}; % Cell structure of AOI: Rows are each AOI, column1: x coords column2: y coords
x1=[470 670 670 470 470];y1=[350 350 550 550 350]; % leftbox
x2=[770 970 970 770 770];y2=y1;
AOI{1,1}=x1;AOI{1,2}=y1;
AOI{2,1}=x2;AOI{2,2}=y2;
%%
plot(dat.intp.avgx(dat.intp.avgy~=0),dat.intp.avgy(dat.intp.avgy~=0));ylim([0, 900]);xlim([0 1440]);
set(gca,'XLim',[0 1440],'YLim',[0 900],'YDir','reverse','xaxisLocation','top');

%% Separate data into conditions

%% Regret visitation plot
sz = size(dat.d.regretx);
figure;
for i = 1:size(dat.d.regretx,1)
subplot(sz(1)/2,2,i);
plot(dat.d.regretx(i,:),dat.d.regrety(i,:));
set(gca,'XLim',[0 1440],'YLim',[0 900],'YDir','reverse','xaxisLocation','top');
end
%% non regret visitation plot
sz = size(dat.d.nonregretx);
figure;
for i = 1:size(dat.d.nonregretx,1)
subplot(sz(1)/2,2,i);
plot(dat.d.nonregretx(i,:),dat.d.nonregrety(i,:));
set(gca,'XLim',[0 1440],'YLim',[0 900],'YDir','reverse','xaxisLocation','top');
end
%%
% need to know which side is the Counterfactual (not chosen one)
CFchoice=mod(dat.d.response,2)+1;
ix = find(dat.d.regretCond==1);
for i = ix 
    roix = AOI{CFchoice(ix),1};
    roiy = AOI{CFchoice(ix),2};
    for i=2:length(dat.d.regretx)
        
    end
end