function [ y1 ] = upChirp( f_low,f_high,sample_rate )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
clear varibales
if nargin == 0
    f1 = 0;
    fh = 800;
    fs=44100;
end
f1 = f_low;
fh = f_high;
fs=sample_rate;
n = 0:1/fs:1;
phi = 2*pi*(f1*n + (fh-f1)*n.*n/2);
y1 = 0.5*sin(phi);
sound(y1,fs);
end

