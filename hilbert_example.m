function hilbert_example(dat)
%% Hilbert Transform example
% This function runs a hilbert transform on pupil size data
% and plots the Hilbert unwrapped phase as done in : 
% http://www.cv-foundation.org/openaccess/content_cvpr_workshops_2014/W09/papers/Hossain_Understanding_Effects_of_2014_CVPR_paper.pdf
% if nargin < 1
%     dat = importfile;
% end
%% Compare unwrapped hilbert phases for result / regret / nonregret trials
resultPsize = dat.d.result1;
regretPsize = dat.d.result2(dat.d.regretCond==1,:);
nonregretPsize = dat.d.result2(dat.d.regretCond==2,:);
test = mean(dat.d.result1); test1=test-test(1); %Psize when seeing result');
test = mean(nonregretPsize); test2=test-test(1);%Psize seeing counterfactual(nonregret)');
test = mean(regretPsize); test3=test-test(1); %Psize seeing counterfactual(regret)');
%% Hilbert on Averages
f = figure; set(f,'Units','normalized','Position',[.2 .2 .8 .8]);
y = hilbert(test1); unp = unwrap(angle(y));
subplot(3,1,1); plot(unp); title('Unwrapped phase seeing result');
xlabel('Time');ylabel('Unwrapped Hilbert phase');
y = hilbert(test2); unp = unwrap(angle(y));
subplot(3,1,2); plot(unp); title('Unwrapped phase seeing counterfactual(nonregret)');  
xlabel('Time');ylabel('Unwrapped Hilbert phase');
y = hilbert(test3); unp = unwrap(angle(y));
subplot(3,1,3); plot(unp); title('Unwrapped phase seeing counterfactual(regret)');  
xlabel('Time');ylabel('Unwrapped Hilbert phase');

%% Hilbert on each
tvec = 1:120;
resultPsize = dat.d.result1;
regretPsize = dat.d.result2(dat.d.regretCond==1,:);
nonregretPsize = dat.d.result2(dat.d.regretCond==2,:);
fnc = @(M,i) M(i,:)-M(i,1);
y_resultPsize = []; y_regretPsize =[]; y_nonregretPsize = [];
for i = 1:size(resultPsize,1)
    x = fnc(resultPsize,i);
    x = hilbert(x);
    y_resultPsize(i,:) = unwrap(angle(x));
end
for i = 1:size(regretPsize,1)
    x = fnc(regretPsize,i);
    x = hilbert(x);
    y_regretPsize(i,:) = unwrap(angle(x));
end
for i = 1:size(nonregretPsize,1)
    x = fnc(nonregretPsize,i);
    x = hilbert(x);
    y_nonregretPsize(i,:) = unwrap(angle(x));
end
%
f = figure; set(f,'Units','normalized','Position',[.2 .2 .8 .8]);
subplot(3,1,1); plot(tvec, y_resultPsize, '-k'); title('Unwrapped phase seeing result'); 
xlabel('Time');ylabel('Unwrapped Hilbert phase');
subplot(3,1,2); plot(tvec, y_regretPsize, '-r'); title('Unwrapped phase seeing CF regret');
xlabel('Time');ylabel('Unwrapped Hilbert phase');
subplot(3,1,3); plot(tvec, y_nonregretPsize, '-b'); title('Unwrapped phase seeing CF nonregret');
xlabel('Time');ylabel('Unwrapped Hilbert phase');
%%

%%
% x=dat.intp.psize-dat.intp.psize(1);
% y=hilbert(x);
% t = 1:7677;
% plot(t,real(y),t,imag(y));
% legend('real','imaginary');
% title('Hilbert Transform');
% phi = angle(y);% Extract the phase component of Hilbert transform
% abs(y); % amplitude
%%
% figure;
% subplot(3,1,1); test = mean(dat.d.result1); test1=test-test(1);
% plot(test1); title('Psize when seeing result');
% subplot(3,1,2); test = mean(nonregretPsize); test2=test-test(1);
% plot(test2); title('Psize seeing counterfactual(nonregret)');
% subplot(3,1,3); test = mean(regretPsize); test3=test-test(1);
% plot(test3); title('Psize seeing counterfactual(regret)');
% % %% Hilbert on the averages
% x=test1;
% y=hilbert(x);
% t = 1:120;
% figure; subplot(3,1,1);
% plot(t,real(y),t,imag(y));
% legend('real','imaginary');
% title('Hilbert Transform when seeing result');y1=y;
%%
% figure
% plot(angle(y)); title('AP : Angular phase '); 
% figure
% plot(abs(y)); title('AA : Amplitude')% amplitude
%%
% figure; 
% unp = unwrap(angle(y));
% plot(unp); title('Unwraped phase');  
% % Whenver there is phase shift in the signal you see drops or jumps or elbows
% When components of the signal change.
% Unsuccessful tasks are marked and have higher fluctuations in ramp
% linear - consistent slope = signal not changing
% signal changes - elbow - scree 
% NEED TO EXAMINE IF IT IS AN ARTIFACT OF INTERPOLATION AND SIGNAL DROPOUT
end