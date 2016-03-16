% function hilbert_example(dat)
%% Hilbert Transform example
% if nargin < 1
%     dat = importfile;
% end

%%
regretPsize = dat.d.result2(dat.d.regretCond==1,:);
nonregretPsize = dat.d.result2(dat.d.regretCond==2,:);

x=dat.intp.psize;
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
figure; subplot(3,1,1);
plot(t,real(y),t,imag(y));
legend('real','imaginary');
title('Hilbert Transform when seeing result');y1=y;

x=test2;
y=hilbert(x);
t = 1:120;
subplot(3,1,2);
plot(t,real(y),t,imag(y));
legend('real','imaginary');
title('Hilbert Transform seeing counterfactual(nonregret)');y2=y;

x=test3;
y=hilbert(x);
t = 1:120;
subplot(3,1,3);
plot(t,real(y),t,imag(y));
legend('real','imaginary');
title('Hilbert Transform seeing counterfactual(regret)');y3=y;
%%
figure;
plot(t,y1,t,y2,t,y3); 
title('Hilbert Transform of pupil size for 3 conditioned (averaged)');
legend('Result','CF nonregret','CF regret');
% NEED TO EXAMINE IF IT IS AN ARTIFACT OF INTERPOLATION AND SIGNAL DROPOUT