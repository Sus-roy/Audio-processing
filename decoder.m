clear all
% [recording,bit_length]=test_encode();
% Fs=44100;
[recording,fs] = audioread('new.wav');
recording;
figure
plot(recording);
Fs=fs
bit_length=8;

Lx = length(recording);
up = upChirp(0,800,Fs,0.02)';
down = downChirp(800,0,Fs,0.02)';
Lup = length(up);
Ldown= length(down);
Nfft = Lx + Lup - 1;
Nfft = 2^nextpow2(Nfft);

f1=fft(recording,Nfft);
f1=f1(1:Nfft/2);

f2=fft(up,Nfft);
f2=f2(1:Nfft/2);

length(f1);
length(f2);
convolution1 = f1 .* f2;

convolution1=abs(ifft(convolution1));
Nfft = Lx + Ldown - 1;
Nfft = 2^nextpow2(Nfft);

f3=fft(down,Nfft);
f3=f3(1:Nfft/2);

convolution2 = f1 .* f3;
convolution2=abs(ifft(convolution2));

len=length(recording);
convolution2=convolution2(1:len/2);
convolution1=convolution1(1:len/2);
len=length(convolution1);
len=length(convolution2);
sym=len/bit_length;


figure
plot(convolution1)
figure
plot(convolution2)

data_received = [];
Fs=44100;
data1=[];
data2=[];

for i=1:i+sym:length(convolution1)
    fprintf('%d\n',i);
    data1=[];
    data2=[];
for j=i:i+sym-1
    %fprintf('%d\n',j);
    if j > length(convolution1) 
        break
    end
    data1=[data1 convolution1(j)];
    data2=[data2 convolution2(j)];
end
    p=max(data1);
    q=max(data2);
    if p > q
        data_received =[data_received 0];
    end
    if q > p
        data_received =[data_received 1];
    end
end
data_received
str= bin2text(data_received)