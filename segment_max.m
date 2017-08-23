function [ c ] = segment_max( convolution1,a,b )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
d=[];
for i=a:b
    
    d =[d convolution1(i)];
        
end
c = max(d);
end

