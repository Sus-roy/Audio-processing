clear all
clc
% [recording,code_length]=test_encode();
% Fs=44100;
fileID= fopen('set1.txt','r');
formatSpec = '%c';
s = fscanf(fileID,formatSpec);
code=text2bin(s);
fclose(fileID);
code_length=length(code);

[recording,fs] = audioread('s6n1_set1_phab1_chirp_200cm.wav');
Fs=fs;

figure
% plot(recording);
specgram(recording, 2048, 44100);
title('Spectrogram of recording')

%convolution with up chirp
Lx = length(recording);%nfft for recording
up = upChirp(16000,16500,Fs,0.02)';
%up=flipud(up)
Lup = length(up);
Nfft = Lx + Lup - 1;

f1=fft(recording,Nfft);
f1=f1(1:ceil(Nfft/2));

f2=fft(up,Nfft);
f2=f2(1:ceil(Nfft/2));

convolution1 = f1 .* f2;
convolution1=abs(ifft(convolution1));

%convolution with down chirp
Lx = length(recording);
down = downChirp(16500,16000,Fs,0.02)';
%down=flipud(down);
Ldown= length(down);
Nfft = Lx + Ldown - 1;
f3=fft(down,Nfft);
f3=f3(1:ceil(Nfft/2));

convolution2 = f1 .* f3;
convolution2=abs(ifft(convolution2));

%Finding maximum of each sysmbols(total 8 sysmbols in this case) in UP convolution
% figure
% plot(convolution1)
% title('Up convolution')

indexes_of_segments_up=findchangepts(convolution1,'MaxNumChanges',(code_length*2))
figure
findchangepts(convolution1,'MaxNumChanges',(code_length*2));
title('Convolution with up chirp (Segmented)')

data1=[];
for i=1:2:length(indexes_of_segments_up)-1
    data1=[data1 segment_max(convolution1,indexes_of_segments_up(i),indexes_of_segments_up(i+1))];
end
data1


%Finding maximum of each sysmbols(total 8 sysmbols in this case) in DOWN convolution
% figure
% plot(convolution2)
% title('Down convolution')

indexes_of_segments_down=findchangepts(convolution2,'MaxNumChanges',(code_length*2));
figure
findchangepts(convolution2,'MaxNumChanges',(code_length*2));
title('Convolution with down chirp (Segmented)')

data2=[];
for i=1:2:length(indexes_of_segments_down)-1
    data2=[data2 segment_max(convolution2,indexes_of_segments_down(i),indexes_of_segments_down(i+1))];
end
data2

%Find maximum values between convolutions with up and down
data_received = [];
for i=1:code_length
    if data1(i) > data2(i)
        data_received =[data_received 1];
    else
        data_received =[data_received 0];
    end
end
originalText = s
originalCode = code

decodedCode = data_received
decodedText= bin2text(data_received)
[numberOfBitError,errorRatio] = biterr(code,data_received)




