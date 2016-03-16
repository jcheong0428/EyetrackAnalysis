function fourier_example(dat)
% This code does a fourier analysis on pupil size progression 
% You should pass in the dat data structure from dat=importfile();
% Compare pupilsize timeseries 
if nargin < 1
    dat = importfile;
end
%%
regretPsize = dat.d.result2(dat.d.regretCond==1,:);
nonregretPsize = dat.d.result2(dat.d.regretCond==2,:);
f=figure;set(f,'Units','normalized','Position',[.1 .8 1 1]);
subplot(4,1,1); plot(regretPsize');title('regretPsize (raw)'); xlabel('Time');ylabel('Pupil Size');
subplot(4,1,2); plot(nonregretPsize'); title('nonregretPsize (raw)');xlabel('Time');ylabel('Pupil Size');
% Centered at starting. 
for i = 1: size(regretPsize,1)
    cregretPsize(i,:) = bsxfun(@minus,regretPsize(i,:),regretPsize(i,1));
end
for i = 1: size(nonregretPsize,1)
    cnonregretPsize(i,:) = bsxfun(@minus,nonregretPsize(i,:),nonregretPsize(i,1));
end
subplot(4,1,3); plot(cregretPsize');title('regretPsize_ deviation from start'); xlabel('Time');ylabel('Pupil Size change');
subplot(4,1,4); plot(cnonregretPsize'); title('nonregretPsize_ deviation from start');xlabel('Time');ylabel('Pupil Size change');

%% Get selection of analaysis
test=regretPsize(4,:);
f=figure;set(f,'Units','normalized','Position',[.1 .8 1 1]);
subplot(4,1,1);plot(test');title('Timeseries of pupil size in regret trial # 4 (best trial)');
xlabel('Time');ylabel('Pupil Size');
yfft=fft(test);
yfft_mag = abs(yfft); yfft_ph = angle(yfft);
% stem(yfft_mag)
y=test;
Npoints = length(y);
F = [-Npoints/2:Npoints/2-1]./Npoints; % construct frequency axis
yfft_mag = fftshift(yfft_mag); % align output, see note below
subplot(4,1,2);stem(F,yfft_mag); title('Fourier analysis');ylim([0,300]);
xlabel('Frequency (Fs^{-1})');
% Get selection of anala 11,
test=nonregretPsize(11,:);
subplot(4,1,3);plot(test');title('Timeseries of pupil size in nonregret trial # 11 (best trial)');
xlabel('Time');ylabel('Pupil Size change');
yfft=fft(test);
yfft_mag = abs(yfft); yfft_ph = angle(yfft);
% stem(yfft_mag)
y=test;
Npoints = length(y);
F = [-Npoints/2:Npoints/2-1]./Npoints; % construct frequency axis
yfft_mag = fftshift(yfft_mag); % align output, see note below
subplot(4,1,4);stem(F,yfft_mag);title('Fourier analysis');ylim([0,300]);
xlabel('Frequency (Fs^{-1})');



% %% Get selection of analaysis
% test=mean(regretPsize);
% f=figure;set(f,'Units','normalized','Position',[.1 .8 1 1]);
% subplot(4,1,1);plot(test');title('Timeseries of pupil size in average regret trial');
% yfft=fft(test);
% yfft_mag = abs(yfft); yfft_ph = angle(yfft);
% % stem(yfft_mag)
% y=test;
% Npoints = length(y);
% F = [-Npoints/2:Npoints/2-1]./Npoints; % construct frequency axis
% yfft_mag = fftshift(yfft_mag); % align output, see note below
% subplot(4,1,2);stem(F,yfft_mag); title('Fourier analysis');ylim([0,300]);
% xlabel('Frequency (Fs^{-1})');
% % Get selection of anala 11,
% test=mean(nonregretPsize);
% subplot(4,1,3);plot(test');title('Timeseries of pupil size in average nonregret trial')
% yfft=fft(test);
% yfft_mag = abs(yfft); yfft_ph = angle(yfft);
% % stem(yfft_mag)
% y=test;
% Npoints = length(y);
% F = [-Npoints/2:Npoints/2-1]./Npoints; % construct frequency axis
% yfft_mag = fftshift(yfft_mag); % align output, see note below
% subplot(4,1,4);stem(F,yfft_mag);title('Fourier analysis');ylim([0,300]);
% xlabel('Frequency (Fs^{-1})');

%%%%%%%%%%%%%%%%%%%
%%
test = mean(dat.d.result1); test1=test-test(1);
test = mean(nonregretPsize); test2=test-test(1);
test = mean(regretPsize); test3=test-test(1);
%% 
test=test1;
f=figure;set(f,'Units','normalized','Position',[.1 .8 1 1]);
subplot(3,2,1);plot(test');title('Timeseries of pupil size in average seeing result')
xlabel('Time');ylabel('Pupil Size change');
yfft=fft(test);
yfft_mag = abs(yfft); yfft_ph = angle(yfft);
% stem(yfft_mag)
y=test;
Npoints = length(y);
F = [-Npoints/2:Npoints/2-1]./Npoints; % construct frequency axis
yfft_mag = fftshift(yfft_mag); % align output, see note below
subplot(3,2,2);stem(F,yfft_mag);title('Fourier analysis');ylim([0,150]);
xlabel('Frequency (Fs^{-1})');
%
test=test2;
subplot(3,2,3);plot(test');title('Timeseries of pupil size in average counterfactual(nonregret)')
xlabel('Time');ylabel('Pupil Size change');
yfft=fft(test);
yfft_mag = abs(yfft); yfft_ph = angle(yfft);
% stem(yfft_mag)
y=test;
Npoints = length(y);
F = [-Npoints/2:Npoints/2-1]./Npoints; % construct frequency axis
yfft_mag = fftshift(yfft_mag); % align output, see note below
subplot(3,2,4);stem(F,yfft_mag);title('Fourier analysis');ylim([0,150]);
xlabel('Frequency (Fs^{-1})');
%
test=test3;
subplot(3,2,5);plot(test');title('Timeseries of pupil size in average counterfactual(regret)')
xlabel('Time');ylabel('Pupil Size change');
yfft=fft(test);
yfft_mag = abs(yfft); yfft_ph = angle(yfft);
% stem(yfft_mag)
y=test;
Npoints = length(y);
F = [-Npoints/2:Npoints/2-1]./Npoints; % construct frequency axis
yfft_mag = fftshift(yfft_mag); % align output, see note below
subplot(3,2,6);stem(F,yfft_mag);title('Fourier analysis');ylim([0,150]);
xlabel('Frequency (Fs^{-1})');

end