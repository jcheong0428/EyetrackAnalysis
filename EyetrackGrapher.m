function EyetrackGrapher(varargin)
%EyetrackGrapher. Graphs the eyetracking data from Eyetribe
%   Plots the sampling rate, number of samples, and interpolation rate 
%   along with an interactive graph of gaze location, pupil size, and event, 
%   at each sample point. 
%
% Example:
%   dat = importfile;
%   EyetrackGrapher(dat);
%
% Jin Hyun Cheong
% Psychological Brain Sciences
% Dartmouth College
if length(varargin) < 1 % if no argument load default file
    dir = pwd;
    fn = 'regret_2016-03-15_s01_r01.mat.tsv';
    filename = [dir,'/data/test/regret_2016-03-15_s01_r01.mat.tsv'];
    filename2 = [dir,'/data/test/regret_2016-03-15_s01_r01.mat'];
    [pre,post,intp,header]= importfile(filename);
    load(filename2,'d');
elseif length(varargin) == 1 % if an argument
    if isstruct(varargin{1}) % if a struct data, use that
        post = varargin{1}.post;
        intp = varargin{1}.intp;
        header = varargin{1}.header;
        d = varargin{1}.d;
    elseif ischar(varargin{1}) % if a string passed, load that filename
        dir = pwd;
        fn = varargin{1};
        filename = [dir,'/data/test/',fn];
        filename2 = [dir,'/data/test/',fn(1:end-4)];
        [pre,post,intp,header]= importfile(filename);
        load(filename2,'d');
    end
end    
imts = (d.timeArray-d.timeArray(1))*1000;
%%
global xs ys zs event event_i d post intp b bplay; 
global f af zeta t1 t2 ax1 ax2 ax3 ax4 x1 x2 y1 y2 imts ts;
warning('off','MATLAB:handle_graphics:exceptions:SceneNode')
xs = post.avgx; % xcoordinate
ys = post.avgy; % y coordinate
zs = smooth(post.psize); % pupil size
ts = post.time-post.time(1);
samplingrate = 1000/mode(diff(post.time));
samples = length(xs);
interpolationrate = intp.intpRate*100; % in percentage
fn = header.fn;
%%
event = post.event_cell; % event cell 
event_i = post.event_ix;
x1=[470 670 670 470 470];y1=[350 350 550 550 350];
x2=[770 970 970 770 770];y2=y1;
zeta = 1;   % Time
af = 40; % pupil size amplification factor
f = figure;set(f,'Units','normalized','Position',[.1 .1 1 1]);
%%
plotbase();
b = uicontrol('Parent',f,'Style','slider','Units','normalized','Position',[0.10 -.10 0.82 0.20],...
              'value',zeta, 'min',1, 'max',length(xs),'SliderStep',[1/length(xs) 0.01],'Callback',@b_callback);
bgcolor = f.Color;
bl1 = uicontrol('Parent',f,'Style','text','Units','normalized','Position',[0, 0, .2,.05],...
                'String','0','BackgroundColor',bgcolor); % for min value
bl2 = uicontrol('Parent',f,'Style','text','Units','normalized','Position',[.81,0,.2,.05],...
                'String',mat2str(length(xs)),'BackgroundColor',bgcolor); % for the max value
bl3 = uicontrol('Parent',f,'Style','text','Units','normalized','Position',[.4,0,.2,.05],...
                'String','Time point','BackgroundColor',bgcolor); % for text explanation

p = uipanel(f,'Title','Data info',...
             'Position',[0.82 0.29  0.1 0.4]);
b1 = uicontrol(p,'Style','pushbutton','String','Raw Data',...
                'Units','normalized','Position',[.1 .11 .8 .1],'Callback',@b1_callback);
b2 = uicontrol(p,'Style','pushbutton','String','Interpolated Data',...
                'Units','normalized','Position',[.1 0 .8 .1],'Callback',@b2_callback);
b3 = uicontrol(p,'Style','text','Units','normalized','Position',[.1, .65, .8, .35],'HorizontalAlignment','left',...
                'String',sprintf('File : %s',fn),'BackgroundColor',bgcolor); % Show file name
b4 = uicontrol(p,'Style','text','Units','normalized','Position',[.1, .52, .8, .12], 'HorizontalAlignment','left',...
                'String',sprintf('Sampling Rate : %2.1f Hz',samplingrate),'BackgroundColor',bgcolor); % Show sampling rate
b5 = uicontrol(p,'Style','text','Units','normalized','Position',[.1, .4, .8, .12],'HorizontalAlignment','left',...
                'String',sprintf('Samples : %d ',samples),'BackgroundColor',bgcolor); % Show number of samples
b6 = uicontrol(p,'Style','text','Units','normalized','Position',[.1, .25, .8, .12],'HorizontalAlignment','left',...
                'String',sprintf('Interpolation rate : %2.1f%%',interpolationrate),'BackgroundColor',bgcolor); % Show number of samples
bplay = uicontrol('Parent',f,'Style','togglebutton','String','Play Stream',...
                'Units','normalized',...
                'Position',[.53,.0,.1,.05],'Callback',@bplay_callback);
end
function b_callback(es,ed)
    %% Left and right button functions are defined here.
    global xs ys zs event event_i d; 
    global zeta af ax1 ax2 ax3 ax4 x1 x2 y1 y2 ts imts;
    zeta = floor(es.Value);
    sz=0;
    for i = 1:min(zeta,100) % Determines the size of the crosshair
        if zeta-i~=0 && abs(xs(zeta)-xs(zeta-i)) < 100 && abs(ys(zeta)-ys(zeta-i)) < 100
            sz=sz+1;
        end
    end
    %%
    plot(ax1,x1,y1,'b-',x2,y2,'b-',xs(floor(es.Value)),ys(floor(es.Value)),'+','MarkerSize',10+sz); hold(ax1,'on')
    i = max(find(imts<=ts(zeta+24)));
    img =imresize(d.imageArray{i},.5,'nearest');
    implot = image(img,'Parent',ax1); implot.AlphaData=0.3; hold(ax1, 'off');
    %%
    set(ax1,'XLim',[0 1440],'YLim',[0 900],'YDir','reverse','xaxisLocation','top');
    title(ax1,'Gaze Location'); 
    %%
    scatter(ax2,1,1,af*zs(floor(es.Value)),'filled');
    title(ax2,'Pupil Size');
    set(ax2,'YTickLabel',{},'XTickLabel',{},'XLim',[.9 1.1],'YLim',[.9 1.1],'yaxisLocation','right');
    plot(ax3,floor(es.Value)*ones(length([0:max(zs)]),1),[0:max(zs)],[1:length(zs)],zs);
    set(ax3,'XLim',[0 length(zs)],'XLim',[0 length(zs)],'YLim',[0 max(zs)],'yaxisLocation','right');
    title(ax3,'Pupil Size');
    plot(ax4,floor(es.Value)*ones(length([0:.1:1.2]),1),[0:.1:1.2],[1:length(event_i)],event_i);
    set(ax4,'XLim',[0 length(xs)],'XLim',[0 length(xs)],'YLim',[0 1.2],'yaxisLocation','right');
    title(ax4,'Event');
    text(length(xs)/2,.5,event{floor(es.Value)},'FontSize',14);
end
function b1_callback(hObject, eventdata, handles)
% non-interpoloated data
global xs ys zs event event_i post; 
xs = post.avgx; % xcoordinate
ys = post.avgy; % y coordinate
zs = smooth(post.psize); % pupil size
event = post.event_cell; % event cell 
event_i = post.event_ix;
plotbase()
end
function b2_callback(hObject, eventdata, handles)
% interperlaoted data
global xs ys zs event event_i intp; 
xs = intp.avgx; % xcoordinate
ys = intp.avgy; % y coordinate
zs = smooth(intp.psize); % pupil size
event = intp.event_cell; % event cell 
event_i = intp.event_ix;
plotbase();
end
function bplay_callback(hObject, eventdata, handles)
    global b zeta xs bplay
    while get(bplay,'Value')
        zeta = zeta+10;
        if zeta > numel(xs) % reset if out of bounds
            zeta = 1;
        end
        set(b,'Value',zeta);
        b_callback(b);
        drawnow
        WaitSecs(.05);
    end
end
function plotbase()
%%
global xs ys zs event event_i d post intp; 
global f af zeta t1 t2 ax1 ax2 ax3 ax4 x1 x2 y1 y2 imts ts;
    sz=0;
    for i = 1:min(zeta,100)
        if zeta-i~=0 && abs(xs(zeta)-xs(zeta-i)) < 100 && abs(ys(zeta)-ys(zeta-i)) < 100
            sz=sz+1;
        end
    end
% ax1 = axes('Parent',f,'position',[0.10 0.39  0.70 0.54]);
ax1 = axes('Parent',f,'position',[0.10 0.29  0.70 0.665]);
%%
% plot(ax1,x1,y1,'b-',x2,y2,'b-',xs(zeta),ys(zeta),'+','MarkerSize',10+sz); hold(ax1, 'on');
plot(xs(zeta),ys(zeta),'+','MarkerSize',10+sz); hold(ax1, 'on');
i = max(find(imts<=ts(zeta+24))); % Hardcoded +25 steps for syncing... Should find better way to do this.
img =imresize(d.imageArray{i},.5,'nearest');
implot = image(img,'Parent',ax1); implot.AlphaData=0.5; hold(ax1, 'off');
%%
t1 = text(617.7500, 346.0242,'Gaze Location');
t2 = text(1.0000, 10.0242,'Pupil Size');
set(ax1,'Title',t1,'XLim',[0 1440],'YLim',[0 900],'YDir','reverse','xaxisLocation','top');

ax2 = axes('Parent',f,'position',[0.82 0.7  0.1 0.24]);
scatter(ax2,1,1,af*zs(zeta),'filled');
set(ax2,'Title',t2,'YTickLabel',{},'XTickLabel',{},'XLim',[.9 1.1],'YLim',[.9 1.1],'yaxisLocation','right');

ax3 = axes('Parent',f,'position',[0.10 0.22 0.82 0.05]);
plot(ax3,zeta*ones(length([0:max(zs)]),1),[0:max(zs)],[1:length(zs)],zs);
set(ax3,'XLim',[0 length(zs)],'XLim',[0 length(zs)],'YLim',[0 max(zs)],'yaxisLocation','right');
title(ax3,'Pupil Size')

ax4 = axes('Parent',f,'position',[0.10 0.15 0.82 0.05]);
plot(ax4,zeta*ones(length([0:.1:1.2]),1),[0:.1:1.2],[1:length(event_i)],event_i);
set(ax4,'XLim',[0 length(xs)],'XLim',[0 length(xs)],'YLim',[0 1.2],'yaxisLocation','right');
title(ax4,'Event')
text(length(xs)/2,.5,event{zeta},'FontSize',14);
end