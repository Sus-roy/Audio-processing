[audio, fs] = audioread('sample.wav');
f1 = 0;
fh = 200;
%fs = 200;
n = 0:1/fs:1;
phi = 2*pi*(f1*n + (fh-f1)*n.*n/2);
y = 0.5*sin(phi);
sign= f1+fh + 2^5;
fprintf('%i\n', phi);
q1 = audiorecorder;
sound(y,fs);
plot(y);
recordblocking(q1, 5);
w1 = getaudiodata(q1);

filename = 'saving_chirp_signal.wav';
audiowrite(filename,y,fs);



   
    
    