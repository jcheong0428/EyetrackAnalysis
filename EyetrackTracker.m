%% Real time eyetrack gui for matlab
fname = 'realtime';
[stat,~]=system('/Applications/EyeTribe/EyeTribe --framerate=30 &')
[stat,~]=system('python /Users/jinhyuncheong/EyetrackAnalysis/EyetribeFX/EyeTribe_Matlab_server.py &')
[success, connection] = eyetribe_init(fname);
%%
f = figure;set(f,'Units','normalized','Position',[.3 .5 .7 .5]);
ax1 = axes('Parent',f,'position',[0.10 0.29  0.70 0.665]);
%%
i = max(find(imts<=ts(zeta+24))); % Hardcoded +25 steps for syncing... Should find better way to do this.
img =imresize(d.imageArray{i},.5,'nearest');
implot = image(img,'Parent',ax1); implot.AlphaData=0.5; hold(ax1, 'off');
%%
set(ax1,'XLim',[0 1440],'YLim',[0 900],'YDir','reverse','xaxisLocation','top');

%%
success = eyetribe_start_recording(connection)
%%
success = eyetribe_log(connection, 'TEST_START')
%%
window = Screen('OpenWindow', 0,[],[0 0 720 450]);
success = eyetribe_calibrate(connection, window);
%%
hold(ax1, 'on'); 
for i = 1:60
    pause(0.0334)
    [success, x, y] = eyetribe_sample(connection)
    plot(x,y,'+','MarkerSize',10); 
    drawnow;
end

%%
success = eyetribe_stop_recording(connection)
%%
success = eyetribe_close(connection)
