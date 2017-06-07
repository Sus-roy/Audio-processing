function [ y1 ] = upChirp( f_low,f_high,sample_rate )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
%clear variables
if nargin == 0
    f_low = 0;
    f_high = 800;
    sample_rate =44100;
end
fs = sample_rate;
f1 = f_low;
fh = f_high;
n = 0:1/fs:1;
phi = 2*pi*(f1*n + (fh-f1)*n.*n/2);
y1 = 0.5*sin(phi);
sound(y1,fs);
end

