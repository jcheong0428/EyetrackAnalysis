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
figure;
subplot(2,1,1); plot(regretPsize');title('regretPsize'); 
subplot(2,1,2); plot(nonregretPsize'); title('nonregretPsize');
%% Centered at starting. 
for i = 1: size(regretPsize,1)
    cregretPsize(i,:) = bsxfun(@minus,regretPsize(i,:),regretPsize(i,1));
end
for i = 1: size(nonregretPsize,1)
    cnonregretPsize(i,:) = bsxfun(@minus,nonregretPsize(i,:),nonregretPsize(i,1));
end
figure;
subplot(2,1,1); plot(cregretPsize');title('regretPsize_ deviation from start'); 
subplot(2,1,2); plot(cnonregretPsize'); title('nonregretPsize_ deviation from start');

%% Get selection of analaysis
test=regretPsize(4,:);
figure;
subplot(2,1,1);plot(test');title('Timeseries of pupil size in regret trial # 4 (best trial)');
yfft=fft(test);
yfft_mag = abs(yfft); yfft_ph = angle(yfft);
% stem(yfft_mag)
y=test;
Npoints = length(y);
F = [-Npoints/2:Npoints/2-1]./Npoints; % construct frequency axis
yfft_mag = fftshift(yfft_mag); % align output, see note below
subplot(2,1,2);stem(F,yfft_mag); title('Fourier analysis');ylim([0,300]);
xlabel('Frequency (Fs^{-1})');
%% Get selection of anala 11,
test=nonregretPsize(11,:);
figure; 
subplot(2,1,1);plot(test');title('Timeseries of pupil size in nonregret trial # 11 (best trial)')
yfft=fft(test);
yfft_mag = abs(yfft); yfft_ph = angle(yfft);
% stem(yfft_mag)
y=test;
Npoints = length(y);
F = [-Npoints/2:Npoints/2-1]./Npoints; % construct frequency axis
yfft_mag = fftshift(yfft_mag); % align output, see note below
subplot(2,1,2);stem(F,yfft_mag);title('Fourier analysis');ylim([0,300]);
xlabel('Frequency (Fs^{-1})');



%% Get selection of analaysis
test=mean(regretPsize);
figure;
subplot(2,1,1);plot(test');title('Timeseries of pupil size in average regret trial');
yfft=fft(test);
yfft_mag = abs(yfft); yfft_ph = angle(yfft);
% stem(yfft_mag)
y=test;
Npoints = length(y);
F = [-Npoints/2:Npoints/2-1]./Npoints; % construct frequency axis
yfft_mag = fftshift(yfft_mag); % align output, see note below
subplot(2,1,2);stem(F,yfft_mag); title('Fourier analysis');ylim([0,300]);
xlabel('Frequency (Fs^{-1})');
%% Get selection of anala 11,
test=mean(nonregretPsize);
figure; 
subplot(2,1,1);plot(test');title('Timeseries of pupil size in average nonregret trial')
yfft=fft(test);
yfft_mag = abs(yfft); yfft_ph = angle(yfft);
% stem(yfft_mag)
y=test;
Npoints = length(y);
F = [-Npoints/2:Npoints/2-1]./Npoints; % construct frequency axis
yfft_mag = fftshift(yfft_mag); % align output, see note below
subplot(2,1,2);stem(F,yfft_mag);title('Fourier analysis');ylim([0,300]);
xlabel('Frequency (Fs^{-1})');

%%%%%%%%%%%%%%%%%%%
%%
test = mean(dat.d.result1); test1=test-test(1);
test = mean(nonregretPsize); test2=test-test(1);
test = mean(regretPsize); test3=test-test(1);
%% 
test=test1;
figure; 
subplot(3,2,1);plot(test');title('Timeseries of pupil size in average seeing result')
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