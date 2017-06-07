clear varibales
[audio, fs] = audioread('sample.wav');
y1 =upChirp(0,200,fs);
y2 =downChirp(200,0,fs);
y=[y1 y2];
q1 = audiorecorder; %recorder intialize
sound(y,fs);%chirp sound playing
recordblocking(q1, 5);% recording started for 5 seconds
w1 = getaudiodata(q1); 
plot(y);
filename = 'saving_chirp_signal.wav';%saving audio
audiowrite(filename,y,fs) %if we change y to w1 thwn we save the recorede chirp. now its saving directly to directory.
