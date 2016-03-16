% function hilbert_example(dat)
%% Hilbert Transform example
% if nargin < 1
%     dat = importfile;
% end

%%
regretPsize = dat.d.result2(dat.d.regretCond==1,:);
nonregretPsize = dat.d.result2(dat.d.regretCond==2,:);

x=intp.psize;
y=hilbert(x);
t = 1:7677;
plot(t,real(y),t,imag(y));
legend('real','imaginary');
title('Hilbert Transform');
%%
figure;
subplot(3,1,1); test = mean(dat.d.result1); test1=test-test(1);
plot(test1); title('Psize when seeing result');
subplot(3,1,2); test = mean(nonregretPsize); test2=test-test(1);
plot(test2); title('Psize seeing counterfactual(nonregret)');
subplot(3,1,3); test = mean(regretPsize); test3=test-test(1);
plot(test3); title('Psize seeing counterfactual(regret)');
%% Hilbert on the averages
x=test1;
y=hilbert(x);
t = 1:120;
plot(t,real(y),t,imag(y));
legend('real','imaginary');
title('Hilbert Transform');
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

