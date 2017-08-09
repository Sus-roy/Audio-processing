clear all
% [recording,bit_length]=test_encode();
% Fs=44100;
[recording,fs] = audioread('new.wav');
recording;
figure
plot(recording);

% Sampling rate and length of the transmitted code
Fs=fs
bit_length=8;

% Get length of the recording
Lx = length(recording);

% Generate up chirp signal for comparison
up = upChirp(0,800,Fs,0.02)';

% Generate down chirp signal for comparison
down = downChirp(800,0,Fs,0.02)';

% Get the length of the two signals
Lup = length(up);
Ldown= length(down);

if Lup ~= Ldown
    fprintf('Error, length of up and down signals does not match.\n');
    return
end

% Determine the appropriate length for FFT and the extent of zero padding
Nfft = Lx + Lup - 1;
Nfft = 2^nextpow2(Nfft);

% Perform FFT on the original recording
f1=fft(recording,Nfft);
f1=f1(1:Nfft/2);

% Perform FFT on the up and down chirps
f2=fft(up,Nfft);
f2=f2(1:Nfft/2);

f3=fft(down,Nfft);
f3=f3(1:Nfft/2);

% Derive envelopes for up and down chirp

%Up Chirp
convolution1 = f1 .* f2;
convolution1=abs(ifft(convolution1));

% Down Chirp
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