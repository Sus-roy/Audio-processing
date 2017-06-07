function [ y2 ] = downChirp( f_low,f_high,sample_rate )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
clear varibales
if nargin == 0
    f1 = 800;
    fh = 0;
    fs=44100;
end
f1 = f_low;
fh = f_high;
fs=sample_rate;
n = 0:1/fs:1;
phi = 2*pi*(f1*n + (fh-f1)*n.*n/2);
y2 = 0.5*sin(phi);
sound(y2,fs);
end

