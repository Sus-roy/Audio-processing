function [ y1 ] = up( f_low,f_high,sample_rate,time )
if nargin == 0
    f_low = 0;
    f_high = 200;
    sample_rate =44100;
    time=100;
end
fs = sample_rate;
f1 = f_low;
fh = f_high;
t=time;
t1=linspace(0,t,t*fs);
y1= chirp(t1,f1,t,fh);
end
