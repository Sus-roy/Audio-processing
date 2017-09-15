function [  x ] = upChirp( f_low,f_high,sample_rate,time )
if nargin == 0
    f_low = 20000;
    f_high = 20500;
    sample_rate =44100;
    time=1;
end
fs = sample_rate;
f1 = f_low;
fh = f_high;
t=time;
t1=linspace(0,t,t*fs);
t0=t1(1);
T=t-t0;
k=(fh-f1)/T;
x=cos(2*pi*(k/2*t1+f1).*t1);
%plot(t1,x);
end
